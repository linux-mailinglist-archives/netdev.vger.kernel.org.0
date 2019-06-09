Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394D93A36E
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfFICx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:53:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41985 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfFICx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:53:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id l19so571701pgh.9
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 19:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uXrdIeqF0wM/99tB32J0M129t5fTlWH4o+Lxchf5W30=;
        b=hz6up6PW+DIt6VltYel63aw9r0z3wjQEPMPvTy2ABRyr0KVStYCU/mrJKJrIhOeOlV
         TAHNlBseYMKpvyc+2PzRdeMwHT+0OreqZDjE2z0eyR7FyzcaWhhXCRLfX4fQKOe45j9L
         jdL+YxYvfj3xUr06Gw+Wnl9Gz24MUfltKM4Fe1l2kAj9wnPURhC/+LE7NKVtdoXoBq4+
         5+Q2PTy5PAe3F9zeFLajFZQV/p93FhkXl/Hd3xys9qtIOUkDRvq/kDnPQRlASmjnPhcS
         pWHMGsRW6gCgVEcz+5uDB8fHJR86g8kGpMbIt0D3VJT8Lh2pKg+UarPqUwYeaWdBr5nr
         WDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uXrdIeqF0wM/99tB32J0M129t5fTlWH4o+Lxchf5W30=;
        b=nm6OVxLgJAok3Uvq+GZ3J4dtOsl5a5ZQ2kshf6A6YR+qBT2gwyFFjSQp7c9hVXaV5l
         mRIUPpzDqNft02fd0Saokxxl0SnU21zoks8rJMmnsW6Os41BcfHXPF+0kHDXVby7L49o
         +0Do/gvZ0Ip0qqVjYhe2KcFmdaWTPTHded5kCksIimmunqOw9VyvseRScJvSqZ7GnqK2
         gOOi0nghFnq4Y6XLGGJPO8Yvobn7bizGFldPOQpfocsb2ok4BsvPvb7AaYWtuhUl1PdA
         TR/ww/YfTrOuWYirnEnGdVIXarjG6kg8Eyj+bjd2PZZFuN8bcWNHrq7fXpnL478ZoNvT
         7Uzg==
X-Gm-Message-State: APjAAAWK2zHKb9mdF/Ij4Aq5Gr5ZV58MY53Ehsqw/ORa1lP3IC2a1t4U
        El7rTWYACJL3kLz0Cmx7pP4u2fDC
X-Google-Smtp-Source: APXvYqxPPe5Icsk8MxvEe4W6uGzLa6aB+TgfuPAv/mehfe3sKKj7GsqlusybWAL/eCXWSHtJ/dIfkg==
X-Received: by 2002:a65:530d:: with SMTP id m13mr10009832pgq.68.1560048808055;
        Sat, 08 Jun 2019 19:53:28 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id v64sm12253352pfv.172.2019.06.08.19.53.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 19:53:27 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: dsa: sja1105: Update some comments
 about PHYLIB
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <74357f83-fcf8-93d5-ae4b-f6b100782fba@gmail.com>
Date:   Sat, 8 Jun 2019 19:53:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608130344.661-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/2019 6:03 AM, Vladimir Oltean wrote:
> Since the driver is now using PHYLINK exclusively, it makes sense to
> remove all references to it and replace them with PHYLINK.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
