Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E844A3EB9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 09:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344194AbiAaIkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 03:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiAaIkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 03:40:39 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B59C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 00:40:39 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id w21so11382329uan.7
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 00:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=E7DjwvpK8fKU+n0BvI0K3vZtJI6EGSLZ3tJ9NtovK9I=;
        b=X5FHyi87XbmTTaM5j4wdbF7wUUytt34f0joTTZkdt09e8O3s+dyr8Pk6mXJy0PtAFy
         GG6hIZuu/nX6mGce5Q38afnINAKfnrVhTOha3Tq9HAQhrP4sWzhXILmw34yVomalBBjv
         lV4QnBXBhopgJYgLL7uBLSUecbYyAO+5OQ5WOnwN4HA1HyxKQsFEv9wfBa54cdgZa0sO
         Wb44TFQB0Kz68WNSmhs+SApwuYui4lWeGGQaaaUWIb5sTOkA6/cyh4IMuNYEUCk6BH9j
         pxEpMB1U6VBiN1N8WFyCzv0LBTOqXsM9VyVHPIiJ7wpaKfxDwfPVlpxQOv/l7sGdbwdv
         vY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=E7DjwvpK8fKU+n0BvI0K3vZtJI6EGSLZ3tJ9NtovK9I=;
        b=dlztO0Ufxel7d5TiIvzoSAuYJvAH1z5pvbkRJ+BA3nHZmvUnLDZpPsQBdqlZp6NHkP
         DL1d8W6v0g8h9pVKJWrigrJKPai0rb/Bk0RJXoX0HUGwxSw6p9JeAgpVWSHro/oeiTiJ
         C56xswOiIXG7JkMVbOpRHWbQvkxI1XoY/DyLPhTxUjnE3z2x5yGTa0CiXkLQGkt2aAnp
         5Q2qZTyp3jOK6QpQt5TfzVHVHEOigL7Cc//PSCNOwav8FDtcvfc8ZJvXP8SrBYtWouYh
         OkBZ5Ac2P9t0KTMnrGSl0NBbBkySGT1uP/I8ug+BGiCdxdNLE188kwffMDcciLZ1wFQ9
         okBA==
X-Gm-Message-State: AOAM531Q9EZ3AL09meZTwXeWfRehC/9rdKxu8xQ7hrdKndS7wNrtmk6s
        TgkuoYvATTjaZBGmPd6ZZPI9P4xiCrde4OF3pAcpk7PDpwPRmg==
X-Google-Smtp-Source: ABdhPJxCdSlzPHfaHKbKklZbRmVuG/mtAIVHBBtroIQ0euoggAjUpQmMSGG8FiCwogjXThAguFS9+Uioqu0oMJEBlqU=
X-Received: by 2002:ab0:6294:: with SMTP id z20mr7146049uao.11.1643618438861;
 Mon, 31 Jan 2022 00:40:38 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:8fc5:0:b0:282:56bb:311c with HTTP; Mon, 31 Jan 2022
 00:40:38 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   orlando moris <barristermusa32@gmail.com>
Date:   Mon, 31 Jan 2022 08:40:38 +0000
Message-ID: <CA+gLmc8OS0v_MQV=Dvwc2bF8CQ85sQ_EUtBc1dzary4oHM+SQw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sveiki, informuojame, kad =C5=A1is el. lai=C5=A1kas, kuris atkeliavo =C4=AF=
 j=C5=ABs=C5=B3
pa=C5=A1to d=C4=97=C5=BEut=C4=99, n=C4=97ra klaida, bet buvo skirtas konkre=
=C4=8Diai jums, kad
gal=C4=97tum=C4=97te apsvarstyti. Turiu pasi=C5=ABlym=C4=85 (7 500 000,00 U=
SD) mano
velionio kliento in=C5=BEinieriaus Carloso, turin=C4=8Dio t=C4=85 pat=C4=AF=
 vard=C4=85 su
jumis, kuris dirbo ir gyveno =C4=8Dia, Lome Toge Mano velionis klientas ir
=C5=A1eima pateko =C4=AF automobilio avarij=C4=85, kuri nusine=C5=A1=C4=97 =
j=C5=B3 gyvybes. .
Kreipiuosi =C4=AF jus kaip =C4=AF artim=C4=85 mirusiojo giminait=C4=AF, kad=
 gal=C4=97tum=C4=97te
gauti l=C4=97=C5=A1as pagal pretenzijas. Gav=C4=99s greit=C4=85 atsakym=C4=
=85, informuosiu apie
re=C5=BEimus
=C5=A1ios sutarties vykdym=C4=85. Susisiekite su manimi =C5=A1iais el
(orlandomoris56@gmail.com )
