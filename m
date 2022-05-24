Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513B0532C1F
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbiEXOWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbiEXOWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:22:19 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1E5606C3
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:22:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id q21so15492686ejm.1
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=amfo7krDAamEYJ4a7A+EJVO64lgmgvwc9CJ5YTrOkPU=;
        b=LwEpLTtR3I0NX+PgVq2hy68PVPk+6OLYDmIEV84rxk0nK8RJFqsfk9iWIBSEaMXBBB
         pmwGF16YIjyX5N/tfPkoMv9CQW6Qv4wjRbo1WnPrdu7WlXfEtFXmbEqTxkaZE776Ai41
         HwfPtL9aMB4L3AGZT7erSj9sJnHNRc+CGakdjjF5x4ozzEYlqaitfm4fPVNpjhagMfEo
         ClcaKrQ8HNddAoRO+KZvrTDcN5tWMIr2e+gqhuU9dFtX1x9kZMLM5IV3PmAStjIG0rHu
         EFpCCvHEP1Vrt5x9Cv7LHiDu0BmujHZ1ZkiIKqq+ujUYe+vig2oZWh5pfV1hNEjLeAka
         yZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=amfo7krDAamEYJ4a7A+EJVO64lgmgvwc9CJ5YTrOkPU=;
        b=QZFlszL40n8Fik6acL2MTbsLQQt+GTtZKdR939gaIDV4/FwzOdYl9+ZW5jy5aiznSD
         P3QGdUlTvSEBj/7Umh9PT6rghS9XcLFYODjDNvcORQyMT2ft0Lm6hKadbWrgn1ZX7du/
         C9aemP/+3iFrJhy7d3ErgfCAjdlWT3/D69xqkwjod3Im9usXyxkpQPukNsT571RM1oKm
         ZLYv3X0RbdpA74aV8KUUNjMHGEuX+h775W1PyzkWG35JlN6SPVjUrAN7IlTpWNWfnxkH
         vImTSm6H0MvauaSIz0hNRqUuwQZroIiirqaUxK/FUmdIlmovYFhdK2NR59gun2p3QkGb
         mNWQ==
X-Gm-Message-State: AOAM531lHu9X6505mBJE2/xYzd0l3LP/qfIkEN/o58zoiU+9OLz3GFmm
        xrBvwFJzdi0+/tchCXG5g9ixWTD0TTivAj6UpLc=
X-Google-Smtp-Source: ABdhPJxoxGeyHeqt0AIlIM7Bef8uhBgAg6dcBX88nqT8cTbOiHxWoWFRY6bBPGWsWDIjkJc1iWOol7z5KYQVzCH2434=
X-Received: by 2002:a17:907:7f8e:b0:6ff:1f9:61f5 with SMTP id
 qk14-20020a1709077f8e00b006ff01f961f5mr3921910ejc.722.1653402136119; Tue, 24
 May 2022 07:22:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:640c:2f0b:b0:15b:9a83:a493 with HTTP; Tue, 24 May 2022
 07:22:15 -0700 (PDT)
Reply-To: mrs.jenniferabas@gmail.com
From:   mrs jenniferabas <adjeadje118@gmail.com>
Date:   Tue, 24 May 2022 07:22:15 -0700
Message-ID: <CABv96uhnhMxJyMBw01m4c-cDGRgLAXNxYKgp-sbxVAqR=dOv6Q@mail.gmail.com>
Subject: Guten Tag,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:635 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5542]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adjeadje118[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adjeadje118[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.7 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guten Tag,
Ich wei=C3=9F, dass dieser Brief Sie sehr =C3=BCberraschend treffen kann. E=
s ist
jedoch nur
Mein dringendes Bed=C3=BCrfnis nach einem ausl=C3=A4ndischen Partner. Ich w=
=C3=BCrde
gerne wissen
dieser Vorschlag w=C3=A4re
N=C3=BCtzlich f=C3=BCr Ihre Akzeptanz. Ich brauche Ihre aufrichtige Hilfe
verwirkliche mein humanit=C3=A4res Projekt.
Leider bin ich todkrank und sterbe bald. Ich m=C3=B6chte, dass du Geld ausg=
ibst
Mein Erbe betr=C3=A4gt drei Millionen einhundertf=C3=BCnfzigtausend US-Doll=
ar
($ 3.150.000,00) f=C3=BCr wohlt=C3=A4tige Zwecke in Ihrem Land, wenn Sie es=
 erhalten
Geld. Es w=C3=A4re mir eine Freude, dieses Projekt mit Ihnen abzuschlie=C3=
=9Fen
bevor ich sterbe.
Weitere Informationen erhalten Sie, wenn Sie auf meinen Vorschlag reagieren=
.
Ihre positive Antwort wird gesch=C3=A4tzt.
(mrs.jenniferabas@gmail.com)


Deine Schwester,
Frau Jennifeas Abbas,
