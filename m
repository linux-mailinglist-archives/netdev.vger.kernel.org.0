Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFF51C433D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgEDRsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgEDRsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:48:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BA9C061A0E;
        Mon,  4 May 2020 10:48:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so18325plq.12;
        Mon, 04 May 2020 10:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0YqP8VecB2UmToDpnEaiYt/EjUvvCgEGjmA2T6HOWIA=;
        b=fze/N73aF0T0xDDZ9EvDTavgTrx7OOs9+P8+jDDYp/iG7xAbRoPZZgYjiHrNRftuqi
         gxBfqiF55Jt43mLXDIoZxgMMW2hGd08bO8E8vjxTjnxOkykodaVdfVWS2ievBhDjJ3Hm
         XVKvsUBfBb/eP1VwzntNMkKjgGlDoxyQFd4yngkMmFkHGeLBYG6f+1s/zQK0k4AkCcqD
         WSORyabSj14nrudCoPiC10dEh7zBx49ywPouXJOBIX6FzL8fGZKGIa0dVVFSK4IsRc0E
         SZo8SnUUVlLNk3UnUpN+zSEssVjxbPIyf+tzU8VIh41eu+gjko5qJYLtmz0blKW9MEZl
         4qJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YqP8VecB2UmToDpnEaiYt/EjUvvCgEGjmA2T6HOWIA=;
        b=SMsg5LaidiQ/RhsbPhekIYC1NDMbXkbGRtM9+Ctta3+0sV9W03FjNpXzpQgi7XMjhb
         9ken2B+gXxkY7pgtuNk5WwONkVtkg1fOOEicTS/SROsuwB35QVM4FAlMWljaIwgk+9La
         tdb9WFVn+ysQe2UbGF5DWeu97eZbmuw+vGkO+8CyW/0y8IbeEmI75+KL2rsFaysVqfkB
         QvX8+6/n1M7VQE1OpLNRAaSZj6bD+q/x7ktN2UDCQ7d7GbR6KwCyDr2J7hts3OhATFGE
         ZMoYlwCEX0GrPQDcyfxi+S6/twOc2MArD0pgoXsbmHYxu76mB6rmYkdZnnQGrnV+YLdB
         c2jQ==
X-Gm-Message-State: AGi0PuYlJEEIxwjuxaSkgVgeW7IhvR6gdSNfQRwaJDVISQYcIwJ0/i7Y
        rTWNm71/ssqyMAnIehLqhvg=
X-Google-Smtp-Source: APiQypLr2jwuAnm1jNRaW+Ddm4ybkhMe5FmAfgXl619Lj25y3qbkURxTMQdu/z08bXQtKrtADpCv+g==
X-Received: by 2002:a17:902:fe03:: with SMTP id g3mr380567plj.28.1588614520869;
        Mon, 04 May 2020 10:48:40 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i9sm9403353pfk.199.2020.05.04.10.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:48:40 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next] net: dsa: felix: allow the device to be
 disabled
To:     Michael Walle <michael@walle.cc>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
References: <20200504165228.12787-1-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a2284212-bc13-5221-acf0-188c2965416d@gmail.com>
Date:   Mon, 4 May 2020 10:48:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504165228.12787-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 9:52 AM, Michael Walle wrote:
> If there is no specific configuration of the felix switch in the device
> tree, but only the default configuration (ie. given by the SoCs dtsi
> file), the probe fails because no CPU port has been set. On the other
> hand you cannot set a default CPU port because that depends on the
> actual board using the switch.
> 
> [    2.701300] DSA: tree 0 has no CPU port
> [    2.705167] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> [    2.711844] mscc_felix: probe of 0000:00:00.5 failed with error -22
> 
> Thus let the device tree disable this device entirely, like it is also
> done with the enetc driver of the same SoC.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
