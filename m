Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85465136FE
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfEDCKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:10:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33558 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:10:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id y3so3570573plp.0;
        Fri, 03 May 2019 19:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sF39PmI+hI8aYeXDsFGDI6w4Rd0yg4fptlp3XMYoOy4=;
        b=Xpo11m0WVvYDtRFS2O0pdFsLwZ0ifu59snC8vJ1En8dxdaYAMd9qotoMMqsldL/22O
         9d6/eJqPTHdD3UPqD9ZjNERxFC98KDxolRvs3ypQNB8XHVJX1Ra6pxz0Mdiv3x4/yk+G
         rn/EZEgLdFLMM9uQUM4liYBgklHJ4zJH5tD97V/9IrEnwvQEK8I56ZrhrpX5EVli0YwN
         4eS9PJX4w2K7wvkrg2+ZmU5fe3j//RpfYzWyPqcYKioy4SYEWDTPk+HJQRTHTzRM9tBn
         xwdpJQsgqEYOr35eEmZZBYgNMpZBkhVPYVU5p2qGu8OPyp4DuECznpAiCKpOrYgLw88o
         tamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sF39PmI+hI8aYeXDsFGDI6w4Rd0yg4fptlp3XMYoOy4=;
        b=cC0pTgoOGzX2xeonh8XdZL4QwRbMpUKq7pJiVVNZ8xNFhupC8qND7bs2oEF12JBGsK
         EGf9fGgGNvlcPJVSlffrFgc83jHy5bLilKyCNwcAx0fUXvppPv3OOUpjbCp2R8xDUeLY
         0pBMOKH52n+wgXUhRmj88eL5AC6YtXJVKZ/A5GdGjrGwVgE9fepM+qmcueOh5xahKh6T
         GuDRWUhRhlBeYfZIdurell1iJNPSS2G8VEvtQwTRsRiL/Q87hZr3MVkK9lUp6VAwK5zh
         d4820+1eZvsC8NTmobeWjbDEEbqThy6GiNIRqMDn5Y8fq3MgPAZnyWK88GNRfqpzuhlU
         XArQ==
X-Gm-Message-State: APjAAAVjhVsC5SyqchD1uEfm1HdWPK1HA+OGG4n1fXuB7lQjY7xXLBuF
        dTOsiOsMtRWzzO4r+plaTVSjYuWd
X-Google-Smtp-Source: APXvYqz4jyuclZWqQdmnMF0TZWlWMBgP1u9lLv4tcdb2xBpS4NZb4pgEuIULPxFPfzBAANlvcwp2gg==
X-Received: by 2002:a17:902:5c6:: with SMTP id f64mr1063260plf.208.1556935854563;
        Fri, 03 May 2019 19:10:54 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id m6sm3800089pgq.0.2019.05.03.19.10.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 19:10:53 -0700 (PDT)
Subject: Re: [PATCH net-next 8/9] net: dsa: sja1105: Add support for Spanning
 Tree Protocol
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504011826.30477-1-olteanv@gmail.com>
 <20190504011826.30477-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <d9c279f8-d2b1-c99f-fa30-b4810bd7b293@gmail.com>
Date:   Fri, 3 May 2019 19:10:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504011826.30477-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> While not explicitly documented as supported in UM10944, compliance with
> the STP states can be obtained by manipulating 3 settings at the
> (per-port) MAC config level: dynamic learning, inhibiting reception of
> regular traffic, and inhibiting transmission of regular traffic.
> 
> In all these modes, transmission and reception of special BPDU frames
> from the stack is still enabled (not inhibited by the MAC-level
> settings).
> 
> On ingress, BPDUs are classified by the MAC filter as link-local
> (01-80-C2-00-00-00) and forwarded to the CPU port.  This mechanism works
> under all conditions (even without the custom 802.1Q tagging) because
> the switch hardware inserts the source port and switch ID into bytes 4
> and 5 of the MAC-filtered frames. Then the DSA .rcv handler needs to put
> back zeroes into the MAC address after decoding the source port
> information.
> 
> On egress, BPDUs are transmitted using management routes from the xmit
> worker thread. Again this does not require switch tagging, as the switch
> port is programmed through SPI to hold a temporary (single-fire) route
> for a frame with the programmed destination MAC (01-80-C2-00-00-00).
> 
> STP is activated using the following commands and was tested by
> connecting two front-panel ports together and noticing that switching
> loops were prevented (one port remains in the blocking state):
> 
> $ ip link add name br0 type bridge stp_state 1 && ip link set br0 up
> $ for eth in $(ls /sys/devices/platform/soc/2100000.spi/spi_master/spi0/spi0.1/net/);
>   do ip link set ${eth} master br0 && ip link set ${eth} up; done
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
