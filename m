Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9165D74D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjADPec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbjADPeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:34:31 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D961B9C9
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:34:30 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id c124so36869200ybb.13
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 07:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eitTHaXGAas6RiUhUstkoB1912ls1ebaROraxJ/kDps=;
        b=d+3o4pCcQwkKdv7NZGal7VlMiVL1TPGphYZ+boA/JfSQQbQKfsYHLwCfWrFYPVxDv4
         7asehRP5kAm4Qv58het3xmDqjubfYmJ5tPRgR+OToMYru/QvIW97LpbLEjf8nRpa/1Lq
         HmGpnmudHksuhcm77jKMq1+ySKiJEphpGEbVNG7OLbtmzETpUUxApEriUHvm03AaZpFM
         P6Gll4jzb8ovE0X0FOZk9ZlLTDh5jfLuthyCyFKWu2mpQEJ37DhStEti+jiUHeoo5STb
         sjPACtXLd0IyejeZZjEIhYoEkL/FeavdfXBwThhDLvbwHNoZ+evF/GVXvLW99/p/AMHU
         TPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eitTHaXGAas6RiUhUstkoB1912ls1ebaROraxJ/kDps=;
        b=ukFl8QxJ+v9SG38tl95s9EiWOYo725Uz0Wknt/6a3R0UFRoUW+jUlBrUTSdFJWQ6TN
         bqsTmAk+I5AV707ok/FHE2j/Yj6E0QMTYMaR7EF5NAQvV1TnnxcvCGLO0EFnxR135IF2
         QXuIHSVxg/4/UkYIbnyVm01odv9UCOUl52Zzc1ZK0qzKRs+9yBvbjEhMRhldLlQ4W4Z6
         2KPg+bnqFroRKnR/MyAYcIXeGUsbdZkjbLCyk9jzF8dx/+eGbraPWQIhDfI+SfORU0Q5
         f3UUUR338MMihelA3jfKEvulZUpqxiCUHWYzlNGH1iaCnQiN56PbwOsuasUw4B8KjYnD
         DzMw==
X-Gm-Message-State: AFqh2kpJO1AlKkDSDO1b152I0Xm/avmU5F8GG4rphB8vYpyEfn68jWZp
        u0YwTJ3sTtI8r66jBl0s+oWlZxBmp3U6DgCL9pY=
X-Google-Smtp-Source: AMrXdXtg9K/JlJH06t3Aw7pgBh33gg9J941hWl/dntotJdzQBdO56L3BkVvLyMbZ5rYiEfPgv0R+4m9qeKpnuhu9tMo=
X-Received: by 2002:a25:ba89:0:b0:70d:a0d0:4649 with SMTP id
 s9-20020a25ba89000000b0070da0d04649mr5548954ybg.488.1672846469462; Wed, 04
 Jan 2023 07:34:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:6309:b0:319:8b9b:d228 with HTTP; Wed, 4 Jan 2023
 07:34:29 -0800 (PST)
Reply-To: abrahammorrison443@gmail.com
From:   Abraham Morrison <akavioffice@gmail.com>
Date:   Wed, 4 Jan 2023 07:34:29 -0800
Message-ID: <CAJ0TFYCD=uCPCmvHaxbnn95ebBYMSeWduse6gts=JjN0Ty-y9g@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abrahammorrison443[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [akavioffice[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
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

In der Zwischenzeit habe ich beschlossen, Sie aufgrund Ihrer fr=C3=BCheren
Bem=C3=BChungen mit der Summe von 500.000,00 $ (nur f=C3=BCnfhunderttausend
US-Dollar) zu entsch=C3=A4digen, obwohl Sie mich auf der ganzen Linie
entt=C3=A4uscht haben. Aber trotzdem freue ich mich sehr =C3=BCber den
reibungslosen und erfolgreichen Abschluss der Transaktion und habe
mich daher entschieden, Sie mit der Summe von $500.000,00 zu
entsch=C3=A4digen, damit Sie die Freude mit mir teilen.

Ich rate Ihnen, sich an meine Sekret=C3=A4rin zu wenden, um eine
Geldautomatenkarte =C3=BCber 500.000,00 $ zu erhalten, die ich f=C3=BCr Sie
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
Sie sie, Ihnen die Gesamtsumme von ($ 500.000,00) Geldautomatenkarte
zu schicken, die ich f=C3=BCr Sie aufbewahrt habe.

Mit freundlichen Gr=C3=BC=C3=9Fen,

Herr Abraham Morrison
