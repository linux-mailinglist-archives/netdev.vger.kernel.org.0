Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405305479FC
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 13:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiFLLxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 07:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiFLLxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 07:53:31 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EEA5F93
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 04:53:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n10so6142910ejk.5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 04:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=9FfohXFhB1sP403VxH1swwcmiEO4r97TnueS6gdgla0=;
        b=ge8pz5PH7Z2Ns8pFbL6KNM0EzLxd4jrcOn/3pNRLfTmekkcK+qx66aigLL1BCJcUCY
         7XSw8JCq2jjaCfl8B/OeYHFctOWyITWrYWEUmeSkiVrBHKJ9aGOC86Ds7vhzEB4Hccya
         qnFuQDJref3aC+ntJomBudX2faXFFzjlZBeWuGh+7b/y+XOGf56Yyi6h/MaMM8HGHORp
         04X3QZWxFNpgGZHur+Nqd5Tslh9ThtRNFhZT/1IX65LJzc355Jyn7Cqv8+rXbefHp5On
         UpogwNa5pyHxFeD9d4QVLHD+osDguUzjR07YkH+NKYVd7elb/DO8MTitKxUUrrabCrsf
         LfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=9FfohXFhB1sP403VxH1swwcmiEO4r97TnueS6gdgla0=;
        b=cKI/Q3wL/doeJUU5Ebcpj28ClSZcKWXLIO0Voucpzr/TEH2lekl89BIXL48GLN2VFQ
         AsyIsVefRqeLMUBpldwpKzXTUA6qIkja8yZU9LzHazfsqulKtOYMWiPw8m/DK4IWYxjS
         QJLJlXCRZN0dr1EyMNIxiJl/gLoDYBn/IUF35RinN0eVDzS4GvHA7Ox8WV66ubPOIMcg
         H/AoCNb4GHMF6BZmQUXcEVJx2tituL1nzqIFTccZdEgZGrEjmAjdyYaj24Fza2NQx6pd
         9ZtOGo9TVBaMc6+upKm+20mAS0LP44Js6vNc2d65GHyCeM14xebvuYGw2FGrAk38CGWq
         sgIA==
X-Gm-Message-State: AOAM5331TO/JsiaL2vOvIirwJXzV2JHf4tgYj53cMH9Fh9XsRC1cY+BS
        0zwMBdDZkQVoeSzZjfJqW/9xJkDg36I3ZqEF1nY=
X-Google-Smtp-Source: ABdhPJyVJ1mUD7fj0a4XuOpqoU69Y5GMfjuLLPhArJyYK/tV3ib8IFxvZ41FG+XUnfva1Mg961j/3s5GZk/QLkQn5U4=
X-Received: by 2002:a17:906:544e:b0:6f3:bd59:1a93 with SMTP id
 d14-20020a170906544e00b006f3bd591a93mr47785148ejp.421.1655034804226; Sun, 12
 Jun 2022 04:53:24 -0700 (PDT)
MIME-Version: 1.0
Sender: mariajohn0331@gmail.com
Received: by 2002:a54:3a4a:0:0:0:0:0 with HTTP; Sun, 12 Jun 2022 04:53:22
 -0700 (PDT)
From:   MARIA ROLAND <mariaroland74@gmail.com>
Date:   Sun, 12 Jun 2022 04:53:22 -0700
X-Google-Sender-Auth: 0wxfga433qiK6YjScCGAU3-3rxE
Message-ID: <CAEmdD2WWN+1YBZ-q0mdUkrMOPUO97kVjcha53HQdL2j1zQ0H-w@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_60,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6618]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mariajohn0331[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mariaroland74[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night  without knowing if I may be alive to see the next day. I am
Mrs. Maria Roland, a widow suffering from a long time illness. I have
some funds I  inherited from my late husband, the sum of
($11,000,000.00) my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my stroke
sickness. Having known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your reply,

May God Bless you,

Mrs. Maria Roland,
