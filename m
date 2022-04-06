Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B872D4F5BEE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349856AbiDFLBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349983AbiDFLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:00:20 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7867B52392A
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 00:25:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m12so2006857ljp.8
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 00:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=uM+FGcsj8toEe5e+GV8hGulxG9f/x9ohvcn77yjffaQ=;
        b=nyki1sfe5G+aAzOLpLnZhO2ZDkCF5ikqOx76aXsqKRkcVu8Rxqw+y+5/vta0UJfZZp
         pCk3c6ItnK3lG+zgUQrHULMddAPMuobruF3kg6Lw1oYvE0+QLZZf+HJWuNi7+aNIkXQF
         S74qC5hQezZ+AKP17/Jf/cqwMJL3xixxCQ/SEWkjY5bOPOf7KsNHewht0h9qdh0gk3oS
         r2tT5XcdOoYXaCCK/LQ4CHB7b1BG/M3ItIVOXgZ0w0mXfUXtxTKlK9AOWXkK1Ly9qEmL
         zc4sF12PfTP6tZRaoKPLkn4cShN40j5o2xyN7bVf7LuFgI1My+JRqQh8D32AT5PlFBvg
         QjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=uM+FGcsj8toEe5e+GV8hGulxG9f/x9ohvcn77yjffaQ=;
        b=7xxkp2U65ia6T9FEjLImWR7Z9SHJ9yaMpeQm08VgwhiHH5PoAF+e1ffqo2sMyaCfuf
         Nv99h5rT+JhVXdwDhLdNx/Hk1AcirO3TvCWkzckCr0wJIppjlgoqgUkq901ZODlbOp8i
         51A9UsY0buaISqd9lHkpIErcCF2lTLXMRq/LhlUqZsfdsW57KVUcrwQtLgVZMJSN4vKI
         KjqxrQT5me03ZxLnCthVi9PxGdK2X4SU25hkoNj/EUUltCGeS7GihS5KoT6T5X3g/2ao
         uBSsHYTZ7+OvZdpk4FWSbVshEmW6t+iDJlguHPTJzNEnvmQIO0kT2jMicempQvs45h65
         FpRA==
X-Gm-Message-State: AOAM531ze6QYZ+ra0hFr5Y7452AyAfTpSmQEdK4z7MefBdy+al9ypAqz
        2FYymd4kxrOIpLjdvXZ8JQdau4J2J5C4cIgnh+M=
X-Google-Smtp-Source: ABdhPJyXd4x1EY152aytJrGrrH9LsxGHjouD2bajhKDiATPjHXWw+BbzbF//Bs5880gAhmoyFqGCmtNR6sQYozaWevw=
X-Received: by 2002:a2e:a28d:0:b0:247:dce8:cecd with SMTP id
 k13-20020a2ea28d000000b00247dce8cecdmr4419866lja.415.1649229942372; Wed, 06
 Apr 2022 00:25:42 -0700 (PDT)
MIME-Version: 1.0
Sender: rolandcarson343@gmail.com
Received: by 2002:a05:6520:3423:b0:1aa:e3a5:b818 with HTTP; Wed, 6 Apr 2022
 00:25:41 -0700 (PDT)
From:   "Mr. Jimmy Moore" <jimmymoore265@gmail.com>
Date:   Wed, 6 Apr 2022 08:25:41 +0100
X-Google-Sender-Auth: 5ncwtOZdi-NdrDSLQxLdkgVs-pQ
Message-ID: <CAKa+mTuKGiersDqoUDQCNeBBfPpLBVmMqTQiYGo7Cd8m5T_9hA@mail.gmail.com>
Subject: COMPENSATION.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,LOTTO_DEPT,MILLION_USD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:243 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6841]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jimmymoore265[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rolandcarson343[at]gmail.com]
        *  0.5 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.7 LOTTO_DEPT Claims Department
        *  3.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UNITED NATIONS COVID-19 OVERDUE COMPENSATION UNIT.
REFERENCE PAYMENT CODE: 8525595
BAILOUT AMOUNT:$10.5 MILLION USD
ADDRESS: NEW YORK, NY 10017, UNITED STATES

Dear award recipient, Covid-19 Compensation funds.

You are receiving this correspondence because we have finally reached
a consensus with UN, IRS and IMF that your total fund worth $10.5
Million Dollars of Covid-19 Compensation payment shall be delivered to
your nominated mode of receipt, and you are expected to pay the sum of
$12,000 for levies owed to authorities after receiving your funds.

You have a grace period of 2 weeks to pay the $12,000 levy after you
have receive your Covid-19 Compensation total sum of $10.5 Million. We
shall proceed with the payment of your bailout grant only if you agree
to the terms and conditions stated.

Contact Dr. Mustafa Ali for more information by email on:(
mustafa.ali@rahroco.com ) Your consent in this regard would be highly
appreciated.

Regards,
Mr. Jimmy Moore.
Undersecretary General United Nations
Office of Internal Oversight-UNIOS
UN making the world a better place
http://www.un.org/sg/
