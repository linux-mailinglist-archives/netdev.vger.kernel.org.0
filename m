Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24644B88B5
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 02:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392910AbfITAuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 20:50:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35348 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392089AbfITAuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 20:50:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id m15so6720004qtq.2
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 17:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KOSGmeoLj3q8/j6tyeUH96JokcyOBe1qfsscZAUtn3g=;
        b=MC7amPEI9tA5+99C7eMm5Y6jNy6j++yXqKtbSyAI2ruXSL+bYLazR/Mj9vVAD12MXo
         cs93YD03ooPeYDs64TE/OYb+oXeEapeH8p0RZlmyiEZaRQFrB3ZeBR9SGu0GHQfG4hLO
         GCbuC8To/oQR8Neop6fFHUCJMDOFRadtPdpywteS+5j+pXJd/5PMm+L+Ppl4AXlRn9pu
         XoznYy+7LwvpHkWGKXYJpRO04OI+tKXfZt9lVj8cGLuclwktC0gMGULtrXiGYEhsgivQ
         SlexF71DryDjotCOxmMPB7l4xwL7CNB2t0Ya6dfD7mQzIXcSMEsmiFHyC7WqPp6B8vut
         AYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KOSGmeoLj3q8/j6tyeUH96JokcyOBe1qfsscZAUtn3g=;
        b=hQcug713+NGT0hqZ/bNS3OUzt8tlK7jrGSc3+OoP6la+jjTLlKt6aY5pIOxOpbmaaU
         2opK2K88u7hQ+Fc2zw3OzrDToNBq+yY/Z3YXu25KN3BW6hlP1KjsOBSCFZOk0piTek89
         LM3zV0XSA722ZSBKCOeqe7R31t87KXNjmVRb6IQAYKikd/zIZ7Mo0/4FmEb36Snc1oJ7
         36C+XrisxzyiMvYp7wKBlgGfDn/5SVaT72yImsbRwP7e0FWprDqafXXEAoxldB86tLgk
         1pIGHgOkAbuBI2uYlajq2aOt6HA0Tpx+z8T9sOA37TDKNljtgAB1YDq+YYLpGhPZ0wSf
         UPjQ==
X-Gm-Message-State: APjAAAWXHInEZ+F+fb027Tl9hRO28mikOORomy8n640eSLFe0Pdd6ykk
        sF07gqWtn0AgriOszRE4nsZdAA==
X-Google-Smtp-Source: APXvYqwRoegglyZXiObL4uwtWfHMy9JzGf6EXc4vv4RDVKXcndXJNEVnwWpJkq9nzfoEx5bbwBGWKg==
X-Received: by 2002:a0c:9638:: with SMTP id 53mr10737129qvx.13.1568940615674;
        Thu, 19 Sep 2019 17:50:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y58sm158070qta.1.2019.09.19.17.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 17:50:15 -0700 (PDT)
Date:   Thu, 19 Sep 2019 17:50:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Subject: Re: ionic build issues?
Message-ID: <20190919175011.24fbf68d@cakuba.netronome.com>
In-Reply-To: <a99cf2d8-2479-2003-ac0b-10d44363c872@infradead.org>
References: <20190919172739.0c6b4bc4@cakuba.netronome.com>
        <a99cf2d8-2479-2003-ac0b-10d44363c872@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 17:29:28 -0700, Randy Dunlap wrote:
> On 9/19/19 5:27 PM, Jakub Kicinski wrote:
> > Hi Shannon!
> >=20
> > I've enabled ionic to do some build testing before pushing patches
> > today, and with my tree which I build with W=3D1 C=3D1 I run into this:
> >=20
> > ../drivers/net/ethernet/pensando/ionic/ionic_main.c: In function =E2=80=
=98ionic_adminq_cb=E2=80=99:
> > ../drivers/net/ethernet/pensando/ionic/ionic_main.c:229:2: error: impli=
cit declaration of function =E2=80=98dynamic_hex_dump=E2=80=99 [-Werror=3Di=
mplicit-function-declaration]
> >   229 |  dynamic_hex_dump("comp ", DUMP_PREFIX_OFFSET, 16, 1,
> >       |  ^~~~~~~~~~~~~~~~
> > ../drivers/net/ethernet/pensando/ionic/ionic_lif.c: In function =E2=80=
=98ionic_notifyq_service=E2=80=99:
> > ../drivers/net/ethernet/pensando/ionic/ionic_lif.c:673:2: error: implic=
it declaration of function =E2=80=98dynamic_hex_dump=E2=80=99 [-Werror=3Dim=
plicit-function-declaration]
> >   673 |  dynamic_hex_dump("event ", DUMP_PREFIX_OFFSET, 16, 1,
> >       |  ^~~~~~~~~~~~~~~~
> > cc1: some warnings being treated as errors
> >=20
> > Config attached, could you please take a look?
> >  =20
>=20
> Patch is already posted.
> See https://lore.kernel.org/netdev/20190918195607.2080036-1-arnd@arndb.de/

Ah, thanks for pointing that out.
