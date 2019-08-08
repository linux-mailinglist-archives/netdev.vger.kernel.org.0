Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9E186B78
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404800AbfHHUY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:24:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45926 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404761AbfHHUYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:24:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so5896225wrj.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 13:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YxB2ijBa0B5JnLTqETqv8NUiNPz90Lza2sxT0kXPChg=;
        b=IiP0AQ7cJOlhG4pdC7uJrqHZ0W/BtrteFcmmCGTotoWSeXJ1thQzxiRC2bjoWpjyFh
         q2awT4RuCeVqBzkaRe7L0dOURsGxLx9oHA4wXXTQZpAFZqnYQPBAmpHzaL1b14NBZJy1
         JGwKo6l2M0J5+K8LJh9FmDm+utDiyEVZqh9ToD/kkpM+Kt/++0hB6sbSmka2aESm2qx8
         /nn3hZ4eaMeyOmnnUiGJacB+1TfdEq67MbW0sbwwSsGPO1RPwmqRD7559aXkJfmjuxzL
         QjrRGQ1RNxkcJcjA/d6Mdk5PvsbdfCKxU5HSURM1H0ssa1ZIfgmOBvZ1PcoyMi5M8KHq
         OsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxB2ijBa0B5JnLTqETqv8NUiNPz90Lza2sxT0kXPChg=;
        b=Q+pYMQL1RphxRGiMn1AB+GFsnYO+8sPs5bRfWuQftbpjQuxwR1Wga325n9/EdKnnyS
         EToHSuYcsAyx1g0+n0lzDU8A0eyFfnXqOOHlXtvYjWG5BOSS4WnRJYPKj7F60ddhHtjj
         NvSW5cYZrdS4/F9+LRhE39GvutecQWW1cmsSOWYNeoUioOligfHjisjaFOtv+610MILK
         A4Wyb4YtdvQwBvrHt8WVw9BlRP3hdtS64W6w6x/i/azBQRrArUGYECnqeRQ7V0KCA1eS
         kneR7oHq17lak11/XPIx4zG3ZEga5VgagNYqA9a0zzCmq34RzlqcGexPTYXbdr5R1p2F
         x2vg==
X-Gm-Message-State: APjAAAWEcYrh/dVQlaF4Hnxw72P2vFOyUMdtHeb0jH8HvCPGgeBp4IDk
        QYALZ47JfrSmt6oiRwvdK9XSTItQ
X-Google-Smtp-Source: APXvYqyk2Z1oH4vJLwO3SEBAZxamrpz/pqmBfKyzbnTqqiBtRZ9Y9Gli6cKjhXZVkfwkf2Z3U13QYQ==
X-Received: by 2002:a5d:6409:: with SMTP id z9mr6620444wru.308.1565295893415;
        Thu, 08 Aug 2019 13:24:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id n14sm183286224wra.75.2019.08.08.13.24.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 13:24:52 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
 <20190808193743.GL27917@lunn.ch>
 <f34d1117-510f-861f-59f0-51e0e87ead1e@gmail.com>
 <20190808202029.GN27917@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <94cc3fe3-98ed-d8d2-2444-84bf3eae0c5e@gmail.com>
Date:   Thu, 8 Aug 2019 22:24:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808202029.GN27917@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 22:20, Andrew Lunn wrote:
>> I have a contact in Realtek who provided the information about
>> the vendor-specific registers used in the patch. I also asked for
>> a method to auto-detect 2.5Gbps support but have no feedback so far.
>> What may contribute to the problem is that also the integrated 1Gbps
>> PHY's (all with the same PHY ID) differ significantly from each other,
>> depending on the network chip version.
> 
> Hi Heiner
> 
> Some of the PHYs embedded in Marvell switches have an OUI, but no
> product ID. We work around this brokenness by trapping the reads to
> the ID registers in the MDIO bus controller driver and inserting the
> switch product ID. The Marvell PHY driver then recognises these IDs
> and does the right thing.
> 
> Maybe you can do something similar here?
> 
Yes, this would be an idea. Let me check.

>       Andrew
> 
Thanks, Heiner

