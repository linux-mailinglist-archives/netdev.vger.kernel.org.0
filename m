Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4909653130E
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiEWOtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbiEWOtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:49:08 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6725535C
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 07:49:07 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c22so13901895pgu.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 07:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GxyBsIEl95H/eEhTmGG6uJoxmDHlvYVn1lk90Snrq84=;
        b=FElMAhjAXKaXrfvjO7I0yZwDtwlmfNmnsmiEKFjCtj81agTLdnkPIeXHR5tT1zD56R
         +MJCQ9bbwYwNyTU3PsUtu1txJifw7coqUzns/2JDNORiXQWNxTiV+tZwh4epIkdr902L
         6TSxWhg0te/02sc9GXSeygkmAAAly8J6D9N6mCyr1HU8YlJ6H9ADACI4UGOunWPZxyUz
         +QPBxVpPo5415kvDooTYyG1T1sXT5eAd3gKufxcnl/qWI1aMTRI6TbU3zF5SeVVBKh3b
         R9RCvHPyhW7MikJUCccKr1yEBwRIqqTZh1DSEmJkdchSwHp0f/akAznJDXeqyXuO1BM6
         V1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=GxyBsIEl95H/eEhTmGG6uJoxmDHlvYVn1lk90Snrq84=;
        b=OLCDprEQJcFKPukskRJJb9HOHWpigc/U/n7BXE8+rHGrnFkLc/j0V4PkShgsV0gOVy
         Dq6+r7ZnZ63st5L4hhzN2eq2wcDVdb1m4IC7ZQDIyqdx5lfxpMfHVZki+pxbHYTlkMUw
         a3Et6A+f3sOg00HKgy21TBDnxEDDzbUjZk27FSk0cwtB3GDxUAWWSUxlxm+l5LMJixIs
         9rdFBA9k9IH3yWqigmLRGjarc3NNe041y5pglWnJHo564nSt0i/iZHQg8Jlc+gb6P6gT
         s2k0+K2ggyLJXv2DxfLqXRRphHw9aXDLRVR9Lfh5jFyArJR4DN5P2oHKpa41j42+hO6I
         RWCQ==
X-Gm-Message-State: AOAM532AxDYn/bvu673KnOiW/EjyRVOSF+QI7uNGyW7zFlIyCEK1d5F0
        c+AYHQ1FLoIqNqncw+KokyURYS5iCmDptQJoPUY=
X-Google-Smtp-Source: ABdhPJwsSF88d6lHvp3dYcIcBweO/XvV0adtsZ+0PuaRRBlYYe6FOLurPdZ5A6qZXMxmZg+KFcdTj6sM5+DHjLOIjTk=
X-Received: by 2002:a05:6a00:1807:b0:518:ad18:e514 with SMTP id
 y7-20020a056a00180700b00518ad18e514mr3550064pfa.70.1653317347285; Mon, 23 May
 2022 07:49:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:3b6:0:0:0:0 with HTTP; Mon, 23 May 2022 07:49:06
 -0700 (PDT)
Reply-To: abrahammorrison443@gmail.com
From:   Abraham Morrison <scowil283@gmail.com>
Date:   Mon, 23 May 2022 07:49:06 -0700
Message-ID: <CABYci46huk5+5_XxKQrZUHD0nhpfaghG-6kuiMoTgTpyUSLa-A@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:52a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abrahammorrison443[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [scowil283[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [scowil283[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aufmerksamkeit bitte,

Ich bin Mr. Abraham Morrison, wie geht es Ihnen, ich hoffe, Sie sind
wohlauf und gesund? Hiermit m=C3=B6chte ich Sie dar=C3=BCber informieren, d=
ass
ich die Transaktion mit Hilfe eines neuen Partners aus Indien
erfolgreich abgeschlossen habe und nun der Fonds nach Indien auf das
Bankkonto des neuen Partners =C3=BCberwiesen wurde.

Inzwischen habe ich mich entschieden, Sie mit der Summe von 500.000,00
=E2=82=AC (nur f=C3=BCnfhunderttausend Euro) f=C3=BCr Ihre bisherigen Bem=
=C3=BChungen zu
entsch=C3=A4digen, obwohl Sie mich auf der ganzen Linie entt=C3=A4uscht hab=
en.
Aber trotzdem freue ich mich sehr =C3=BCber den reibungslosen und
erfolgreichen Abschluss der Transaktion und habe mich daher
entschieden, Sie mit der Summe von 500.000,00 =E2=82=AC zu entsch=C3=A4dige=
n, damit
Sie die Freude mit mir teilen.

Ich rate Ihnen, sich an meine Sekret=C3=A4rin zu wenden, um eine
Bankomatkarte =C3=BCber 500.000,00 =E2=82=AC zu erhalten, die ich f=C3=BCr =
Sie
aufbewahrt habe. Kontaktieren Sie sie jetzt ohne Verz=C3=B6gerung.

Name: Linda Kofi
E-Mail: koffilinda785@gmail.com


Bitte best=C3=A4tigen Sie ihr die folgenden Informationen:

Ihren vollst=C3=A4ndigen Namen:........
Deine Adresse:..........
Dein Land:..........
Ihr Alter: .........
Ihr Beruf:..........
Ihre Handynummer: ...........
Ihr Reisepass oder F=C3=BChrerschein:.........

Beachten Sie, dass, wenn Sie ihr die oben genannten Informationen
nicht vollst=C3=A4ndig gesendet haben, sie die Bankomatkarte nicht an Sie
herausgeben wird, da sie sicher sein muss, dass Sie es sind. Bitten
Sie sie, Ihnen den Gesamtbetrag von (=E2=82=AC 500.000,00) Bankomatkarte zu
schicken, die ich f=C3=BCr Sie aufbewahrt habe.

Mit freundlichen Gr=C3=BC=C3=9Fen,

Herr Abraham Morrison
