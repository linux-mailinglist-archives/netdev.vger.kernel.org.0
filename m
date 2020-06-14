Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0BF1F8B27
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 00:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFNWfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 18:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgFNWfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 18:35:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54231C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 15:35:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f185so12960299wmf.3
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 15:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TE8nuRsohpoo8sk/aAN4ESTYjivEu4wONYaYKts0plU=;
        b=r//0EGqxYtreO46EFPugrm6Gp2Mz2OwfbX7skrpQaz6FESdsu4FO+P0Ho2RNB9qOM4
         qzP1nLPujtl+ZNj7WCHaO0vf8H0xg6qUH6DEcjyCSf8FNuneTpcB+w8PYaG2A/KnaY6Z
         30VhMdOzMZfomN2S7ajI45W+cuZxrvmDO7hP5e3TEryclxGv31Yxaek44l2PeSPcX6qR
         zfrht1G749RLgP3syugVsdoNZMsdYXMUxAlGg4++QoR8DiihDIkzN/OJqPl0Dn5aKSls
         kZ926NUsBwvX3qgCpdibUcBrmxb1oMZdDus1At7FDa3JJDwi1l/z58B73VhyW3HhIGo1
         JRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TE8nuRsohpoo8sk/aAN4ESTYjivEu4wONYaYKts0plU=;
        b=c1nJ+O+JoMjx0HQjcM2e/QGx7OZVzqZbfPL5s8iKZtntSwAIYhRYltB6FODAzn/440
         Gof7tqoUDO8gCgfAPuNd/kkO5yIJC2yWYlgtFvSfI1eZRzWma2AWA3Z+WB2ZdTADAO+i
         TdS+hhtR9Z4c/yNx1yldMGMZN65PNOAc8Si9to7rMFpoMyDsouYGrlrPfiSb//JiShA3
         B+odRNl0LQ9rQ+TIPMZt4R2sP2W4idxVADfcKX4Fvykp1rMUk+7N0yBqM71QTdoREezl
         Xp/L/X9qBpyCLGeAFRnM8t3lpWyhjrL38rxE4nsQ8AWYMKP/sl+Nq/WRKgr6J39PpDYi
         5P9g==
X-Gm-Message-State: AOAM533jMIBC4NrbrqKQHGqfdyg9/FsI2mPJIXSr4GK38XbCM1JPLC6o
        THEsvBXRwI6HcDzgQAqHkDnXtfKa
X-Google-Smtp-Source: ABdhPJzW8tBd7WTyv3slu8GMSK1tra8A14W8lJUXrexrQEw1HNGMx803IgzqfalrQXFIUxxxCcPB0g==
X-Received: by 2002:a1c:3c89:: with SMTP id j131mr9744501wma.59.1592174136385;
        Sun, 14 Jun 2020 15:35:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:3132:54b5:47df:1bd8? (p200300ea8f235700313254b547df1bd8.dip0.t-ipconnect.de. [2003:ea:8f23:5700:3132:54b5:47df:1bd8])
        by smtp.googlemail.com with ESMTPSA id d9sm21575585wre.28.2020.06.14.15.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 15:35:35 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
 <20200610115350.wyba5rnpuavkzdl5@lion.mk-sys.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b7c7634e-8912-856a-9590-74bd3895d1ed@gmail.com>
Date:   Mon, 15 Jun 2020 00:35:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610115350.wyba5rnpuavkzdl5@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.06.2020 13:53, Michal Kubecek wrote:
> On Wed, Jun 10, 2020 at 12:50:30PM +0200, Heiner Kallweit wrote:
>> On 10.06.2020 11:13, Michal Kubecek wrote:
>>> Just to make sure you are hitting the same problem I'm just looking at,
>>> please check if
>>>
>>> - your kernel is built with ETHTOOL_NETLINK=n
>>
>> No, because I have PHYLIB=m.
>> Not sure what it would take to allow building ethtool netlink support
>> as a module. But that's just on a side note.
> 
> Yes, this is the unfortunate fallout of the new dependency between
> ETHTOOL_NETLINK and PHYLIB introduced with the cable diagnostic series.
> As "make oldconfig" silently disables ETHTOOL_NETLINK when PHYLIB=m,
> many people won't even notice. Even I fell for this when I suddently
> noticed my testing merge window snapshot has ETHTOOL_NETLINK disable.
> I guess we will have to find some nicer solution.
> 

Seems that disabling ETHTOOL_NETLINK for PHYLIB=m has (at least) one
more side effect. I just saw that ifconfig doesn't report LOWER_UP
any longer. Reason seems to be that the ioctl fallback supports
16 bits for the flags only (and IFF_LOWER_UP is bit 16).
See dev_ifsioc_locked().

> Michal
> 
Heiner
