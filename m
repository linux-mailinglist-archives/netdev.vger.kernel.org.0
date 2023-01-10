Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B03C664336
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjAJO1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbjAJO1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:27:34 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0072FF
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:27:27 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id y18so9112980ljk.11
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RS436Ldma8wZlk3cJGWkUUxffXR5+mVk7a3h81qpfFc=;
        b=RlAH80/LZEWXOYjK9IbxTQCN/r5y3zqcorO027Ko2duad7fHs/oVWaofVSdMvshVEO
         XCOOeZku2dj56EhiwJWzSksCDUbxi0hANab4z3kwybeDB738KkWa4wDuTQPFYx/s8M67
         t1VrsmmsGp9wxqKkoZQ/eDLnvZd38tPf9fjZqDK8LU0oMnhikoMwJuDbG4PqTqKHrzpm
         yyKoGFKU6WbZkAOjqXFoy7HHMg/KAZ7glrA10nrhqFZW1/NF3IfWjIwGGZ1FMPTO7hlY
         PbMyZ5eMPFoNYjZkztH11ERGDVVngxHGok5/Onte4OG1N0GHV+81+dyTQcP4KGVp7Pbd
         FSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RS436Ldma8wZlk3cJGWkUUxffXR5+mVk7a3h81qpfFc=;
        b=YNtY9ZFvgjhtj7eKddFVOL406wicHuBuXTudTb2tybWjaPnkjO5ArS67F/JeDza6Gz
         Tqf9pQK/bxdUIzriyFxbWSjAWwRpyljWsRerwjWcgz4wtZSaGTcvnJFQIdi01d//stlF
         oXPsrWXt3dBpK9yl7arfj20bWpht7lx7rhTt2Zl92UoF6fAlNsPqQmIDqyomkKmC12Qq
         KtuP8PWuN0zEr0C+aSgwXYl2RtIL512dTLLI2rmA4apqTJqWurj9q6LSZPMugA+oqLVC
         KijrpeyLnFziojjIaubAowYV18S+3l3Ofx0EUOmEV+vM2ShBqjbc+UB3Y47hNV+butFF
         mtww==
X-Gm-Message-State: AFqh2koNcvMh44AfQmJRuwkwjS906y5nT+0E0y+eY/XnAnn/wDIVCgSg
        w3GhpVcxcfGTgxupKqE6Q0dLWRBHsmsvIXJIfVw=
X-Google-Smtp-Source: AMrXdXtSw9zHdqnDgjBrZRMFNVbVq8ASUQdbC1f8AZbojBjqDzk0bZzbdni/jyxih9xwQB6LyVuzGZ8tTJ2L2DW+K50=
X-Received: by 2002:a05:651c:211f:b0:27f:7190:5ae1 with SMTP id
 a31-20020a05651c211f00b0027f71905ae1mr5812051ljq.238.1673360845282; Tue, 10
 Jan 2023 06:27:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:8449:0:0:0:0:0 with HTTP; Tue, 10 Jan 2023 06:27:24
 -0800 (PST)
Reply-To: idrisibrahim1000@email.com
From:   "Mr. Idris Ibrahim" <abubakersuleiman539@gmail.com>
Date:   Tue, 10 Jan 2023 15:27:24 +0100
Message-ID: <CA++FR5FrZdB-emrKe2RRSSi9W5PHbb4HtKF4rSqRU17qL59aoQ@mail.gmail.com>
Subject: =?UTF-8?Q?Assalamu_=E2=80=99alaikum?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5043]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [idrisibrahim1000[at]email.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [abubakersuleiman539[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [abubakersuleiman539[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mr.Idris Ibrahim, I have a business proposal for you, if you are
interested do let me know for more details

Thanks
Idris
