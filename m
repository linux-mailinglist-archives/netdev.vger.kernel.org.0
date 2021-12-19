Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C215847A2AA
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbhLSWaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbhLSWaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:30:11 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7E9C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:30:11 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id r26so13107458oiw.5
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GZAd3e/lx8o4Scm4qw3TkDafWHfG85tyFBwSIf8eM2I=;
        b=OHpek98pXy6LhkbNNAVAk2hPWpeNrvtybuym5KTWrFnc1J36w/KbnWBU8l5J3HfE22
         BPAhOzDut0KO+Bx1BR5jZik7gyNNoZ73xTE001rWC/7idSZFrUqwtaXT4//6vjwNFIpN
         4MvDdEV0JTOdwDpWQTqtcYmQhsysC2WLWGO/nk6grPEaa41o2j5OQgxSZ4isKwdpvFkE
         +iOkA//LchHHKskQoGjqnzvh050661GhTQhgDX2uoOPdQE8qv2qFkLsBrtmBasZpukaW
         p90oqjRbzbeWWywk9hB1DTJjGltsR339ZMBw1jG79tkf7Ax3ruEN2z88rukI5c4zSd28
         onSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GZAd3e/lx8o4Scm4qw3TkDafWHfG85tyFBwSIf8eM2I=;
        b=TcNqP+vyf4oUHZ1AOLqUrrecbt88gaMGIoM11bM9rEijoMPspl2SRvUnadLe9zRAdK
         7bZZVeHehddhDbvqIZ13i7s5rsSZZS5ZB7x/SN155D+VaaqBdQBFLXQoJZYeubQSDGNe
         CZi50jYMMyrtNTT0ik//pUO1cqbVSMkPUfwzXfpdLEifLWKeXqPVPR8mIbkUfyRCwxha
         4XGtQGrxd55ml59KXP64YvDNxAuWeRxBXHb4NIxLEW8vSq5PLJ3RGPVBdZ1F5shcY6OJ
         xBZszlul9SUc54O3jbRBR7swlWo67EcwOf74ziNn3giTsC6yYhw5YYMAyGWxd/EToOH8
         y8vw==
X-Gm-Message-State: AOAM531P1HQBPcIuOid1YSHw+lHIpwf4oKLkv/sApswWQHScrYM8dnHj
        0vPg2Od40tWL1bn1wAcoM3EPStcKFSmsHN6lqDJX0Q==
X-Google-Smtp-Source: ABdhPJxl7eTlHWFAIyurKQiPjLt6Q+flW0gogcYerByNiUiyX0qURlKE7hiFJEOlbMwIRErIjGT/Re0OmmgWAKc/Frw=
X-Received: by 2002:aca:120f:: with SMTP id 15mr9858022ois.132.1639953011001;
 Sun, 19 Dec 2021 14:30:11 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-7-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-7-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Dec 2021 23:29:59 +0100
Message-ID: <CACRpkdZxc+97aqpuE+4JK4_Pf+gv4zRd7U2QvJAb5mur-VucKQ@mail.gmail.com>
Subject: Re: [PATCH net-next 06/13] net: dsa: rtl8365mb: move rtl8365mb.c to rtl8367c.c
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:

> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
