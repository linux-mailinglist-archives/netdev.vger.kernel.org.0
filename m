Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE33E59A8A9
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242708AbiHSWj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiHSWj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:39:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D341ED8B31
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:39:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j1so633507pjg.5
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=md9K2pBWUU0U53uJPBwJHkai2HqvBufuwu1+G9IrGXc=;
        b=TMWgJiM3kBlf/4gKpzdAIksUzUrI6+opqd//mEdi0LeTcuaPhpAAJfLIzpGIKGkZei
         pdnUz/CaJu3IVQ2fxK8fi7YAT+p/d3K5mxG63LisS9RgzdDiJJK96fIyFjdK1AyNHLvP
         2EyCU8CKDkleu6zojV0PXZ4hsyd5Bf/YwxfN9M51kqfDxcFPYaJW02cCF0wdXH5NrRwP
         Jm4n6lExaNFth/cQ2rPBbFaLf7nv0Wv/Ym4hy6AZ9+nyRsGwWzXrxYODsotCE4KYFyUF
         Bgobe0Rvd6OEMRqtnXuBGSqDCdhMZthiCoRaIVB4C/sJtY0F/G+gCerRg7xzbJkSNcSM
         3n2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=md9K2pBWUU0U53uJPBwJHkai2HqvBufuwu1+G9IrGXc=;
        b=4Obu4v+QCcCEAOf4TUtVaBhfXatRSVSjX4sIoaIv89HVgiupZA0Pfyzm94E9uE51tV
         8LM3VmAom7QvUtwiU9b+AOspXyVKdjg6umj9sX6YXFn47qpg3TdpPF9YfLb70w9wnzGp
         zxxJvNEG92/92dBkFiuoV3J//C/uoIPlq8kFKtGSP7chGeLT8nWx/q97FN5BUctjXd9z
         whqBHWItHXQjXf8HNa0cx5K6OuWWJZ8mQmxdwjIo/GHdgqjKO8ArjDOrj6iJtvVNcIXA
         uNRTc2nLcWflD0W7Mrpm6KxbeodZF/cha4YK9ZidCluSt/b+JDaE62pS0HLpERXG4QNL
         3igw==
X-Gm-Message-State: ACgBeo16xFewe5WnVDwX9Xg+x1Ll4HD/aHaWFgyS6Gyx4OOFvQSI2xGl
        xcG2Ss0fNDuenyk/L3Fo6zE/bKaid4LDkOJGR3o=
X-Google-Smtp-Source: AA6agR7J93dwh0OKUmHyhGQLxmujj7XUbhdok64MF82MU8GWc4W5FrYPwUPvnnNOs1b3HMGz84mM21XFMYRNoZ180q4=
X-Received: by 2002:a17:90b:3a86:b0:1f7:2103:a8c5 with SMTP id
 om6-20020a17090b3a8600b001f72103a8c5mr10694372pjb.64.1660948767415; Fri, 19
 Aug 2022 15:39:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:6403:b0:72:81b0:974 with HTTP; Fri, 19 Aug 2022
 15:39:26 -0700 (PDT)
Reply-To: mariaelisabethschaeffler020@gmail.com
From:   Maria Elisabeth schaffler <stephaneicher114@gmail.com>
Date:   Fri, 19 Aug 2022 15:39:26 -0700
Message-ID: <CABbYi-Xq=dfOE5uMbBmmhnFVNyx4eeuxsNhZ8v_bbn+bbeS4UQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,BODY_SINGLE_WORD,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1042 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5082]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [stephaneicher114[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [stephaneicher114[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mariaelisabethschaeffler020[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.1 BODY_SINGLE_WORD Message body is only one word (no spaces)
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQrmiJHmnInkuIDku7bmgKXkuovopoHlkozkvaDllYbph4/vvIzov5nlvojmnInnlKjjgILm
iJHpgZPmrYkNCueUseS6jue0p+aApe+8jOS9huaCqOiDveWQpuWwveW/q+WbnuWkjeOAgg0KDQpt
YXJpYWVsaXNhYmV0aHNjaGFlZmZsZXIwMjBAZ21haWwuY29tDQo=
