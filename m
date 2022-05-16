Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98615292C7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiEPVVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiEPVVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:21:54 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634BD1BE96
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 14:21:53 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id y2so3657271uan.4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 14:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=boZL8sxWa4d1tSO8Vkf2XAGcnSBFA0JviefhzZinYdg=;
        b=ZC7/nDRamk5/ShN6dsPL3+UR7P7VeEexIHDfKj2AgVfgOKpt8sXx0iCaFLoDMxZCMf
         1tlNJ2vyI/Vh4J2Wld9sa2YOqzNdFaKrAaLBi5oPq0+u7w2IZlDKJTz8gbuBgRch439g
         dEw3AEntlakFBYO2RFlHcCvYBHlqO6UG5Uj9sCEFwUI+8HYBxm5/6Bqooj0XjEcx5xsd
         4Qza4MLLvkNph1K8FJR/ehQTAO/BVKr9p/H3z/ksWWfvXvFnEZcnpZOcXsd12+5ECpf4
         FWVwqcW6AXGzh4a6fyk1/do1kOOgnFdF/4wY4+qLjiaAmeNw8iqmWFmQgqSc6p4hu1oC
         2vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=boZL8sxWa4d1tSO8Vkf2XAGcnSBFA0JviefhzZinYdg=;
        b=JHjyspG6c4h+xX8Brmg2bvJijL71YZ5cKs1SA269A2pIagXg9Bc7hITKIP0rbveNL7
         QSFioAvSe9Uz/pbd7YAWboSz2Fxy5lzqjGM4DsZgx6QjlcrOraXgisJJZdQ9nEBVjPXb
         DiYP4PaAFMr6DCdK5AHP0AcO61QGEifaHL+RSrvChLzB9nic7H0SXafpc02mehFseteb
         sy04FQY90GkvbM/UoOgFguL8pf7PaD2ZYiYQfLM0wsoWvMPKMbHNbzI+xkLa+DIxL/5v
         930Tygg+No1Ke7QEiKWG1esea/9+O2fuirIGj6JN1aAGgqJTPQSRZyKft2L/38XBqegP
         Nrng==
X-Gm-Message-State: AOAM5321LsuihMpiJqQ6CPrFdkIRHE8i1XScZfFmioJGHizKnUiT1J7Z
        prUCkPuCq7t6kuOpSGtsMtMwO3trpfd7d4+YYF8=
X-Google-Smtp-Source: ABdhPJxTqu2FEqAlj/xV2A4Q+0IQVe3Qlgp4njVrz9PiNg1BogQP20uXqeJ/hXcuFkM64XxGQWwHGP/wDwT5zw/B2TE=
X-Received: by 2002:a9f:3084:0:b0:360:1fa1:6aca with SMTP id
 j4-20020a9f3084000000b003601fa16acamr6751706uab.57.1652736112166; Mon, 16 May
 2022 14:21:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: azzedineguessous1@gmail.com
Sender: princessangelbasham2001@gmail.com
Received: by 2002:a1f:7207:0:0:0:0:0 with HTTP; Mon, 16 May 2022 14:21:51
 -0700 (PDT)
From:   "Mr.Azzedine Guessous" <azzedineguessous1@gmail.com>
Date:   Mon, 16 May 2022 14:21:51 -0700
X-Google-Sender-Auth: yKhiJeq_onCNJhSAQrFkxUWmj5E
Message-ID: <CAA_LgCYvt63xEjjPJ-d7KaRz4LBMAf=-2hCk0oepD_A2VZJLWw@mail.gmail.com>
Subject: VERY VERY URGENT,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,NA_DOLLARS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:943 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [azzedineguessous1[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [azzedineguessous1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [princessangelbasham2001[at]gmail.com]
        *  1.5 NA_DOLLARS BODY: Talks about a million North American dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  0.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good days to you

Please kindly accept my apology for sending you this email without
your consent i am Mr.Azzedine Guessous,The director in charge of
auditing and accounting section of Bank Of Africa Ouagadougou
Burkina-Faso in West Africa, I am writing to request your assistance
to transfer the sum of ( $18.6 Million US DOLLARS) feel free to
contact me here (azzedineguessous1@gmail.com) for more clarifications
if you are really interested in my proposal Have a nice day

Mr.Azzedine Guessous
