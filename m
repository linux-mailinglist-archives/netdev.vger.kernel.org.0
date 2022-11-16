Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DAC62CADD
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiKPUah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiKPUaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:30:35 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4610CA1A8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:30:35 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id n205so19892151oib.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=69qjUwWQYDX9p0zcuj2Fxwz12731Z3plJQ1MfTbPk8k=;
        b=F4iLYXmw+QWwVuK8t3QqJXrsoj9f8asacrd1QV5tVWU7s3GcN0N6kLWxng5VBKWFKL
         juZbd/tfQN3F+ayQseWNxpQk3XrthgEsLFc+xt349OttPdXD+e7hIJnWO+RCPZ7y/Bw+
         LWw/0FsnGbAX5MmMtoW8RkD+j5dibIoBFQm8Qt9h6uJugmcBu6KjzhOoFXGZOibjNyAQ
         TeejDwn48GC7jG00bHmnKEBpDWCM7rompxenOsRbRoJT/5hVo+bMqY4siNQfyNU0/srs
         LLfih6ryViNdIf6bxVPvmRW9APsoflFYMaNFpXbAc9Gvps1Dr5zgnQ4W+RhtL58ehwXi
         WwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=69qjUwWQYDX9p0zcuj2Fxwz12731Z3plJQ1MfTbPk8k=;
        b=gWPo6nyjMSHEdGh0h0hmr/FpGYb11cMpnAzVZkdXxUa3FU599DrN2goOvdjYK+Dqc+
         /ehe8QVsgH20rB7bnzK8fSqTpYLCiQpsblka6jOT2bEn+RLapgKSuwTxQqgsQKS1o7Xv
         1dmQolKyLYeJBF7y5DRdd1iR+DjgsVIt7cx5Ag9feD5WDWWPj/+gRzwx/HILEsimrCey
         FI2ms8IvC64xgT+DDp7PfqDKp6HHxj3klPKkaaaL+iKiQrAvQdRs7AZngVEdxmJH2apZ
         Ic2YjOB7MGycAVhb06TtfYnhdvN8j4VswWYJiwzJL6AmXTCMfK7lAQgfgqPepAHonzqx
         FpLw==
X-Gm-Message-State: ANoB5pnnVIbJVN/hLGzJKnkVug4d12bsQZY9NKdA8prI/PchZ6GeNOkx
        vHjZ3V77izEq8SoP+76zw42IHrnLy7ZF2gCwJmk=
X-Google-Smtp-Source: AA0mqf76Q2qZ82kJFbU/VhFatpNGvC+8crgghICvlQXV04dVNWkjGkzhm86XTpsPxIYfPvxTEzmJRkdJuHA7YEOo76Q=
X-Received: by 2002:a54:4183:0:b0:35a:b46:c108 with SMTP id
 3-20020a544183000000b0035a0b46c108mr2496240oiy.184.1668630634578; Wed, 16 Nov
 2022 12:30:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:7c03:0:0:0:0 with HTTP; Wed, 16 Nov 2022 12:30:33
 -0800 (PST)
From:   maagrett zutass <zutassmaagrett@gmail.com>
Date:   Wed, 16 Nov 2022 22:30:33 +0200
Message-ID: <CAA3iQqvkDiJY6AH79ShfqUhf4yDg8tc+NMUauAH_0DzaqJpPSA@mail.gmail.com>
Subject: Royalty Investment Fund
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:241 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8785]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [zutassmaagrett[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  3.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 

Sir/Madam,
I have USD$15 Million royalty fund to be transfer  to you for
investment purposes. I am waiting urgently for your email reply .
Mrs Margret  Zuta .
email  margretzutaer01@mail.com
