Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9A4900CB
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiAQE0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiAQE0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:26:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F94C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:26:12 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e19so20010104plc.10
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kc/jFGK4PR439/0FoFCn7cHe7ZjaRVoFWqFe2wIzwyw=;
        b=G4h98RAU0CbxeiAuQl+rmuEuPPZOWGMgaCzVKNh3AxZ8krkq3K/tW1HQMIHBBi/Iz0
         DlAneK7sPpAvsWoUeU2crVdAeBCUq9AxtRk49g+l3q2GPFltoxi+TiZsRhfsnMX/BIjw
         swlqvBD9WiF/YpCe45lmv2UVpMhcaOdnRoYE8nwseJ+GGdT/8YsQurKnheaZhFby+iU7
         SUSPQdmytGFBlAQnQNQme8lT8daBMrQOUxqIzcV/nAXzwR4M1xVf3KEkq2la9SaZiuRT
         qXpDjHZWjCav2kSftxzYkJYsmAb0NDwmJ7deEqgdMMP8KCirU9Xe5vbzXQnPmDPdHe5w
         7QXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kc/jFGK4PR439/0FoFCn7cHe7ZjaRVoFWqFe2wIzwyw=;
        b=2bvi8aBhiBDtByC1lz5bXGS4L2JIHRKVHyiZAJOBe4rDB1l5bGb4YnENyj67Hb8EHD
         LI/VKVmUpjRsRPxWYVrqN4uFLJPeHoKsmmNjPpCP++VGGVsUYoKOiVsFDGXUM4bk9i81
         cdi3D5vyZCXC3TyT14gKG7V8MbW6RGP9U669uNxFTu8WrBAAMO2ADzeefu9+Ht2VY07u
         HEFHVknn91WuUBIYE+2cl722awbMsMwrwFrRiEHUcc/HsvlQ6hIbwR2RGZ2OkavuLu6/
         4ykdUC0nwKG9B6805wpj0MPihii7J8z66z2mH+AyO1XdAVbWqrySToWXCUdFNMT5toab
         t0AA==
X-Gm-Message-State: AOAM533YI3t1jwv0vahBPKC9u494Jd/tGF1we0C/0/9+A5eF6L03apx/
        6Ygrrcd1YIWwVLBFeKcfHRE=
X-Google-Smtp-Source: ABdhPJyjv7YSzj8q4JzajXeR6X1aVOyKkt6iNA6w7WN5qW3PuS/8yKN1E4WuyboIu4AEpxDFBcKTHw==
X-Received: by 2002:a17:90a:ab02:: with SMTP id m2mr20392359pjq.4.1642393572156;
        Sun, 16 Jan 2022 20:26:12 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id c20sm10205536pgk.75.2022.01.16.20.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:26:11 -0800 (PST)
Message-ID: <f26fba2f-5cca-5664-f195-7b06b4c00338@gmail.com>
Date:   Sun, 16 Jan 2022 20:26:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 09/11] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-10-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-10-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> Instead of a fixed CPU port, assume that DSA is correct.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
