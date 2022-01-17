Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DDB4900CC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiAQE0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiAQE0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:26:48 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1FAC061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:26:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so20990851pjp.0
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7KP4k1s5Zy9Ba6Y0fKh2oRYgVYdUnOnLO1bt9LBt2Xk=;
        b=mtLS5VscMfF6bkUhlOT/ZTiQa/94m1x6Sx++hU4SdbcmkKGzdYMAgbsbV1zVu/QG6y
         2WSWLPPlQPoHQw06hs9is4EM3ZHKsXYaMtqRrxscE5a4O9SO7o/puR73TR0KuzuW14pT
         pUi1ALK/tc/hoq1YOOVwrtKCD2VdXXGqDZ3vfwNIC8BHBj8gerOuiaSifvKytiL5q/K8
         apGzsae1CUlYBnv3946fZ5bl5sBu4BLvzQjjmWWDn00SbNFF1DuAP4v5BCkiQ527vGJb
         xWWV7T6Ainu5Hf1NUESRKSDEGyTL+uaWxQ47WNOOVSV75nBv2cMB9cBDJa3pyAxUYhOt
         sCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7KP4k1s5Zy9Ba6Y0fKh2oRYgVYdUnOnLO1bt9LBt2Xk=;
        b=L0DgdsGLo72jZMNr7cRJucTPSfsaZIB4AAoWNmo7lQhbuQS5hz+mKQpd5qXXp947lU
         ewdezujpGFLe2+E0t57m1zaxpyIAOE4PorvDggpPtMVxgTpJ/Qug363s9wz/PjjWZwL7
         qmJ4/XkpkWm00CcKmvlxwz9wLdiVraVfxxWXYbenHHBII75UGya+m8CeaN6tx3G7jq2k
         4XANabEba/caCdAWu1scIRIkfwm1GfmMZtbBm5wOt7BgxvzJGpHuruIAgXOKAU2pDfQa
         +luUEpU3z2mgta1G9840un5qsr7q3gsxbXX777Ns33RJAXEhIhZXWM3P8VBQaVJ/ltqw
         9Pig==
X-Gm-Message-State: AOAM532A8ozcQjMaJwwGpCoNfEUPoX2nOkEmhE7kS/IEKH0Xj+LJbdAd
        S3t7aNWCVaZD2ifQUG+tjso=
X-Google-Smtp-Source: ABdhPJxDheTKbUlbRqXSAL+/07lVjdjkQQAxg1C3VNhn3YdB9WhzpTNkc/IQb/OF7ISdCaoBvw2Hug==
X-Received: by 2002:a17:90b:384d:: with SMTP id nl13mr23140477pjb.46.1642393608309;
        Sun, 16 Jan 2022 20:26:48 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id t199sm10266420pgb.64.2022.01.16.20.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:26:47 -0800 (PST)
Message-ID: <13599dcb-5561-bd76-c35a-01279ecdc207@gmail.com>
Date:   Sun, 16 Jan 2022 20:26:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 10/11] net: dsa: realtek: rtl8365mb: add
 RTL8367S support
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-11-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-11-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> Realtek's RTL8367S, a 5+2 port 10/100/1000M Ethernet switch.
> It shares the same driver family (RTL8367C) with other models
> as the RTL8365MB-VC. Its compatible string is "realtek,rtl8367s".
> 
> It was tested only with MDIO interface (realtek-mdio), although it might
> work out-of-the-box with SMI interface (using realtek-smi).
> 
> This patch was based on an unpublished patch from Alvin Šipraga
> <alsi@bang-olufsen.dk>.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
