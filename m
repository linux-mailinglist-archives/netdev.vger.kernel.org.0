Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F4EEDF9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfD3Ak2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:40:28 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43299 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfD3Ak2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:40:28 -0400
Received: by mail-yw1-f66.google.com with SMTP id w196so4666097ywd.10
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 17:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LgDHqiBMkIEP2Gjv1b/BPNB6tTx6cNIX8WGn2OufiRQ=;
        b=F2K/xby4cmu6d2bZoZHJLR5Z4UZj5CGWYwSUm3LxusNt5Jmmm9YeWtE5K9sqrAdZuk
         gwz6epfbgd98xGZRRXx2zBxmy2oDyAdASJQHHpO8rY3PjpCAFbhU+2RcJuuqUE4ZqfaW
         /leG3SS/9/y27TwwrXCfbtJGcjzg3UZBYRPMitXPLwSbOuAM8QaXoh6yQaQfT/IcPXeW
         vuVLqIIdHj1Ou0IAaxfLoslywy/E4eDi9gpDAv1OG1wWf0w2PeT6Qri71vyTbJcrqbUX
         KEuZ4nD3RjUSl0spMlo3D/3HRKtuTLpV0xrX3NhRVCe+vuVhpPIJcyxcKf7zQhI8Kwau
         YXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LgDHqiBMkIEP2Gjv1b/BPNB6tTx6cNIX8WGn2OufiRQ=;
        b=a/rYj37KhpmmBY2614sODbxUiCvom9NYz6JhwdrudcdQ8lM7mysh8X3iHNacU+UjxM
         N7LnvsslsJDIJtdoskvAyi1tY8FmzVZnCfW7ikPkey7psA4fXWaOlLEz+m5t6SIvG5Zz
         haENTyxcDReiGiweEYwfo1WF3BeUpH4751wJdHTBnYTWO8Q1kADGgNZ1wXEqUE/7+5ro
         2fbqFVfnzV32xfREvXNIgyJ7MR2jUCrA3okCJxX+p9LaFxFa7JjTh3Cc1oZvziSFSMfv
         qjVEtLWUxi1JqMsCPEbGbwUlN0P3KUzNW3IRNhnE/BANiKHhNCvV0mrVd3d+/ao81Pkw
         /njA==
X-Gm-Message-State: APjAAAVc+XJiV4FJk+krP3rldKiWdU4BfMxyJL3IWUTC0XDTMzpQaybz
        Qo1qTui/jWQ2Bq2/Do1yrjghVA==
X-Google-Smtp-Source: APXvYqwRUNNglVfbfdo5R7L0BKzVxB+n+Hc3Y+ZAEsg00ux13E71kxX4gWJaZPEGNX5YB88pffHYaA==
X-Received: by 2002:a81:3b13:: with SMTP id i19mr18065733ywa.100.1556584827229;
        Mon, 29 Apr 2019 17:40:27 -0700 (PDT)
Received: from cakuba (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id x189sm7834917ywb.41.2019.04.29.17.40.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 17:40:27 -0700 (PDT)
Date:   Mon, 29 Apr 2019 20:40:23 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: fix fall-through annotation
Message-ID: <20190429204023.259fe70a@cakuba>
In-Reply-To: <20190429173807.GA18088@embeddedor>
References: <20190429173807.GA18088@embeddedor>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 12:38:07 -0500, Gustavo A. R. Silva wrote:
> Replace "pass through" with a proper "fall through" annotation
> in order to fix the following warning:
>=20
> drivers/net/netdevsim/bus.c: In function =E2=80=98new_device_store=E2=80=
=99:
> drivers/net/netdevsim/bus.c:170:14: warning: this statement may fall thro=
ugh [-Wimplicit-fallthrough=3D]
>    port_count =3D 1;
>    ~~~~~~~~~~~^~~
> drivers/net/netdevsim/bus.c:172:2: note: here
>   case 2:
>   ^~~~
>=20
> Warning level 3 was used: -Wimplicit-fallthrough=3D3
>=20
> This fix is part of the ongoing efforts to enable
> -Wimplicit-fallthrough
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
