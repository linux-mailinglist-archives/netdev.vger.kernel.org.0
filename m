Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66BA24E7F9
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 16:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgHVOxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgHVOxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 10:53:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA613C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:53:06 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u18so4398580wmc.3
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rsfTdIZlzlp6v6/9FY+n53R865/n8X+wd2kFCkliI5A=;
        b=MRKBFy3RDWzovrJKKTM6yJGo7WCe90/TBKWqJYvsciwRqGaHmENS7BN5L2kndRoGPQ
         FWE9ECJUef6gefPaHQu9zmBEu6TZCvAtRBwMcIQ+6EgFpj5Dy7isKw6xpE5aUrBNMdAm
         TlAqR6TCMsjT0fMcQHiVw6SMn39J2it2eqXWiUkRvP6DnXsW0wsv4FUUFFD/qANggpvj
         kaLwASHPy48kQCxAoT6mFNQzfo4dzAUB/dvZTr/QobZ6hnzqLsD8Frzn/MHTXaWfIYqA
         ofz56HYZqDlNuhe+7vVFr/ef9CJY0iPPVgupGqtANDksyZcu3KHkRFFYeoNwW/2rm+R0
         uH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rsfTdIZlzlp6v6/9FY+n53R865/n8X+wd2kFCkliI5A=;
        b=gjQnlGO/XNI2DJz2WPgoSyUZ9pqkzkc5Sg+uekPcfjprLqfii1N+iGRP0NqpbxpcAj
         RFwaOxWsIfTFkdF0KCu1BczdyNTZ1VUvUSwjTdOW40dsJyCQCKwjykjtGxErCMI+e3gu
         zy5na3u4FRPZSdVsUBep0uaVITc1/u7iO8kKhiE/ta/zNJgfTqd5xLpVZXITDU84/OSz
         /jB8ZvzePgrJkw3N/F6xSQ0D751GNEeQNG/RpzV/U0D0UmIlLzM4/O30UlpsSCJH0blz
         PRCDnbobZawtmuswSMUVP3vG51F/gHzorGKwkdfAaKLNdNCguTjGtx9LxbrMvVcCKJ7/
         pQ7w==
X-Gm-Message-State: AOAM532a1d/toXzImvNc9wSN3CIcSd2Q7caAH2A40YPSICyrzNi2aHvJ
        YZDIoIvOU/YOc3jiVMSqllZcs20AgYRVgg==
X-Google-Smtp-Source: ABdhPJwVIjTnyy53xqx/VnxOTgP1LrwJBmo6M0z7N5mZ0FEeZz7brZYwz6scDnPNRfiP/ZpmZsxVKg==
X-Received: by 2002:a7b:c205:: with SMTP id x5mr8438919wmi.161.1598107984574;
        Sat, 22 Aug 2020 07:53:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:70a8:5c89:59f4:9d99? (p200300ea8f23570070a85c8959f49d99.dip0.t-ipconnect.de. [2003:ea:8f23:5700:70a8:5c89:59f4:9d99])
        by smtp.googlemail.com with ESMTPSA id c10sm2678884wmk.30.2020.08.22.07.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 07:53:03 -0700 (PDT)
Subject: Re: missing support for certain realtek 8125-chip
To:     netdev@dvl.sh-ks.net, netdev@vger.kernel.org
References: <3a4a8e07-f77f-1225-242c-fb1648cc47c5@dvl.sh-ks.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <564153af-6fb8-2d01-e08e-af256bf17091@gmail.com>
Date:   Sat, 22 Aug 2020 16:52:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <3a4a8e07-f77f-1225-242c-fb1648cc47c5@dvl.sh-ks.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2020 09:27, netdev@dvl.sh-ks.net wrote:
> hi.
> 
> we've got a odroid h2+ from hardkernel with two realtek 8125 chips
> onboard, but the r8169-driver doesn't work with them.
> 
> on module-load we got "unknown chip XID 641" for both.
> 
> the chips themselves are labled as:
> 
> RTL 8125B
>   JCS07H2
>      GK08
> 
> maybe it's only an additional line in mac_info to support these chips,
> but no one here is experienced enough to decide/try this.
> 
> 
> it would be nice, if someone here with more experience can say something
> about or perhaps add support for that chip.
> 
> thanks.
> 
> regards
> 
> sh-ks
> 
Kernel 5.9 comes with support for RTL8125B.
There's a number of related discussions in the Odroid forums, see e.g. here:
https://forum.odroid.com/viewtopic.php?f=168&p=303453
