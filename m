Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFDE53A46C
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiFALyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbiFALyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:54:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387CA62129
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:54:43 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id n145so1442054iod.3
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 04:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jPUA8M+g+0dOjNukOsDFBAWZqdy9i91dv7n/r5pIqKc=;
        b=naykRkAga649LMITuoPdZpmnv8ETUVRPLI+83xcv8UwXUFb6djsko3ciXZ3vWZIx6X
         8JqGcTHXeplb6e1pr7D3IdGMFbNAxYOXu5+B+qtnK7q8i87XLjenUk71O2TYpBsJlz5j
         DSbJy7Y52gCo5WpvXZQYzgVPqRQtcpbpj6FnClLVg8HsIHpEy+QP2UJ2eu15DSUloRS1
         2bcwP2YFGl1y+U6IDCQMC7UW8hthlWLhtL+d6opXeP3+RfzC+QRqkNpICQC+ZwOMJxvB
         Mromw27m5DX0ipPiuU4pFzMXP+lvbrD5Nej+o7eRmHSeXD5HUlyMHTmrvhD5YjMXgqus
         6e3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=jPUA8M+g+0dOjNukOsDFBAWZqdy9i91dv7n/r5pIqKc=;
        b=kBQdb33i0dusjQdd+IhMs4977zWOKTux1sw1nuMswJkY4h2i4Y+/PFFD3QVR31afim
         71VhjfDnPya4HoheC3ca6lCvngKHCYsBMCsXjzHAUlm5wpeIo8ilSSgZDUvggZIXRsXK
         s1B3B468GedUV9hiZmwglH3o1R2ERyJ1/WUyrWIuzW3IO40XlbEFd6tJAPUhP73rKx+m
         44xC8McUMGpEIN6h0/DX5tVT2ldIfW/jm0yLCNl4O6I5aTjSkFwlZ5ubVZzuXkZcrtSl
         jI0YbZ9Xqj3g8o+A+JyW6KFBeL6Wi1rD9sCycM/cZrgte1H6ZMcY+KMrEk04Ia8RGDbf
         H14Q==
X-Gm-Message-State: AOAM531LTidAroUdKnAc6G47ZBRJ54c2hukfoYDp4F5ZAfs9E3KURr42
        YnXom20/2WL+2UZs3wCkBOlyQ04YJkdLC4c/QTw=
X-Google-Smtp-Source: ABdhPJzm1DfyMCG6/2LgTJiu/wI3WI3m2V9yO17jLt/8ofbkDSZgQqbyxo3iqm8x2Ns0c0TtjIDVlE5+Dfu9DyTgVIw=
X-Received: by 2002:a05:6638:2404:b0:331:48f:bac0 with SMTP id
 z4-20020a056638240400b00331048fbac0mr10738367jat.306.1654084482667; Wed, 01
 Jun 2022 04:54:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6622:1706:0:0:0:0 with HTTP; Wed, 1 Jun 2022 04:54:42
 -0700 (PDT)
Reply-To: attorneyjoel4ever2021@gmail.com
From:   Barrister Felix Joel <attorneylegallaw.tg@gmail.com>
Date:   Wed, 1 Jun 2022 11:54:42 +0000
Message-ID: <CAAQVDNjP3V8=wnFUQYdPOYDn7x6HCjz57smyQJkWxqbooRK=Hg@mail.gmail.com>
Subject: =?UTF-8?Q?jeg_venter_p=C3=A5_svaret_ditt?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Arvefond
Jeg vet at dette brevet kommer til deg som en overraskelse, men det er
for en st=C3=B8rre hensikt. Jeg er en personlig advokat for min avd=C3=B8de
klient, som mistet livet i en forferdelig bilulykke med hele familien.
Jeg har f=C3=A5tt fullmakt fra bankledelsen til =C3=A5 presentere de p=C3=
=A5r=C3=B8rende
for avd=C3=B8de som vil ha rett til fondet eller f=C3=A5 det inndratt ved
fullmaktens utl=C3=B8p. Vennligst kom tilbake til meg umiddelbart hvis du
er interessert i mitt forslag for mer detaljer og avklaring.
Ditt samarbeid vil bli satt stor pris p=C3=A5.
Barrister Felix Joel
Republikken Lom=C3=A9-Togo
