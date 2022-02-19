Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F5E4BC84B
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 12:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiBSLsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 06:48:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiBSLsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 06:48:41 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE06E1E549C
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 03:48:22 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id w63so3290418ybe.10
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 03:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=C3Ganb7mzGkesp2qM5finmqUl+DcP/JuUu5/dznXtFQ=;
        b=Rk0+SADvKXjJyDTh92Nup9qU3OKApWlXvnlPa7Cld44c7MJEkbzekXgklV9HsowTEC
         OAcbL+fvcDuXeYKBTRdyy/zadiXdJulnlQWnxCvyBS6Ke6EdDiY2jmenEi5isKMGDGaL
         FpBuvTuV4oV7pya9aJNh3SV6ipf6SrzPlVANgrCkFBK8tWiuUy6DNu5KaoRHEDAbbUgr
         kTc60sTwP0GMhxe7c6ux2dxdlfhR3wIknBpkkCy1/5mfpfWagKc5CJhaZUXm6OmRP/FA
         TrmSZ8FHl733e0re46pPUJzrf1olB94PBCt97+xWy5vzXbxhOyHfey+rCt6rLoeDrfFE
         UNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=C3Ganb7mzGkesp2qM5finmqUl+DcP/JuUu5/dznXtFQ=;
        b=XyLM9gDTo91CWoKZycjsS8c+F+mDtozWzdLnn0Eb/w04CDrVpPJjjZ0Z/1vtFXzWuV
         ip5adg5bouBkUaoo1pTUQTm7och3c7FYw9MKrvG1QDv+FTU0drT6gPTTFRTiDuLmrTWV
         cy5uM/VDKj7Ys9/oR99qrb4aE2PXGZDk8sD2rbP3edTuCE7cFytaJskUabg8xN6DToF7
         P6Z5eKUlh+c255NS/LfOxITsp/z9ixUf/ICmVtW3M5sLyptmyWqBK9zOSMc76Fq5tb6q
         Fo5YTUXcWVXPNvb/8cQj5CtMi+Oqh43BdyPiM2rumclD7qGPxo0Zon4q6VU1MLNKeTxS
         PuSg==
X-Gm-Message-State: AOAM532jgSakYovETn1434f9OG63rNNHdzaF3aQN5R5z3RnH23uAOeIY
        edSi2kdLy1i/64JrrRSH0jlwPOihO6JDe4WtlZo=
X-Google-Smtp-Source: ABdhPJwqL0XgMB8tWkOLw/3Nf9QXGcUcPDtswsny5nk3byPHzMrTU6CpEB7FUhj8cN8RiFtkk6Vg837ySbQXHDaYjbI=
X-Received: by 2002:a25:e08f:0:b0:61d:c0f3:7822 with SMTP id
 x137-20020a25e08f000000b0061dc0f37822mr11283812ybg.101.1645271302058; Sat, 19
 Feb 2022 03:48:22 -0800 (PST)
MIME-Version: 1.0
Sender: ifeanyiomaka1@gmail.com
Received: by 2002:a05:7010:1786:b0:210:9d05:b5c2 with HTTP; Sat, 19 Feb 2022
 03:48:21 -0800 (PST)
From:   Aisha Al-Qaddafi <aishagaddafi1894@gmail.com>
Date:   Sat, 19 Feb 2022 11:48:21 +0000
X-Google-Sender-Auth: xIydXBUxtcSMvQ5RFd0rmwhy42U
Message-ID: <CAO-KV1-K2=pcXLcwLK0+1bBXOk1h=tP1_6802Z+Wd2b_1Jr+Bg@mail.gmail.com>
Subject: Investment proposal,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5051]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ifeanyiomaka1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ifeanyiomaka1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear Friend,

With due respect to your person and much sincerity of purpose I wish
to write to you today for our mutual benefit in this investment
transaction..
I'm Mrs. Aisha Al-Gaddafi, presently residing herein Oman the
Southeastern coast of the Arabian Peninsula in Western Asia, I'm a
single Mother and a widow with three Children. I am the only
biological Daughter of the late Libyan President (Late Colonel.
Muammar Gaddafi). I have an investment funds worth Twenty Seven
Million Five Hundred Thousand United State Dollars ($27.500.000.00 )
and i need an investment Manager/Partner and because of my Asylum
Status I will authorize you the ownership of the investment funds,
However, I am interested in you for investment project assistance in
your country, may be from there,. we can build a business relationship
in the nearest future..

I am willing to negotiate an investment/business profit sharing ratio
with you based on the future investment earning profits. If you are
willing to handle this project kindly reply urgently to enable me to
provide you more information about the investment funds..

Your urgent reply will be appreciated if only you are interested in
this investment project.
Best Regards
Mrs. Aisha Al-Gaddafi.
