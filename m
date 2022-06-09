Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F3A545366
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345138AbiFIRvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345148AbiFIRvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:51:01 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B232B12FF
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:51:00 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id p83so3888628vkf.6
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 10:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8d0a50vlXPwK/evqvKND5Qkww0VWt34LxBu4KEjcCqk=;
        b=Jsq8gp37iudaP8bTyIOKStDp8h/YBsNe+gf6Cau0+Lpx/uKh3rzwH6c5q+WUemGRzf
         MN3ab69FKEyBcUGiXGQNcfbm0rXzTCPeQjMCRdg2GVjrGcNKf9HSPglaViv5DuohuNHU
         NciKFnRjxnosBatApJgyeunO4q7EaKHT7NVTwFLIzmSc8+OGFpPn4GhL2RiZSk/yxpK6
         qqBpCb4ZQRaZzkyVY4BTQIm+TYfro4e5Bw87OKuMbV7cjEaf728QHg0XsmjCFlRg2cHh
         C9Kes+qxENs/uq2lWkfzPRDlQ0idC+xc6sjlR4C8jCGRKzHi/O3rtE4nT8R4FmeihRb+
         JTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=8d0a50vlXPwK/evqvKND5Qkww0VWt34LxBu4KEjcCqk=;
        b=XzEgN3IGFbgAPyRNMr+PcxB/u3Uk+iaZsLUoQiO7b9ZuknCaYDv59RzjbltOXFKY2G
         ONdRdiz08xxSbVZp2z6re4SttswN4gVMo1ZyQD/p3xfsf7ay4Ym5Ppzp5cfNvezb28+y
         Uml+AjuX6Jwaz0XOF3CfKyJaWvb7wJYsowkQskbyucGNqeWSnIorKrGYfw2wPkbLLuic
         Cj8jO+387bYw8T6mm02Rxul1bewVx30D6g0e0zz245LJNSuWvPGFCEDNseWCzGh22ioe
         F17Y7/yvcMHpqK04yY5Y/VYctTx/w3YWIUAsDpVwEVI+h6RDUT4LPb8WOqyQE+qAMnNF
         Xu8A==
X-Gm-Message-State: AOAM532w2yABxzRXxSYATt6puYuVkpe+qENPRdHl55tAHuRDapYPQmRP
        iFqOJEhriIpL4R/VFC9VxuRoMwJWNT+Z1R0lyYY=
X-Google-Smtp-Source: ABdhPJyco0jmI9j1LTlr29BP6+FVZHdtLanDxoTVkceSHjv/cA47v4//gLK+J0hEJD4D9X1Yp4AjF4CrlOxGXniSzKA=
X-Received: by 2002:a1f:46:0:b0:35d:4de2:5ada with SMTP id 67-20020a1f0046000000b0035d4de25adamr16046699vka.26.1654797059440;
 Thu, 09 Jun 2022 10:50:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: evelynjecob47@gmail.com
Sender: dr.daouda.augustin198@gmail.com
Received: by 2002:a59:d66a:0:b0:2ca:36ed:79d9 with HTTP; Thu, 9 Jun 2022
 10:50:59 -0700 (PDT)
From:   Evelyn Jacob <evelynjecob47@gmail.com>
Date:   Thu, 9 Jun 2022 10:50:59 -0700
X-Google-Sender-Auth: ag0JUXjlVljz4GIX5GNCMD3qqg8
Message-ID: <CAMyj+W4Jmix+MU-r-R0T_Zm1ja2GaZnh_7Jh47WZspgR-Pa6SQ@mail.gmail.com>
Subject: Ms.Evelyn
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FORM_SHORT,MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2a listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9090]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dr.daouda.augustin198[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dr.daouda.augustin198[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [evelynjecob47[at]gmail.com]
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  1.6 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings dearest

I'm a 75 year old woman. I was born an orphan and GOD blessed me
abundantly with riches but no children nor husband which makes me an
unhappy woman. Now I am affected with cancer of the lung and breast
with a partial stroke which has affected my speech. I can no longer
talk well. and half of my body is paralyzed, I sent this email to you
with the help of my private female nurse.

My condition is really deteriorating day by day and it is really
giving me lots to think about.  This has prompted my decision to
donate all I have for charity; I have made numerous donations all over
the world. After going through your profile, I decided to make my last
donation of Ten Million Five Hundred Thousand United Kingdom Pounds
(UK=C2=A310.500, 000, 00) to you as my investment manager. I want you to
build an Orphanage Home With my name (  Ms.Evelyn Jacob) in your
country.

If you are willing and able to do this task for the sake of humanity
then send me below information for more details to receive the funds.

1. Name...................................................

2. Phone number...............................

3. Address.............................................

4. Country of Origin and residence

 Ms.Evelyn Jecob  ,
