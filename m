Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA106964BA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjBNN3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjBNN3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:29:40 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811AE25E0E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:29:27 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id a2so15651096wrd.6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Kd+0PRIozRk0J8pGf0G8pzjxgUvDtYPAzcmmxZ1k7E=;
        b=idqsSeUMCLM2VbPxkl20eOLvcyMScxsEBkEy/BZ4V9rVlBeZUde5+QuV3jWTnzQ4Qm
         Vq0a3a9cmEj1hESqR45Ht2wbL2t7Z92b2anjj9vTPdPIvVh7zelH0/21pnGkVEvVYZsz
         U1OQBFu/L879uwe9KixuUaoN00aX714IDqgsX2G/9sksOxFaysxUhRChWz4imqfGS8D5
         K/kh3ytWySS6pxvDee8KLnHjzjP+VmmEAcUFcGeq7A+uhF2x/j9BDFZvee1TQpRoLvFN
         2msr8V1H4cJYapRkfAs2ealstYI8sjwsvTp+boggNeeVqsgnlTLItyrevLfgYe++qR9N
         jsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Kd+0PRIozRk0J8pGf0G8pzjxgUvDtYPAzcmmxZ1k7E=;
        b=Fd93dK8XDwhK7GAbmIICFLC/Orgme+mphIIePKnqrOxH0UtLA3E/tg3/Jv3yORHP+1
         ri7mxQoUoBm+CjMai6aKi/UghtsO1OxCVGtOEQOIFF7hmA9HMegYml9XaKpoDlXzndlL
         AHHmQPlAFmmCmOBwj+zxw5eH1bbCMwyOlpH96964veRywOdS55sNOWEvjUsR2jIe8Sy+
         mz8/P2QhXW6JFNzQnWvGjo6zaM1FxeWuTm++Jt8IRWnqLnCJIlN+kXKuWOh0T0z62bvm
         r4XSbG+/RmU8W6UCV/LdF1yZZNgTyTFg3bPaKasKreSxdpkAOLvAkBFpS477q07F1VxS
         Wb/w==
X-Gm-Message-State: AO0yUKUOY5ElonuOctrwyJvI5wV+rTquAnHCCYBSLIcyNLjktpIPjJWK
        +MJ9p7hVxLdLhqJWGD/Yp6bLCU/cdK8PtwM+Uxw=
X-Google-Smtp-Source: AK7set8I7lBUazIFMsLNtaQDKNaQqXOX+FcIaqOhsIJ0zU4Zs5omj8mAg0rUMzMAz2+VA++C2dCQMosVF3bmL2IJjw8=
X-Received: by 2002:adf:f741:0:b0:2c5:4a1a:d06e with SMTP id
 z1-20020adff741000000b002c54a1ad06emr59551wrp.384.1676381365638; Tue, 14 Feb
 2023 05:29:25 -0800 (PST)
MIME-Version: 1.0
Sender: ibrahimat925@gmail.com
Received: by 2002:a5d:4ec7:0:0:0:0:0 with HTTP; Tue, 14 Feb 2023 05:29:24
 -0800 (PST)
From:   Sandrina Omaru <sandrina.omaru2022@gmail.com>
Date:   Tue, 14 Feb 2023 14:29:24 +0100
X-Google-Sender-Auth: tjeQcnXvscB8DVl1IbOyxW4U-uk
Message-ID: <CALJnfyued1hAAR25KwiP2D3NTUYhKs3ayQbPw9RND-t4DwxnEw@mail.gmail.com>
Subject: Compliment of the day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.2 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5942]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:444 listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ibrahimat925[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ibrahimat925[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compliment of the day

I'm very sorry for this sudden contact. I got your email address
through an online directory and I am contacting you personally because
I seriously needed your help. My name is Sandrina Omaru I am a 22
years old girl and the only daughter of my parents who were both
assassinated during the political crises in my country Ivory Coast.

My father worked for many years in an oil drilling company and he
deposited some money (2,300,000.00 Euros) with my name in his bank
before he died and I want you to help me transfer this money to your
own bank account in your country and also help me come to your country
to continue my education. This is because after the death of my
parents, my wicked uncle wants to
kill me and collect my inheritance from me because I have no one to defend me.

He told me that he deposited the money in my name, and also gave me
all the necessary legal documents regarding to this deposit with the
Bank, I am undergraduate and really don't know what to do. Now I want
an honest and GOD fearing partner overseas who I can transfer this
money with his assistance and after the transaction I will come and
reside permanently in your country till such a time that it will be
convenient for me to return back home if I so desire. This is because
I have suffered a lot of set backs as a result of incessant political
crisis here in Ivory coast.

Please, consider this and get back to me as soon as possible.
Immediately I confirm your willingness, I will send to you my Picture
and also inform you more details involved in this matter.

Kind Regards,
Miss. Sandrina Omaru
