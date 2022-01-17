Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825AC4900C9
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiAQEZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiAQEZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:25:18 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52558C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:25:18 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o3so19530690pjs.1
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ziO/BnTu1gFo7lPY667qA61X7gEl0RV4RK+PxN5uuxw=;
        b=fwCG/C6lIRQeboewigrZ9Jo0RCV5mKbvTZAOnXptgzlAac5OiedO6SO9hMzQjAw+Iv
         2VkIbWfX9JcdqCSG4Xf0iQcO0Bf3bGkLAmzIIC7U07eVzFvILN0O0kCwTCeMd1BEmfvi
         ZjaUucEcPhijOBHpPcxyfsig3U/MSAt9zwR8Jzjw9FXtiEwMruVIB/kZqARQANvKWv3f
         yd29icUKSDOnID81LOZBE8rGc4Mzo77VTE/W3qA1eiiKvredpysD2f8b5WkZhEgnWdei
         vHKaRn1gq9POdWLJn+ucDb/RT+DQraCwZM0isBQ182rOvDjnrKodwOr0WXRqTkoFzcU8
         0sYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ziO/BnTu1gFo7lPY667qA61X7gEl0RV4RK+PxN5uuxw=;
        b=vX2JYZHTaoGnyMTHxBb83pSJpVs5V1TeNl3vGMPk1YUbNsGOa4PBWkbKKpsWNYxlfE
         a0a5ZdozyOA5OYGNsqg1Rx0s1NtuSyBrLF/WMS81RZWk4dNoeMKT1npTWMijTK/mMpVb
         a8DDijkrzm9iYWqCbdy8TvInBWZiu91N/4uoPjvzb7sd4swb4bFWprN9llDVQTq/J1Ye
         xiwPocOBE3HoeRE7nViCN1RTduBilV7lYBKkWEqHXCX7XdBi90QvqD9NfY16a166qc0b
         bCECd1kdaY2sJSFAyh2XEnKYw0/ecaYscrAf7jE/vEkvjShgfrkVd1OQmBhlkWBoG99N
         qEiw==
X-Gm-Message-State: AOAM531ZB1BRlyFjuRo/LNiOGkAgtHKnqghH3Xp7l9xAQAV6gXY472eH
        luiL29eyit4ic/rqqE20/iI=
X-Google-Smtp-Source: ABdhPJyMXRrLknsXj1liR1dhM6HqwYmoGt9DQhgMkE8PWTc7JVQZpXzeImCATo9BxeLBTpMoI8AhKw==
X-Received: by 2002:a17:902:f54b:b0:14a:88f2:f55c with SMTP id h11-20020a170902f54b00b0014a88f2f55cmr16754506plf.158.1642393517663;
        Sun, 16 Jan 2022 20:25:17 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id d8sm10083616pgf.48.2022.01.16.20.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:25:17 -0800 (PST)
Message-ID: <e8d811ce-9b39-6a1d-8db1-6aa73f7daa3d@gmail.com>
Date:   Sun, 16 Jan 2022 20:25:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 07/11] net: dsa: realtek: rtl8365mb: rename
 extport to extint, add "realtek,ext-int"
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-8-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-8-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> "extport" 0, 1, 2 was used to reference external ports (ext0,
> ext1, ext2). Meanwhile, port 0..9 is used as switch ports,
> including external ports. "extport" was renamed to extint to
> make it clear it does not mean the port number but the external
> interface number.
> 
> The macros that map extint numbers to registers addresses now
> use inline ifs instead of binary arithmetic.
> 
> "extint" was hardcoded to 1. However, some chips have multiple
> external interfaces. It's not right to assume the CPU port uses
> extint 1 nor that all extint are CPU ports. Now the association
> between the port and the external interface can be defined with
> a device-tree port property "realtek,ext-int".
> 
> This patch still does not allow multiple CPU ports nor extint
> as a non CPU port.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
