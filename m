Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158E16510BC
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiLSQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 11:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiLSQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 11:50:05 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198E812D39
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 08:49:56 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id b9so9744154ljr.5
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 08:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2FkPSQhkPmlUq1MiBIrc+wGX4ejTebMXeFCRl3j6q9c=;
        b=FJKx0XcBFb+1Kxx5RC/twnpX3Vc27Zl8GB9UQoR6qv1uxO2UiVc2ZA7DfAHo+p1CxH
         mchtLILoAZ7vNTh9oR1jOwAIzGV8OQF+S0HNbJuq7U+IEJPmiicF0K0E6EWmSUjYGA3O
         iT2IhkWIzOcjf5I6KJIMyI14HgP4RjBmNqNkK8r5lc/xjVPYTvG0vXFzWd7zy524qfUX
         uFK+DkTzARcILJDGt5t7RNFxQNh+B4YBnvCfYT2e4Zecele7EcNLdbiOpIPYEeNd94R7
         9jpKu0DF6h4MvtmeLqwG+veOsu7y47eoSgpb4VR0uz5NycnhfE6DA2R4uiNXKoXV8z6C
         CQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2FkPSQhkPmlUq1MiBIrc+wGX4ejTebMXeFCRl3j6q9c=;
        b=jY5LJ6Abzmv04oN7dTlI1k8AuvzTzDzgT1C0RGrZKeICzGjQftJm5NNU3HvU0TY9qs
         TEC8iHCAXY+CwQiYutiOV5yW7acY8VL4B13tcYIKuQIqAdhbOvgJ1l4szep6LYjEklwD
         jicVhkOpIV97ZWjddF4p0x7Nyw9oCRFf+TWvfe1b4RQ+jjtYRRqD4PBcOwbegehtGRo9
         n7kMUwgshWKnshHUVCrxrc202EzoMyAyKby2a0yZ8FacIos5qCxCRQMaDSz/cSKzdyRw
         xZUpVEI4rK5at6VUDXi/4dNw9coitLBHxhD/RzOH/49RjXyusfQ1yxnF5N6P6g63OMOn
         FHAA==
X-Gm-Message-State: AFqh2koNW1PKEKG9xTb/eIvanAUnhTf42kqv/qTN14kq4pH4dsUQH5x3
        M9PTxmpHkg1EneKipxfMI6VW7A8oQz/uBdNbAr0=
X-Google-Smtp-Source: AMrXdXsxXzBMKjRV9+sGyklb4On2B+RschSRvc0FIDFqxTnvS3Hy661youWapvEOZVvYi0dXOTYvXFbc4ih3yCwKfQY=
X-Received: by 2002:a2e:7318:0:b0:27f:1537:2ba9 with SMTP id
 o24-20020a2e7318000000b0027f15372ba9mr656957ljc.260.1671468594385; Mon, 19
 Dec 2022 08:49:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6520:44:b0:22e:c13a:89a3 with HTTP; Mon, 19 Dec 2022
 08:49:53 -0800 (PST)
Reply-To: canyeu298@gmail.com
From:   Can yeu <towen8936@gmail.com>
Date:   Mon, 19 Dec 2022 17:49:53 +0100
Message-ID: <CAEgccdtMnMzE24fAHe164jrdhtTweACY+=DJhCAqkw2b=Ag0cQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQrYtdiv2YrZgiDYudiy2YrYstiMDQoNCtmE2K/ZiiDYsdiz2KfZhNipINmF2YfZhdipINij
2LHZitivINmF2YbYp9mC2LTYqtmH2Kcg2YXYudmDLg0KDQrYqtmC2KjZhNmI2Kcg2K7Yp9mE2LUg
2KfZhNiq2K3ZitipDQoNCtin2YTYs9mK2K/YqSBDYW4gWWV1DQo=
