Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A191E93BD
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgE3UzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3UzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:55:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8402C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:55:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c71so7070343wmd.5
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LbXyB+nQYNS3l5+k1Mh4LDbh1iRFFC2tAMGX4gZ9rOw=;
        b=J8ehXN6VtLVXhXRwU0DdgJc0/Tr1GVH3Lx8ToiTLYWjjNWmqYgdrcJZPP8OA0HxDD7
         HHXfnnStPuO2AlZ05QM8XrXTPMoX33cH/khAceEGIGqQi50BIZ7hUx5TTymZEP+dcRqK
         JfVoqb6MnCabgQPjyoJ4zU+qdWpVnZ4SZGlmG8bFvRSxLv3Yi6rLJydz8XH6i4xgq0sM
         qNuRf87Wu29SRrkqM6jBoVxCjkFy3u4Bkm4vHrbqipo4VA2rwGAkONypC5aNzBnxlRIp
         foO2Zwqh1zc+42QXGiMN0niEgB63eB/1yG6qBjk1ePOU/7J5iPuStWfCo+DJgvXMkXE9
         t+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LbXyB+nQYNS3l5+k1Mh4LDbh1iRFFC2tAMGX4gZ9rOw=;
        b=Hif+TQQhnWU/QDlihMb0DDjKNaEznjOCOPl/dSbRnuaDHVtNpLnNh+KSgoqhtNXGQT
         Y51fDyBVNs1JYSn9WIcRNjHqZR6+n1m2p1CwE3soxz7+RJvqeJN1EXQVHtW9yb0aNEDe
         0ISxZ8/SkWpKkTM7oz2lyR8eknxQDnJgeTRteW5w/55d63cNToANADKmS3P2yxy23eCF
         vosOBr6LTlLvHNl2oCSh/lrhv2qqgcrdJiNtW/F5m56gE1zcmwlBVESn+w/T5w+q/KGC
         e20DMPGGt0GauhoOACjGoG2UmkACfqTg4b9kc8W31oB/Qm4Vk/zC5gDwyKogGF6Xw9JO
         hFgQ==
X-Gm-Message-State: AOAM530IN4c5egs9H2KaBRPOitOiWEZHRI3h0R4orqzTmdWsKVQAca6O
        x3Iyr/AbLu2J3PLdoy9uq+g=
X-Google-Smtp-Source: ABdhPJyb6DyC9vuGE/1pcov4O980R1Lp3a1lJMy/H4LOqhWKvPCy7L3zYsjFMU8oTMAC8qUJoApbHw==
X-Received: by 2002:a1c:4487:: with SMTP id r129mr14075457wma.14.1590872121394;
        Sat, 30 May 2020 13:55:21 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q128sm4718032wma.38.2020.05.30.13.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:55:20 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 13/13] net: dsa: felix: introduce support for
 Seville VSC9953 switch
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-14-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fd0249c2-3f04-40d9-b38f-199102f757d9@gmail.com>
Date:   Sat, 30 May 2020 13:55:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-14-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Maxim Kochetkov <fido_max@inbox.ru>
> 
> This is another switch from Vitesse / Microsemi / Microchip, that has
> 10 port (8 external, 2 internal) and is integrated into the Freescale /
> NXP T1040 PowerPC SoC. It is very similar to Felix from NXP LS1028A,
> except that this is a platform device and Felix is a PCI device, and it
> doesn't support IEEE 1588 and TSN.
> 
> Like Felix, this driver configures its own PCS on the internal MDIO bus
> using a phy_device abstraction for it (yes, it will be refactored to use
> a raw mdio_device, like other phylink drivers do, but let's keep it like
> that for now). But unlike Felix, the MDIO bus and the PCS are not from
> the same vendor. The PCS is the same QorIQ/Layerscape PCS as found in
> Felix/ENETC/DPAA*, but the internal MDIO bus that is used to access it
> is actually an instantiation of drivers/net/phy/mdio-mscc-miim.c. But it
> would be difficult to reuse that driver (it doesn't even use regmap, and
> it's less than 200 lines of code), so we hand-roll here some internal
> MDIO bus accessors within seville_vsc9953.c, which serves the purpose of
> driving the PCS absolutely fine.
> 
> Also, same as Felix, the PCS doesn't support dynamic reconfiguration of
> SerDes protocol, so we need to do pre-validation of PHY mode from device
> tree and not let phylink change it.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
