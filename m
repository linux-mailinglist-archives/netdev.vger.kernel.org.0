Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC605750D2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiGNOaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbiGNOaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:30:01 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45485C95C
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:30:00 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id i186so1598431vsc.9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=HJ07Z1i8ZEZRBoTFgQMoHNJKLvLirKmxPIXqAh7xErw=;
        b=FJLP3qmCxrzV2p/+HjyjEDLeOEV6M5cFWneHjGLzSCBdMugkHdB4WMfljNsjriMlRp
         AhMbaqpTuXAmbAqJKK3pLrexxRxP3UaDpbzOLaG2Y9Lfnh5/US97ghEClIV+AQh9nwsx
         Nvq4RdB0tkp9NoXOGQPlllREWDdxw7TAwzpAEgrpP1wh1rjUmNaze9DlJ08EMjDLCkxi
         1LHzHKv0hi6FsRa/9JjofxEyES8WsqMeopddf6G/nYdR+r5QZdUMd0Lzfoi0RLMmFAgJ
         ffzXlYJNBZUx/8s8jG45GfqJJ2a05iAtDz3GxEYMRZLQoxeHI3OX4qDUWG3DflaOZ6Tu
         6Tgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=HJ07Z1i8ZEZRBoTFgQMoHNJKLvLirKmxPIXqAh7xErw=;
        b=T5ar0rnNr3nm24BhWRBGGFOjxdMHzaUe/EEdOm00jLfnX6Mew5sdVm2uCISinLc0+s
         frFLentfqMiQqX2tCzV4/FPSksT1jhBRtuRvhZgBwgGGRGV3TGPjdfqZZcjNsPBKijBr
         fT+bN7okwT+omtYSQ65GK3BMKh2788+Ab2JRj9nb/FaKs8MUKvLUxuO6pQFZoiln+vrS
         B9+hWEK/LMeXjCFMjbLBD9wkRbb6/e+nnM/+F9nIWUBcfmcfhqNwraNpRKWL6NWrwq0W
         VlH6P6uPZ+9HcnZmCaAKKQez7g/92UcIlfr88LRbQz8SmYDfyij9cOFytvfeTxTWL98U
         qEvw==
X-Gm-Message-State: AJIora+2H5QBER4S1ucQaju+/+k/BGRFv6VlmmPfzT2lz4D3hiJj35Qv
        +XVDnn8BYS1dxtxvJxzUQJJ85CUnQlID3kxpBE0=
X-Google-Smtp-Source: AGRyM1vQXQPh4rrCC6TaEEoCcYFa6KBkl9YnfoLoIm3suX1Y3r+s4hTIjoGgXJDYAvvAxr9ro3uNd9GcLojHvsUOfoY=
X-Received: by 2002:a05:6102:334f:b0:357:7e85:d2d3 with SMTP id
 j15-20020a056102334f00b003577e85d2d3mr3847930vse.31.1657808999416; Thu, 14
 Jul 2022 07:29:59 -0700 (PDT)
MIME-Version: 1.0
Sender: samsonwood84@gmail.com
Received: by 2002:a1f:5843:0:0:0:0:0 with HTTP; Thu, 14 Jul 2022 07:29:58
 -0700 (PDT)
From:   MRS HANNAH VANDRAD <h.vandrad@gmail.com>
Date:   Thu, 14 Jul 2022 07:29:58 -0700
X-Google-Sender-Auth: eqw8qZQ9zXSbFl6zJHPee-QSmhk
Message-ID: <CAAYg4=Ln4wBi1T1gS32QCeMqssY+v1dAbshGyYNeVs=4Ay84SQ@mail.gmail.com>
Subject: Greetings My dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5033]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [samsonwood84[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [samsonwood84[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings My dear,


   This letter might be a surprise to you, But I believe that you will
be honest to fulfill my final wish. I bring peace and love to you. It
is by the grace of god, I had no choice than to do what is lawful and
right in the sight of God for eternal life and in the sight of man for
witness of god=E2=80=99s mercy and glory upon my life. My dear, I sent this
mail praying it will find you in a good condition, since I myself am in
a very critical health condition in which I sleep every night without
knowing if I may be alive to seethe next day. I am Mrs.Hannah Vandrad,
a widow suffering from a long time illness. I have some funds I
inherited from my late husband, the sum of($11,000,000.00, Eleven
Million Dollars) my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my
stroke sickness. Having known my condition, I decided to donate this
fund to a good person that will utilize it the way I am going to
instruct herein. I need a very honest and God fearing person who can
claim this money and use it for Charity works, for orphanages and gives
justice and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be n=
amed
after my late husband if possible and to promote the word of god and
the effort that the house of god is maintained.

 I do not want a situation where this money will be used in an
ungodly manner. That's why I'm taking this decision. I'm not afraid of
death, so I know where I'm going. I accept this decision because I do
not have any child who will inherit this money after I die. Please I
want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. May the grace, peace,
love and the truth in the Word of god be with you and all those that
you love and  care for.

I am waiting for your reply.

May God Bless you,

 Mrs. Hannah Vandrad.
