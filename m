Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C909A573781
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiGMNfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiGMNfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:35:16 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042982317B
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 06:35:13 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id bh13so10455367pgb.4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 06:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mO/rKYKB8TZovbO5cQAqIciRv98bFTuqiwjEZXYoHPU=;
        b=KchpYOFvtzbyOsBw3TDynpA5+Ae6NEoGLkfeTZnf6CTptfuKQGSY/fwy0caRSm1b1R
         CndRFkErQVPF9IgVDLZK86sg2I27pBQoDi8we+C0+Nm+RoTVcHrWN3/M7IU0o50AhOJ2
         EO86GOOxiHEbBSAbk15aP3gq2wboZPpLU5Q0gVcSSX2FLXluoIxN6J4Q8w6d/gDXRPJt
         nw1LoAdQw0Qw20NfPlO8DctaBNISg6cfZWFdxPsPCVMNbU+zjba+gzsnqPCwU577qZoc
         h22sbOzhv/jURQ49AtnpSBC/cR/0cq5tuY2puK8ymOFvMF6bZzs4nkeV/czcyMK4OGcw
         SXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mO/rKYKB8TZovbO5cQAqIciRv98bFTuqiwjEZXYoHPU=;
        b=cX/AaHxuplOzxP04ofwyizsBr67WCYXwr8IoVfwOZ3WYeGCcd1QD8F3Yw7jvHyIyRh
         waBaMZftCahsodNoP/P5TnXJuEvZezPeBhleh+zQKJcMfo/lZ9jiYD6QuqXiyvhuFFIJ
         TPW0k/PxShouO/pQOiNJ9E85jWg7brufTeVNIlP7iqx/HD2mZKy+LXjLefNHaFv69Ibt
         3pUe7VOywoEyoPduwOX+duHQsh9SYQM9lF82C2dXJYC5W7hJD4SuTRqjKi5v94843+t2
         t8z3P6JdWmvuB2o8YfxxcIE/xXxW7dMeWTNzUBUCYQ2sY+70zCwwImUPdYIgH5Hfuu+L
         Hdew==
X-Gm-Message-State: AJIora/MtF+uSH7n0F83HZf8p1Dk380jlaR6XbPP7kQqinpwTqy3YP3Z
        7e4bWBZe5svsUdh1Cl5ISZ4qjlS4xVMQpiXGPA4=
X-Google-Smtp-Source: AGRyM1u5qb5h3PSzxlwZy9ESz+F28GImnYluMsB5YEZmRcOxuV4iMCGyZt8UjmDgTcDQCWZrS7bS3yoxPurmFPkv60A=
X-Received: by 2002:a63:f502:0:b0:415:ee58:b22b with SMTP id
 w2-20020a63f502000000b00415ee58b22bmr2897979pgh.349.1657719313339; Wed, 13
 Jul 2022 06:35:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:419a:b0:42:5721:a84b with HTTP; Wed, 13 Jul 2022
 06:35:12 -0700 (PDT)
Reply-To: lindacliford05@yahoo.com
From:   limda clifford <limdaclifford65@gmail.com>
Date:   Wed, 13 Jul 2022 10:35:12 -0300
Message-ID: <CAGUtzAv54Q8insRQgWgrdoYGcJqcjJxE8+wTgjX-yYUywwm=Mw@mail.gmail.com>
Subject: WITH DUE RESPECT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:529 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [limdaclifford65[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lindacliford05[at]yahoo.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [limdaclifford65[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Good day dear love one my name is miss linda cliford  from cote
d'ivoire please i need your help for fund transffer if you  are
willing please get back to me  for  more information thanks and have a
good day,
Waitting to hear from you thamks,

your s Linda Clifford
Regards

--
