Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13181F8DA4
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgFOGU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgFOGU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 02:20:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9408FC061A0E
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 23:20:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l10so15724526wrr.10
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 23:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HD2MTNZStx0AvLOygI2NdFPQlX2nd4K3cu+XRlm6JzA=;
        b=CL69OAG5Ycp8nieHfTIGmQAVbM7Z+2hfKvZ1vDiqYTwEAtccBypk7aFMnd5KU2th0v
         /jKqDmhV6SK+YVOhZPrlN5N+hoWODYed8jT5yDlO+Rw2YR8U68/pur/KbX02b7ga2T09
         qeU0ZJ+29ACCMa3NifeVSsGO1F00IFCO0l6SPep5qqkyyDPvZHJ/A70+JQhQNdKmTl/y
         CgVPssYYzZLSWrl3Sd1xYD5fwTdgAKP/omuAVybZOqNCTe1ySKXp9VmnDcbsiAqldR3a
         O9cZCSWtEFOIkDc+AcQp/0TbfkPnyI/hFgITEfFo4NxV26eZxHr8OeknaKh+csuFsoJQ
         vXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HD2MTNZStx0AvLOygI2NdFPQlX2nd4K3cu+XRlm6JzA=;
        b=FJTvRXUX9doThXBaxIDB+C/3+stugEiRAUguvRYbCkf6DiwGi/yfD59yO9BcY/mBAn
         HhZxReeqX0VYOdywNh5K7w5N/289nDQ3s0pp/L95VHSo3yBo5h1cxyw0Jq+cmb7blEhT
         8KsZV3qNg3ngKTMpFLXebq24m1gMcgdQ0HTa+8ra2/qz6VPLIIT+xjdyWQtVI/E0pTIE
         tHmLebsiaW0QCFdMq2c7/X3dy+IDp2aWiE9v+NrEt5XsToZ+XuJT5XN3rbQflPlHqs2y
         oda6X9W2Et2oMRddKVCai9c3foMDQGSWmIcYyuULuek3P1Sz2Tz+C+M9PaZeQmL6RIDm
         q7uQ==
X-Gm-Message-State: AOAM533NXE+cEomiIY1gq9kxP07rVKfam/PikMTN7C1r8uceigsnjwMz
        Yj9DvQ0tNGvwffQxMiU569Y0dcZ7
X-Google-Smtp-Source: ABdhPJxgVEQemRatbam0X2jTTVCUexQSZE3mHvQrr3Si/m61oMeo5FUDH6ODxJF6n3VFwXPGQrjB9w==
X-Received: by 2002:adf:a1c1:: with SMTP id v1mr27925024wrv.205.1592202027077;
        Sun, 14 Jun 2020 23:20:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:4ca0:eba1:b3ff:3702? (p200300ea8f2357004ca0eba1b3ff3702.dip0.t-ipconnect.de. [2003:ea:8f23:5700:4ca0:eba1:b3ff:3702])
        by smtp.googlemail.com with ESMTPSA id y5sm23708779wrs.63.2020.06.14.23.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 23:20:26 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
 <20200610115350.wyba5rnpuavkzdl5@lion.mk-sys.cz>
 <b7c7634e-8912-856a-9590-74bd3895d1ed@gmail.com>
 <20200614232607.itigyaqamm5sql63@lion.mk-sys.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cd26de60-493f-4c91-e411-e515a3e3f2d6@gmail.com>
Date:   Mon, 15 Jun 2020 08:20:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200614232607.itigyaqamm5sql63@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.06.2020 01:26, Michal Kubecek wrote:
> On Mon, Jun 15, 2020 at 12:35:30AM +0200, Heiner Kallweit wrote:
>> Seems that disabling ETHTOOL_NETLINK for PHYLIB=m has (at least) one
>> more side effect. I just saw that ifconfig doesn't report LOWER_UP
>> any longer. Reason seems to be that the ioctl fallback supports
>> 16 bits for the flags only (and IFF_LOWER_UP is bit 16).
>> See dev_ifsioc_locked().
> 
> I don't think this is related to CONFIG_ETHTOOL_NETLINK; AFAIK ifconfig
> does not use netlink at all and device flags are certainly not passed
> via ethtool netlink.
> 
Right, my bad. Just mixed up the output of ifconfig and "ip link",
ip link says LOWER_UP whilst ifconfig says RUNNING.

> Michal
> 
Heiner
