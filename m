Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE826E1F72
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjDNJkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjDNJkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:40:04 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60FD1BD0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:40:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50489c109f4so4926118a12.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681465202; x=1684057202;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09ttSX06oRnzdKuIS/gGoRYpeZHjJP0fBn470Dk7WKI=;
        b=LS8nMsN5zCHcTuGnYs15D8GtEVuS6/cl7i7AIg9CY99GV188l3IQvbGjjaefZK3WtH
         FmKCG0G70C03PpauhLwX/Rgn6t9vxMnK5QHiNmCchi7g/nQjszLNPZvdLib9lPlsYF24
         nbeFquKj16+9uD97Db7q8gDZNXaq1lcMe96amAIxLNdQ3B7zGktun83045bswYKYB06x
         2sGt8nSxN2ATisBT8zz3WAagWw6Rglt9Y8uTW+c/CRxLZ8bbY4vECKOdZ9ghD6h4mO/E
         KpKJ0NKys8pPLmo4JBo9d2ZeUq1ichQ9OSk0GmNWrJkFQYpEmnUcV56W6yQBEYmOHFvm
         IzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681465202; x=1684057202;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09ttSX06oRnzdKuIS/gGoRYpeZHjJP0fBn470Dk7WKI=;
        b=lOcx3Jcbcn/+JTIj/pDHOgxT45ytUgpwzEwD01DY+G0cELzChL2dsqxIR9MeKHQo5i
         cKPn2b1oxKdWGVz2OUZQXjxZyfJROn4RYleaVzQBKCZ/xoE02TDxFBYThIL+hTZL2ChB
         seTn/JfCTZEVo4MBYA0lkphYZqgC1Nv2TdREkYmjosObF0aLqdPwoL7X+auIElvynOta
         0BHeYsskRTheGDBAlZO59Z9hc9Fjb02MXNUadcTfBdjcEpJCSYnUsCIPG5Fre5IzVABB
         6W6swz1TTnLQPrxO9F0MmOKYgZeLsf/duV5x5TlOdpVoYhTr53ZLGv6sF8Ld+ck+UEhM
         qFJA==
X-Gm-Message-State: AAQBX9cYf71bsxELkxt0pr7HRztfop5fQoqeNwLFhEFO9t/ohWwUV3bM
        8Fs43CYrvCzr9iu16zGe7OrEmNqXEdctNDGUaV8=
X-Google-Smtp-Source: AKy350bb60xMB/ARfpl6Joxr3W1p2YlcTZK2DaWbqTer+wNXCWxAGGZqMbpqxEO+6gnhueZpcrrO0gdLKLra8D8hvs8=
X-Received: by 2002:a50:951c:0:b0:504:78b1:81b0 with SMTP id
 u28-20020a50951c000000b0050478b181b0mr2741808eda.5.1681465201954; Fri, 14 Apr
 2023 02:40:01 -0700 (PDT)
MIME-Version: 1.0
Sender: mrslila67haber@gmail.com
Received: by 2002:a05:6f02:c88e:b0:4a:bb48:dcaa with HTTP; Fri, 14 Apr 2023
 02:40:01 -0700 (PDT)
From:   "Mrs. Lenny Tatiana" <mrslenytati44@gmail.com>
Date:   Fri, 14 Apr 2023 11:40:01 +0200
X-Google-Sender-Auth: 4pn96Us44YP9TbxcQylZJfwgykE
Message-ID: <CADVoOvis4vovwBExiCXU06SGbVAdBhOVhiFsGswZVQj-cgXvkg@mail.gmail.com>
Subject: Greetings dear friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.6 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_00,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        RISK_FREE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52e listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrslenytati44[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.0 HK_SCAM No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 RISK_FREE No risk!
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings dear friend,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS
CHRIST the giver of every good thing. Good day and compliments of the
seasons, i know this letter will definitely come to you as a huge
surprise, but I implore you to take the time to go through it
carefully as the decision you make will go off a long way to determine
my future and continued existence. I am Mrs. Lenny Tatiana aging widow
of
57 years old suffering from long time illness.I have some funds I
inherited from my late husband, the sum of (19.2Million Dollars) and I
needed a very honest and God fearing who can withdraw this money then
use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR
CHARITY WORKS. I found your email address from the internet after
honest prayers to the LORD to bring me a helper and i decided to
contact you if you may be willing and interested to handle these trust
funds in good faith before anything happens to me.

I accept this decision because I do not have any child who will
inherit this money after I die. I want your urgent reply to me so that
I will give you the deposit receipt which the SECURITY COMPANY issued
to me as next of kin for immediate transfer of the money to your
account in your country, to start the good work of God, I want you to
use the 25/percent of the total amount to help yourself in doing the
project. I am desperately in keen need of assistance and I have
summoned up courage to contact you for this task, you must not fail me
and the millions of the poor people in our todays WORLD. This is no
stolen money and there are no dangers involved,100% RISK FREE with
full legal proof. Please if you would be able to use the funds for the
Charity works kindly let me know immediately.I will appreciate your
utmost confidentiality and trust in this matter to accomplish my heart
desire, as I don't want anything that will jeopardize my last wish.

Please kindly respond quickly for further details.

Warmest Regards,
Mrs. Lenny Tatiana
