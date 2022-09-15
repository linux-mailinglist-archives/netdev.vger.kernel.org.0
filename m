Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B2D5BA1F3
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIOUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIOUsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:48:08 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037BA9AFBD
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:48:07 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id v15so15153955qvi.11
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=ehheP8jppS2f72pRenEm2Z0QBXSMtn63HAEcQzDP0es=;
        b=K7w6ovsuahvzDLQwRewb949nZzbOqb5kaS3mjlkx+Ie30kms9jI5uoVwFULUga1HE6
         5X3uBS0xI8O5Xe4IgFNPIsHL6YN81T4rpMe3rdza41wfoKuwNL/iywpuRmDuXvE1Kyrn
         BHlJ0A7qd8IBqJhLSGjkGxvbcBR1rwmIaWl+2L2mveFg3UhMt5Nb1WiCOHi8uciwrM8Z
         KXugZGmltHANWhKIgnCCfQtAd5IeIAWaXvjxOZwxXVdzi3bPtIiCyoBXBfGN7a1XCcey
         sirsXS9khzLI1kS/ngEMi9S5fZ7ET6grrXusyCwcCl1TLB8XqPKfDu1PSZoJjM868kEm
         cBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ehheP8jppS2f72pRenEm2Z0QBXSMtn63HAEcQzDP0es=;
        b=YzQpEzm0u/IX4RqwMc0n9hsmmk1wE0AORQ4uv+896EL2E19kE5Y7cHEs9c8Ii8gN6v
         xQA22iC93o1trI36GsoAxJHHQu4Zz7YC3I733XnQXbxtXaZyeMkOUDnzYm+LrL0mbRoY
         cHT5O4ciomyUYm6k0THkevMmuwSIb9KQucNAUCzSWVHAlWIqnFnhf346Qw3OQrpUC6I/
         NOgZxdSxoZuS3Blu602aRu1qeMIeuBoSuipvQXjkT7Dy/z33FXVnaB0U5RixPOHP21XN
         oy6KUwP3VayAKTXHSO9oXV28YT4mDt5EyOYEpqVEtFwMWiC5M7yEH+0TWcJPJ/OnJBCc
         YorQ==
X-Gm-Message-State: ACrzQf1+YxmYSZTLvq1cidQBT1a/aETjH4RRtN4xZy8ksEzuuTBbq4Rg
        BCX4N8HcxKdn32QdeIXaZTdW9kWwn3voveWIL/s=
X-Google-Smtp-Source: AMsMyM4DbnOvl0vS4IBZqmEHYjX9eag1xjDWx5HJghNa52uRcoX9Amm1k625lTYSHFiEJFK+TAmvV8O+DehlJWfizLI=
X-Received: by 2002:a0c:e006:0:b0:4a7:23a:4bd0 with SMTP id
 j6-20020a0ce006000000b004a7023a4bd0mr1803547qvk.14.1663274886235; Thu, 15 Sep
 2022 13:48:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0c:f54f:0:0:0:0:0 with HTTP; Thu, 15 Sep 2022 13:48:05
 -0700 (PDT)
Reply-To: proctorjulius@yahoo.com
From:   Julius Proctor <mjacqueline148@gmail.com>
Date:   Thu, 15 Sep 2022 20:48:05 +0000
Message-ID: <CAPqBFRgDk4V=zUpuvCRnR1NZC3VnrgT98pZVbMbTcmv8RfQ-og@mail.gmail.com>
Subject: =?UTF-8?Q?Ich_w=C3=BCnsche_einen_gl=C3=BCcklicheren_sch=C3=B6nen_Tag?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:f42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mjacqueline148[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mjacqueline148[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.5 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sch=C3=B6nen Tag

Ich bin Julius Proctor, Anwalt der Anwaltskanzlei Proctor. Ich habe
Sie bez=C3=BCglich des Nachlasses des verstorbenen Dr. Edwin in H=C3=B6he v=
on
8,5 Millionen Dollar kontaktiert, der auf Ihr Konto zur=C3=BCckgef=C3=BChrt
werden soll. Dar=C3=BCber hinaus m=C3=B6chte ich, dass Sie bei dieser
Transaktion vertraulich antworten.
Julius Proctor
