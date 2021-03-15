Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7480B33B553
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhCONyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbhCONxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:53:45 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD413C06174A;
        Mon, 15 Mar 2021 06:53:44 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o14so4935993wrm.11;
        Mon, 15 Mar 2021 06:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KemkAeTk9mClNID9MgBdrRYEwF+T4PnONTX4FkH/70I=;
        b=qoSAOlqrAj9XEHIc0K6JNP3xbYE+MHYuUt/DZXU8OfxLiDXi+ykQxo0iRFSVKvV7V2
         2xM7uUGt6JsJA/t6BYmP9hnOg0C/subYpR+QcY/K+vMO2DnHDY3Mw/OlzTC9Rva4x6VK
         goQEaRIzKODbaKZ4T+up/rIygksvJeH9n2lxj4eIaKp0WZIlgBvcO8X8ugZjudipa6Bp
         nNzkUGRKGVrbEGiefC/Ld3Te1bqiaV93DucVq7LWTgKOEIDhvdwfCe8w8Fb6pTxunmfi
         rwLCo/9ecPsL01/jA69kcfQZJ5oZ+rM3/qCWomZbkDEUL024bLGP2iarnfmxP14o9ADQ
         3hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KemkAeTk9mClNID9MgBdrRYEwF+T4PnONTX4FkH/70I=;
        b=VacmUFMoLlQqzO5x4+aFtXoErBkmiCa/+4S198aQJJ5BLKtLy2Xehs1wRZU39cLQ7Y
         pfUAtmkgU/n8RcEFvdG888gtmeaTMGTpkOzuHDh42dLL9+CA3ERd0Jz93zSVzA7Zriwk
         EKNn6vJDnPuZHonplYzlcs6ZtEFEP1WEx4FVqEiJkJgfoe7Xp1RAz6TlHe0PL/+rkajH
         XWvE1rG/GYPHdHsr3bJqj2eikMuJ6ulRbb4+nT6vcutTudMVDFzGZ6bluVcplMvR+2UE
         yS0a6QZ1osShAU6LLVl1Fs1RRLFU9s6SaZTSl6RoD7YhetAIXE5EnCatMqB4nz1IfgyD
         p05g==
X-Gm-Message-State: AOAM532nyh49IWchwV7dGKUmqNUavNIJY1FC1SK+HVn7pj0KzPw73hnP
        kQLiq3img8puyMCTyD+r3A0izUuHxFDHLRdt
X-Google-Smtp-Source: ABdhPJz+W7YQKBZ8lm0cd1BD2niB34IG9sKd5goLv4Z0PkSKSHfnhmmggy9l4gPrPgDNdY3qLRHriA==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18mr27363586wru.366.1615816423518;
        Mon, 15 Mar 2021 06:53:43 -0700 (PDT)
Received: from macbook-pro-alvaro.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id p27sm13091334wmi.12.2021.03.15.06.53.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Mar 2021 06:53:43 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <20210308115705.18c0acd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 15 Mar 2021 14:53:39 +0100
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA6D1162-FB0E-4899-8172-DB49CC522EB9@gmail.com>
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-3-noltari@gmail.com>
 <20210308115705.18c0acd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> El 8 mar 2021, a las 20:57, Jakub Kicinski <kuba@kernel.org> =
escribi=C3=B3:
>=20
> On Mon,  8 Mar 2021 19:41:02 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
>> This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and =
BCM63268
>> SoCs.
>>=20
>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>=20
> make[2]: *** Deleting file 'Module.symvers'
> ERROR: modpost: missing MODULE_LICENSE() in =
drivers/net/mdio/mdio-mux-bcm6368.o
> make[2]: *** [Module.symvers] Error 1
> make[1]: *** [modules] Error 2
> make: *** [__sub-make] Error 2
> make[2]: *** Deleting file 'Module.symvers=E2=80=99

Ok, I=E2=80=99ll add the following in v2:
MODULE_AUTHOR("=C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>");
MODULE_DESCRIPTION("BCM6368 mdiomux bus controller driver");
MODULE_LICENSE("GPL v2");

