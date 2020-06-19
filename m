Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68985201A04
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394699AbgFSSJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394603AbgFSSJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:09:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19A1C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:09:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id g18so1495852wrm.2
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CM2tIVPC0fBwFaKseXQd9HgBiDaWlbPW6hwGgoaNAr4=;
        b=H4NnFfa9qcjhMxwsWvyRj6nGEkoAgui0je7OV6J3eekD2Bn/xesvGd627yubJRUOJz
         fp/4p2bWYx63Nhc0pMIsVf9mwqQ7tN1tt6T8isfACvypzEDajz9CqsZwUXD/2c1h5C9p
         dmgzUY6AaIWJyt9YKzH5kD3USQkc5Btay3ZXJD8HTlVGJZ3tUbODgDWamBqI29p5U2vO
         SdAZrFqsAxIHd88tJmh9MkzIP1XghKcb5QtaSwCWSgV/gm+Oo4y9JoigoqNPqb7ZiqyO
         duZSlU98NggmAxx+WioxQppadXuOV8yZNsA6MG1T/HpTpRbuA052/JTBU2IiSsLmz1i6
         0aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CM2tIVPC0fBwFaKseXQd9HgBiDaWlbPW6hwGgoaNAr4=;
        b=I4zXApV2c68nJDy9lT32MCSHwPlEexvSyWuIUTHdlS65658YafLjYMvkOvcD0jnYZU
         dcMNm3ZJRHBSqsbz51jMztsnfx3nt0+BkB73x8QqAFilxsw7CYwgS44u24/9g7s9Dp4K
         gaWogP8146Kz0sGJYlG6hPsiI20tJrii+Od5My+f0tdDirGGAmbILinKVi1oKzUnZe9a
         Ozyzbp30Qdxsw3EjfvoGT6yWF8aG3UNVVKP2xEbRavcdMW09X2XjxFr70nYsmBqrJCxf
         1J5taZvQO6UumB3z7mMaggTmPobwSQR7A+2kURVIJT+xKkBlRrXzJkgOBBGX7M9psJTM
         y8Ow==
X-Gm-Message-State: AOAM533UUXHWUnmjQGu+EauRF3GfPvkrM1C2vJkAvbz0LMByxbps/Nyd
        MkmbLEuLG+jLw0R2ajVs1n0=
X-Google-Smtp-Source: ABdhPJxL5IxbU79buJcnxRleNhRUwdRWGQVyuuwwkmoFsH53149/Pc4/3CWp4gqVGXie08C0+fRbzg==
X-Received: by 2002:a5d:46c5:: with SMTP id g5mr5288406wrs.15.1592590191939;
        Fri, 19 Jun 2020 11:09:51 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 104sm7996561wrl.25.2020.06.19.11.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:09:51 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: phy: marvell: Add Marvell 88E1548P support
To:     Maxim Kochetkov <fido_max@inbox.ru>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200619084904.95432-1-fido_max@inbox.ru>
 <20200619084904.95432-4-fido_max@inbox.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0a2b1bff-6e4b-93cd-4778-dcae2430aed6@gmail.com>
Date:   Fri, 19 Jun 2020 11:09:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619084904.95432-4-fido_max@inbox.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/2020 1:49 AM, Maxim Kochetkov wrote:
> Add support for this new phy ID.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
