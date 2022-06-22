Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56555549F3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiFVMTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbiFVMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:19:36 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8CE2C66E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:19:35 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id d19so19112610lji.10
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Bh4tlOq8AxjyNxXRnP6sScwknIzQ1Gs4HzFQdFZ6MIM=;
        b=AyB/ssdlTldvtfKxyIL+dWUzX+4hjT2TLTEvOWNqHub5A7EotBpPAtgw227LRkTcFe
         9cB5YCbUM/ZA8A5Io+2Y2GLSNdFc3DLpEaZngkrlbZNm/wa0i581ylkmLZxDGHAiE20L
         jOa4BoE7Zi55ZsEM/HKSq3MIk/q96oNn8G8Xwlys3zEm8NNNc1L0t/ZKqM5UmyrQvBZg
         M104xY4O1m955k8pLg35YpfMlDCyefnzUfYyB99yELw+R/xy6ZgdjQ7Cdzc0aS7HodzJ
         0kpiNlT/gStGFkFtUyOkFuuvfTjb8Oa24MIQRdb0pCaEkZW76Y2qmlmwrj75+4f4rW1V
         bZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Bh4tlOq8AxjyNxXRnP6sScwknIzQ1Gs4HzFQdFZ6MIM=;
        b=hnIABU8tH47bV3QnbQ8tmH7MySLf2hm/6JWo+ZcgaGnD10Z9p5nD34GJtK01+xRItV
         ecAov0kK0fcHo7DrdwrEhMmN4o8zWUQ8kkvvpyks+CDUz5vfZ9AABp/BfTn6Ci+TsayB
         fVymTjP4nuj+WnWlwDY79Qt32M1BE7zzTNt78eX+dZTo9vZNOlRAp2jGtDann3m3ZBQ0
         Q5EUPEFnd6wTt7qER/E5JK7Em2t36P5DPn0BCuUCoZMZSb/FYtz3TIiDc3G0k2EtE3nL
         VtgWOsvUN90f/0fYhZSXQ+67XWz+OdKNoi+AcO0JY73t/Zb+uozhwx5cdmN8bodT0j7Z
         ECJA==
X-Gm-Message-State: AJIora9+nR3pqsDWDld8qAcPYH8/jbhE66js46BF+A4DMNzc9U2G6kKs
        cDQNdGI3FIthQXqfbGsF91/7sopEvQ6defPmnhA=
X-Google-Smtp-Source: AGRyM1vBzIlVve35KgbZGKUozSwpZwnFVmKLK8O+lqTR3C8PeKr6hSt9zDIqi1ZLSbc2AcqP9l3WsoGii6R2IsmvLqA=
X-Received: by 2002:a05:651c:54b:b0:25a:6336:eb6c with SMTP id
 q11-20020a05651c054b00b0025a6336eb6cmr1770015ljp.315.1655900374282; Wed, 22
 Jun 2022 05:19:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:2602:0:0:0:0 with HTTP; Wed, 22 Jun 2022 05:19:33
 -0700 (PDT)
Reply-To: douglaselix23@gmail.com
From:   "Mr. Douglas Felix" <legalrightschamber07@gmail.com>
Date:   Wed, 22 Jun 2022 12:19:33 +0000
Message-ID: <CALi75Op1YGPjLmNEEdQmmhysc2RiUmSgKxweoeFd8jOmvSFqLg@mail.gmail.com>
Subject: Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Barrister. Douglas Felix
