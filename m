Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7188B58AE92
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbiHERBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 13:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiHERBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 13:01:36 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B51DEC9
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 10:01:35 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id o15so4657380yba.10
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=npxCWy2DywcBQq9OCNxxK3fUiVjXtjApy10t54oASAI=;
        b=Lsm4yAuNkqXNa96UVJv+Tm22BiYV7dxEldlqXRhm2mScD6tXGXLLRHaaR61nZWnLbE
         y8jub1ufsppa6D+tkdvdRMjjj3gtXvGNCTjTJ7AGrUsuY7MWpGlxnBG0ifVhkNXoxFI6
         TllrCtfO/SBsGM6wBpxfJnU0giQBpSCQRcqYs6RoDdADA0mLI9HdUHFaLCVIYARz9C9P
         cj5oF1j9JeYjKbYexIdSVz6sM90dm932DXNKcphBdV+pF5h9hcU4sNe1Cle1FfqH8/4j
         L2dz6OYrHQZbbbvs+TFI8h2ZXICEK1xvOqMjx1k2gWh8gpyC9Ct2jhdsTDaKMh2KgMJW
         q9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=npxCWy2DywcBQq9OCNxxK3fUiVjXtjApy10t54oASAI=;
        b=ykQ4L8H0zHooMoInS2I52WJeqn6pjnSdvHKpaB+IfGVFO5LqV7Po1ZPZRRUabfKjZ3
         DSpte17nXT1/YL1BOiEt8sq1TjW28Wk/Ikau4J58qVOeB/3pa3OU3joG70AjGow9RNsX
         1/gaHfzeMstksUFI5MMrkvGRJPDKjCm0/yQuyAFAIQ28rHJRmoXlh9lBlofC1xvSaxB2
         zJbmiwleqsc1HPe+12aWh2cDrGq/T91JlyR7Sci4v53d7SfNVBs34sppMmgCZdoYXeOc
         m4Y1Kpark3mEdACym7ohmDPMu4cp/+vKwEjOoPaFr4eIgicI/uiWvy3ZoKjla30o8w4X
         qQMw==
X-Gm-Message-State: ACgBeo28nLR3QaUOy+KDQrsdAQ4a0k2wROvBWosSnoDEel3/pJ7c7h2Q
        t0Y+vERLmcuj2hs4qVwjknnA8JWCt6k5Iu/cPQ8=
X-Google-Smtp-Source: AA6agR4aVIKJQZy2DaAVi/Dn+dVrCUNq7rwJ541HH5bxVGfqxwMd8ozP4l5PKjEqaNvYm6OVL/xO7GY/KuxI5E20lWY=
X-Received: by 2002:a25:b68b:0:b0:673:df99:5838 with SMTP id
 s11-20020a25b68b000000b00673df995838mr6170035ybj.157.1659718894523; Fri, 05
 Aug 2022 10:01:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6918:130a:b0:cd:907e:bca with HTTP; Fri, 5 Aug 2022
 10:01:34 -0700 (PDT)
Reply-To: abraaahammorrison1980@gmail.com
From:   Abraham Morrison <drjameswilliams1926@gmail.com>
Date:   Fri, 5 Aug 2022 10:01:34 -0700
Message-ID: <CA++so7m=QDnMu+VLGCFV+qwBwbNF4Kc8xGyR0E1TBAEugTxZww@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b35 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [drjameswilliams1926[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [drjameswilliams1926[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abraaahammorrison1980[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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

Ihr vollst=C3=A4ndiger Name:........
Deine Adresse:..........
Dein Land:..........
Ihr Alter: .........
Ihr Beruf:..........
Ihre Handynummer: ...........
Ihr Reisepass oder F=C3=BChrerschein:.........

Beachten Sie, dass, wenn Sie ihr die oben genannten Informationen
nicht vollst=C3=A4ndig gesendet haben, sie die Bankomatkarte nicht an Sie
herausgeben wird, da sie sicher sein muss, dass Sie es sind. Bitten
Sie sie, Ihnen den Gesamtbetrag (=E2=82=AC 500.000,00) der Bankomatkarte zu
schicken, die ich f=C3=BCr Sie aufbewahrt habe.

Mit freundlichen Gr=C3=BC=C3=9Fen,

Herr Abraham Morrison
