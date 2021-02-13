Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E043131A96A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhBMBQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBMBQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:16:48 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2809BC061756;
        Fri, 12 Feb 2021 17:16:08 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z7so725575plk.7;
        Fri, 12 Feb 2021 17:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+iBCVfCBjrMgs5a9o2EKnVJAAnesaHogIEXgXYwhMSY=;
        b=jOyBDv9ORy2bAnO5OGjhG5CfwW9mE7+6i4IehDMYZMgStncmfsTx5Gi940QSCan0iA
         Aakp3sHMgYudRsohQ+ZZChKohJj64TWqntg0DZQm2b63KC5tOi4qzdOc1IAm2Qf4HG1Q
         ahXSj54tUdHmhNIPmQvLrdN0sC6augXBIbrGpwUtRsb9Itr8EHXPoT9zBBDul8BZ1xnq
         7z/CSUR5YuMl0JVKWsZBSwd6cS25UK2fQ19MOxZfmD9Zs5p+4/otaIR7XyvL1vnSmitA
         CGoz/SYQhgffg4D9Ao07AMDy/fKS0v7PnB5qVqgWYrjXUklyToyw2pjjic22OxNr1akq
         z63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+iBCVfCBjrMgs5a9o2EKnVJAAnesaHogIEXgXYwhMSY=;
        b=peJRKiSvngEKFKvhCTeE4z0AyVDgtGerfZOd/9DUrtPAAsANIVe5N5rs8q2LLjjuCe
         AEowLAWCmti/TBJWf+F+jgFTV4w7SVJHlnvodvSAnTBdFA+hSgUnKt3gAJT2V/9sjYiN
         aCTimifHdeJRWc5b4/P3IvvxXJIX3atlKeuCO5HQmGtVkOGaMnII4TbwHpeat5Gzqgqf
         9Mt5n6KXhEgLnbB06QQbNCDckVoYC4OT9dTlmxUiB+QPiAR7VTbGze2TuaLJ23JKjRJv
         tHbbTWc8bmvNOzqZSw6yPmzIQSqFHj+gIluqYv79CVYC47vDJYvCM1h2TNgg/ab5aJ0v
         L1iQ==
X-Gm-Message-State: AOAM530QHk6qKLKsZo9q7qk8QoKYz+BFvHnoxNqW8zY5yffGcTN58XLN
        Rex7mT9GNL0/xlRBEkB+40R0cYNn0Js=
X-Google-Smtp-Source: ABdhPJyfveU7yQ5Oc5hILlr54w5SH93A5DOebsIcPc+UtY7+URe/6NHJaYFH4la4J36KUQnJoIXyJg==
X-Received: by 2002:a17:903:22cc:b029:de:191c:1bdb with SMTP id y12-20020a17090322ccb02900de191c1bdbmr5331519plg.14.1613178967704;
        Fri, 12 Feb 2021 17:16:07 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t21sm9897850pfe.174.2021.02.12.17.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:16:07 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: Remove unused flags
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-2-f.fainelli@gmail.com>
 <20210213005659.enht5gsrh5dgmd7h@skbuf>
 <5cd03eea-ece8-7a81-2edc-ed74a76090ba@gmail.com>
 <20210213011453.k7mwchp6nxo5iks6@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b0fc0d82-36d0-7d54-c17c-ac4475fd0d21@gmail.com>
Date:   Fri, 12 Feb 2021 17:16:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213011453.k7mwchp6nxo5iks6@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 5:14 PM, Vladimir Oltean wrote:
> On Fri, Feb 12, 2021 at 05:08:58PM -0800, Florian Fainelli wrote:
>> That's right, tg3 drove a lot of the Broadcom PHY driver changes back
>> then, I also would like to rework the way we pass flags towards PHY
>> drivers because tg3 is basically the only driver doing it right, where
>> it checks the PHY ID first, then sets appropriate flags during connect.
> 
> Why does the tg3 controller need to enable the auto power down PHY
> feature in the first place and the PHY driver can't just enable it by
> itself?
> 

That would be a question for Michael if he remembers those details from
12 years ago.
-- 
Florian
