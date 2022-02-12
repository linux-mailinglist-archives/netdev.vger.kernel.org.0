Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642894B3406
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 10:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiBLJZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 04:25:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiBLJZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 04:25:56 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5492656A
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:25:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id a39so19601195pfx.7
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=LBn5pi2zD8C70+tSeo5aaWi3cZGhC+Mz/l9bCxEu6Vw=;
        b=pIX7io/yePkmWF4a8VRyuboRSUJgmkPfS4IKedprtAep3MOEMCBM8GmyrZsH4mySwa
         6XSsw/u3zbvOoRxW4kAnbzZ63RoFIBugxvy9WDK3WHogS+wyRoo028vReEBEs76iZErZ
         U3cd/msigzLRxxJMMcU6gx90fYthIr9jkwWPE2YAEbmVpF+pWxbh/BQzjgsN6DcKTxxW
         PSazM1P5fxUC01Ek2IHrgXQVFxsyR2mf3LyYh8bYFRoce2cczoNkwTJ9zW2vq9/CmGkX
         TcOKKxSBjR3aXbP465T3iqslpy4HnL1rnSVnNiMLBrRUCD7JgjrRL5d6AVUDhbtbJWfI
         JRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=LBn5pi2zD8C70+tSeo5aaWi3cZGhC+Mz/l9bCxEu6Vw=;
        b=NMGERLgb1871AUr1raVXdIXk4rcwGCtXthZVA3e5ALIFs+xShp0ZTRdiKx7WkOJ0H5
         yN60dlnxgM+KK0KFyeSuRd6vRZRRjNzUy2CQ1WsonuL8w/3WpxTNOR84AnZoeJHUV+fM
         Tde9jCLnIRE+W+uoj9330v5H548Pn/xloMSquIE9PgVW+pC1GN/97toEVrA4JpXVO7Wt
         fTCx/r0g61SqWy0DSyv48Gqhvxcqkn+HIFYyu15RGfIspzfx4JEtW2bXXKZb0wQjb26N
         qerc/QXaMx+XCABGCTJmnlwog9sqcMtrn/tX8iPnbpjldjk60tX4s5VrAdhD6M6tM6zB
         h49w==
X-Gm-Message-State: AOAM530sUSyA1LkYNVZwRxovNS4QKqktavkjJjJ0zQNlPtiedDpsBGAX
        QdTbUdm7Yxk2riPRSfvpGe+6f9JJ5yKS+XKATIY=
X-Google-Smtp-Source: ABdhPJwqOvdzoCm8M9elQgAmmmq9gyR88bEiTMxYRdJ++wcFEae+X3tPE3qV3L2Qd8aKVbh8ZuQ80b1+Y+lOpDZLnvA=
X-Received: by 2002:a05:6a00:174d:: with SMTP id j13mr5314624pfc.58.1644657953224;
 Sat, 12 Feb 2022 01:25:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:9202:0:0:0:0 with HTTP; Sat, 12 Feb 2022 01:25:52
 -0800 (PST)
Reply-To: m223443d@gmail.com
From:   mr michael <cm09362@gmail.com>
Date:   Sat, 12 Feb 2022 09:25:52 +0000
Message-ID: <CAL1HOXDNo_rMif0M671=mKOYMS-riq1hsZ6Wk++35VNs5j3MaQ@mail.gmail.com>
Subject: I need your cooperation.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:434 listed in]
        [list.dnswl.org]
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1155]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [cm09362[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cm09362[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

With due respect to your person, I make this contact with you as I
believe that you can be of great assistance to me. I need your
cooperation in transferring the sum of $11.3million to your private
account where this money can be shared between us. The money has been
here in our bank lying dormant for years without anybody coming for
the claim.

By indicating your interest, I will send you the full details on how
the business will be executed.

Kind regards,
Mr. Michael Doku.
