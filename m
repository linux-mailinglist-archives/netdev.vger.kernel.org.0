Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A861F57CC
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgFJP1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgFJP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 11:27:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49A6C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:27:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d66so1246490pfd.6
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=99lu7OGjD4W/povKYaghJn6flRW2Ygui72q6uHON1Zs=;
        b=ceGdxjXxJNF5xdXSQNN0naZg7cU/DNOlugWVIbzc2+6gFf4+4db3uvbdsHazWxB/zR
         58yfZIixGeMji6xymodwwEHWy1pRmMG7oEAxETaaADy9FPxZeQeaxvHZUQQrNwOv1c7U
         HfDb4JPFTU6wGfqPwRq8CqRxW2G0PSaX+NIoSfh15zCbJ+PNQpSK421meC6poMk08oel
         X/K6hyc6HerTKedsxrpF0dW9Pl7SmhrBIeyEk3Kk2ERzr2KfUraSP2qwbjRNRAfQbMdz
         XSeg9+EBS36AfFgDhpiasUj8kMxR465QhV+abZ2ooEiPQslUVsdHxadiJjSQ6FuM/E+J
         ddCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=99lu7OGjD4W/povKYaghJn6flRW2Ygui72q6uHON1Zs=;
        b=rE/try57f1M98M4SMSIl/P4JafazvxKychGJWU85SYRfmHSPY2K9//Unbfu6ROL8Nb
         k1uBRuUe4/Ep3c63ykQrcp07RqhSLL7DgbNfhr0reVJT7CiT+vMJLh4pIR9rWfj3ZS21
         jANqDz/FfGV4RShQHKGJ8BXDrcIE4wvJlBgIisVGDYdnDqFztCQ5ZBjmfa6RzUfxMGuF
         NJNgya2/oKz6NMShGuUH/bCFy17E7ogiVLs2iooR75s9B0YO2wVHT/Nrbo7/vkZhSQzx
         +crRfDEzRGmaLiRI9oLslisADNsRFVYXhY06MujyKxUaHmkU7Heu93M9StSIGpOzAIPI
         45Ag==
X-Gm-Message-State: AOAM53389aROBd39/dB26uav703gwHpaMqSRyYhhjSE+moc0lsP5tt5p
        bdXQXtsQH0K8N6fzqF43HskuNhjv
X-Google-Smtp-Source: ABdhPJxncv+KxL9qXzK3gf/wPT+u0wz5iWwAasg8WxiQtJsLInapi9FyrlQ/hhAg3vR9F2sFmtenlw==
X-Received: by 2002:aa7:9a91:: with SMTP id w17mr3330010pfi.199.1591802832541;
        Wed, 10 Jun 2020 08:27:12 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n1sm255576pfd.156.2020.06.10.08.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 08:27:11 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0353ce74-ffc6-4d40-bf0f-d2a7ad640b30@gmail.com>
Date:   Wed, 10 Jun 2020 08:27:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/2020 3:50 AM, Heiner Kallweit wrote:
> On 10.06.2020 11:13, Michal Kubecek wrote:
>> On Wed, Jun 10, 2020 at 10:52:26AM +0200, Heiner Kallweit wrote:
>>> On 10.06.2020 10:26, Heiner Kallweit wrote:
>>>> Since ethtool 5.7 following happens (kernel is latest linux-next):
>>>>
>>>> ethtool -s enp3s0 wol g
>>>> netlink error: No such file or directory
>>>>
>>>> With ethtool 5.6 this doesn't happen. I also checked the latest ethtool
>>>> git version (5.7 + some fixes), error still occurs.
>>>>
>>>> Heiner
>>>>
>>> Bisecting points to:
>>> netlink: show netlink error even without extack
>>
>> Just to make sure you are hitting the same problem I'm just looking at,
>> please check if
>>
>> - your kernel is built with ETHTOOL_NETLINK=n
> 
> No, because I have PHYLIB=m.
> Not sure what it would take to allow building ethtool netlink support
> as a module. But that's just on a side note.

Not sure it makes sense to build ETHTOOL_NETLINK as a module, but at
least ensuring that ETHTOOL_NETLINK is built into the kernel if PHYLIB=y
or PHYLIB=m would make sense, or, better we find a way to decouple the
two by using function pointers from the phy_driver directly that way
there is no symbol dependency (but reference counting has to work).
-- 
Florian
