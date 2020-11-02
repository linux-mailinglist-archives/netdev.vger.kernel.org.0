Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7D2A2BAF
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgKBNkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgKBNkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:40:04 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984EEC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 05:40:04 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id s25so5016032ejy.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=52slsd2JH18UWBYhietokZk5p0NXNbdSL2AEFiDrDoQ=;
        b=eZssPq10uWf7xOBFDQjuFzsaDMgKbkeTvoIPLShpBz4ab5GQ4HLP0mykAVgh1F2cay
         nROAslPpuMwK5VMb9pkgC2LZru7hSY+GWUT0Icsq5oiBzALxkbz6RnfUGXhcaDXiz86G
         /jMGXyKVvMjoMHOKTK43MxaKhfCwq4X4ntiDexsB1olraXqsdRLqrCx/dGB8eDCwNqsc
         nDbCKC4NB/zAHT+BdMSpM40AXH+ZAPYF//mU47XE0hRuTjrCxCIMEWSOo2wRAGjo9Tbh
         L2qUutqxOnTQnO9p3ZDehV8nVvmcZ5ACMAcAnlY1Ul1mMqSmqiy7+CwXWeuAuplojP0+
         +aJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=52slsd2JH18UWBYhietokZk5p0NXNbdSL2AEFiDrDoQ=;
        b=ku4uCsjoC8RL5YY/UHHM4qNmr2458YOoJ3c0xc02AouwR5aVAks5q6HygChlCZRaod
         plPA3Q70sd0cu3a2U4GnkzGcmMUgJ/YVjEuzKHFhU4OZ7cIKx/4oW3lb3WRG+G0mecI8
         aDsPuYSxJ+LsGaCGvb0IKBhJFkcAtpqr19UFEoWtohZRq1Tb9PFkFYunzhgpdBH3zT/a
         reslagP6+2EEL7cgtEltMndE7hNC4cltzp6oAQiOOq9qIHGS2CzF5aLfR3EXOUIG2FoF
         tSKSSjtN5ocoD0YPCWHqZhl5n9S8WdbWnWjuM8vSH5h82r8qSTnmLxf994VIoxMIEjDR
         4jkw==
X-Gm-Message-State: AOAM5307j1G9KW8tyeNaJEvs6wkd9t+j1ZK+fBP5fGH/X60TgQEkePQ4
        hwmlOSZR3kiYgcmI7BsvpSd41E1rCmo=
X-Google-Smtp-Source: ABdhPJy9okjEWEhQi3sGPkUEwvICB0g45v5KjeFiQ38hONc3lTCzOmNjI/JN8z95Vzqihu4/ECGw3g==
X-Received: by 2002:a17:906:838f:: with SMTP id p15mr15406375ejx.522.1604324403056;
        Mon, 02 Nov 2020 05:40:03 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7ce1:60e1:9597:1002? (p200300ea8f2328007ce160e195971002.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7ce1:60e1:9597:1002])
        by smtp.googlemail.com with ESMTPSA id r21sm7469435edp.92.2020.11.02.05.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 05:40:02 -0800 (PST)
Subject: Re: Fwd: Problem with r8169 module
To:     Gilberto Nunes <gilberto.nunes32@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
 <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com>
 <c743770c-93a4-ad72-c883-faa0df4fa372@gmail.com>
 <CAOKSTBuP0+jjmSYNwi3RB=VYROVY08+DOqnu8=YL5zTgy-RnDw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fb81f07e-911a-729e-337d-e1cfe38b80ff@gmail.com>
Date:   Mon, 2 Nov 2020 14:39:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOKSTBuP0+jjmSYNwi3RB=VYROVY08+DOqnu8=YL5zTgy-RnDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2020 14:20, Gilberto Nunes wrote:
> Hi
> 
> ethtool using 5.4
> 
ethtool doesn't know about the actual speed, because the downshift
occurs PHY-internally. Please test actual the speed.
Alternatively provide the output of ethtool -d <if>, the RTL8169
chip family has an internal register refkecting the actual link speed.
