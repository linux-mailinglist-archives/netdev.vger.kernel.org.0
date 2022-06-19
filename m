Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD0550A5D
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 13:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiFSLtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 07:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiFSLtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 07:49:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD77411C32
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 04:49:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id me5so16284393ejb.2
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 04:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=cPIBgpwOnmButavmlwJuuG1NWqAGhAI3+3vxmohoLXY=;
        b=KKqBWmzdzP/XBbBQwwR0VFkmX40EQu7IMOYfsfHhBjsi1mEvQGGyncuJRaxnXoEwDZ
         Cx8FNiRPHo8FWXknUYMrqVwLaAG6/kF95Jr5ygA7BaSElwuQxp3b7OQd77k0rH6qZjh/
         912Skrqr/aCVOTwwkJDdtN2dzLbZSEcfwUUv2BxnxJuIX7qLYgL/TFPN8Ik2JF9UJriF
         V3fhblcUzEDWmfUDsIJQQ8VbnmubRzr3iRXbHjKx5aq/Z7yXEqfk3cNpLHTX5Q5tsvZl
         0teq9I/+pbDj/GdpY2GPiwY5xJU8UAtVYA6aBwURTgN76KKHvZRsdCVGlRvePX6T6JP5
         Qmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=cPIBgpwOnmButavmlwJuuG1NWqAGhAI3+3vxmohoLXY=;
        b=W2mVmDQDFJ4K8nZKRaeE9mYulKuC4vj13t4HV9mpjgMxSv4rVHnE+0RyA6Cu7+yYPE
         rGyDwxOCLMDI/rIKimDsXKai3ZP/gdpxLeTrUyDLxt073uIXUTQdLKD6Vl4pPROX7U66
         BX2RuP46hUgEh+Wg1IkhIDux9g647E9KVdRVh2cckzSaT75W7ucugPChySevDl9gkhta
         SKtKHda4nMJ2hhoYoKtA7OvDQlsFRyQy2edEvIlLeUUVCPG0SYEyUEz3VyHsGHmjOokK
         uUxeiRfAQV/ZmiW0VQ8SiUrczm00IJbtVlWMYcQODAkzq83GaFEhkxwacrg5z/njWeum
         Iw+w==
X-Gm-Message-State: AJIora+waaYAjsgm4tc7lFKlc/AYPwYg4mMhKzwhAZAJuw3EWzzYQV3C
        ncZ0G5TSg51qVw8Is3PI3KbeWZ+JDoehFQnYsN4=
X-Google-Smtp-Source: AGRyM1tSR9xYFsF+7rmnU+xoOq9/7aUGGYxwwKTdSNf/q15huCRlo1HdCXncogEW3HxCPs4duCUfRu5o75PKHXYohGs=
X-Received: by 2002:a17:906:221b:b0:708:a007:5a77 with SMTP id
 s27-20020a170906221b00b00708a0075a77mr16939595ejs.566.1655639371297; Sun, 19
 Jun 2022 04:49:31 -0700 (PDT)
MIME-Version: 1.0
Sender: djmacdon5@gmail.com
Received: by 2002:a54:3347:0:0:0:0:0 with HTTP; Sun, 19 Jun 2022 04:49:30
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Sun, 19 Jun 2022 11:49:30 +0000
X-Google-Sender-Auth: aUlmViKOvChtxZSk2Qf_HIHadjg
Message-ID: <CAKGPEqh3yn3Lggy1AM6XuxrP-GDXa7FWpV9HxLpFejbf+mGAHQ@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5364]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [djmacdon5[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dinamckenna1894[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.6 URG_BIZ Contains urgent matter
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello My Dear,

 I am sending the same message to you. My names are Mrs. Dina Mckenna
Howley, a widow diagnosed with brain tumor disease which has gotten to
a very bad stage, Please I want you to understand the most important
reason why I am contacting you through this medium is because I need
your sincerity and ability to carry out this transaction and fulfill
my final wish in implementing the charitable investment project in
your country as it requires absolute trust and devotion without any
failure, which i believe that you will not expose this to anyone or
betray this trust and confident that I am about to entrust on you for
the mutual benefit of the orphans and the less privilege. I have some
funds I inherited from my late husband, the sum of ($ 11,000,000.00)
deposited with the Bank. Having known my present health condition, I
decided to entrust this fund to you believing that you will utilize it
the way i am going to instruct herein.

It will be my pleasure to compensate you as my Investment
Manager/Partner with 35% percent of the total money for your effort in
handling the transaction, 5% percent for any expenses or processing
charges fee that will involve during this process while 60% of the
fund will be Invested into the charity project there in your country.
Therefore I am waiting for your prompt respond, if only you are
interested in this humanitarian project for further details of the
transaction and execution of this charitable project for the glory and
honor of God the merciful compassionate. Your urgent reply will be
appreciated.

God bless you.
Sincerely Sister in Christ Mrs. Dina Mckenna Howley.
