Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC673C3E1A
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhGKQyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:54:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44350 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhGKQyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 12:54:20 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by linux.microsoft.com (Postfix) with ESMTPSA id 61E7B20B6AEE
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:51:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 61E7B20B6AEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1626022293;
        bh=smqbJZ6Vpb0Nza7eQP2c2Wdxhl1UmhxZDTRrXz/n440=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cVi2duzxVHJrViTXxnIUW865SMr/QWWcWXj6O2ZZofxHjKotqopM2aft1Gk5U+Hot
         cricMRdFL48rmNpF1/4dy5x/wknHXAngCYqEdQeQOLyv0o+bdsqVpyPWeZiDmpPRYH
         HBpEWcyODQXdI5+jurISTFNP6r0p4fL+HpNX3aII=
Received: by mail-pg1-f178.google.com with SMTP id y4so13094872pgl.10
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:51:32 -0700 (PDT)
X-Gm-Message-State: AOAM531p4SXtGn6q4v/y3Ivimgg4rE8OiLK8s+DYvv4cF1dibXyhyYxP
        rvBVY50Eq20Ud9N8VN77yHBHv/6091j81wpkpts=
X-Google-Smtp-Source: ABdhPJxnizinwKdcQa4Iabxq9lbKx5Uw1wlBpQDVihqQcXAl2wjUGvkZ2lSK36r8FSMGTHNDV22yaItRdsc6gtjpQYg=
X-Received: by 2002:a62:5b81:0:b029:32a:dfe:9bb0 with SMTP id
 p123-20020a625b810000b029032a0dfe9bb0mr8354350pfb.0.1626022292534; Sun, 11
 Jul 2021 09:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210711163815.19844-1-kabel@kernel.org>
In-Reply-To: <20210711163815.19844-1-kabel@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sun, 11 Jul 2021 18:50:56 +0200
X-Gmail-Original-Message-ID: <CAFnufp2CGJ2-NO2j+UJaKX_QDsdgR_qw6tOueYFsgwXycwfomg@mail.gmail.com>
Message-ID: <CAFnufp2CGJ2-NO2j+UJaKX_QDsdgR_qw6tOueYFsgwXycwfomg@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: fix differentiation of 88X3310
 from 88X3340
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 6:38 PM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
> It seems that we cannot differentiate 88X3310 from 88X3340 by simply
> looking at bit 3 of revision ID. This only works on revisions A0 and A1.
> On revision B0, this bit is always 1.
>
> Instead use the 3.d00d register for differentiation, since this register
> contains information about number of ports on the device.
>
> Fixes: 9885d016ffa9 ("net: phy: marvell10g: add separate structure for 88=
X3340")
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Reported-by: Matteo Croce <mcroce@linux.microsoft.com>
> ---

This one fixes, thanks!

Tested-by: Matteo Croce <mcroce@microsoft.com>

--=20
per aspera ad upstream
