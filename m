Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49281637F5C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiKXTDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXTDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:03:32 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C2DC80EB
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:03:31 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id a15so2895169ljb.7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EqiMl38yZuy4DIKudhI8tvd+HR4KIizi5rBPyUoKAMo=;
        b=IJYZwWiGGihmzjqp9+EtN5kqB7RPHBNAHlQXH4sFdBY6hqF7buwovzSuUh9O18u/Ov
         zdBrA7J7XrF18o0P073xWYDrg2CqmVdh5bRBNxDUvFiD28v4HhfkVvjKookQ6vPaOCIA
         p8SKexrlKkCDsOeE4UZ95ISI0l5VMrP5AgXLELmEOgQh4soMW7jidvI2OvWNjiXNTHOA
         cq76RFFKXWOfwUY1uFQKAPT4qnmCPm/jILsqskVDYGsLpXfAfdwBhzgjHqVl6A0fF6d4
         PpKK6mc7x4Dvyzwn84O8XvUQHNysDVcGekKuQCmw3fmSvq1V9uEpkH/1k/mB9RoUuVMd
         yvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EqiMl38yZuy4DIKudhI8tvd+HR4KIizi5rBPyUoKAMo=;
        b=nhe/8HCaJHJu//Ix9lZIADg8aAvQL8E0KfULMIYkAdGXHLo4snj15fk+psiMaN0+wT
         ogiNfIPSYaIvHa3QziewwC9JuWpCDIK6gFCnWHuax3gW2YAtWzqw+87fnLoiMmC92nia
         wJmXlD4nfHxsasVqmKmFDqD1FuPhsZA7a6moiQRCBrxsa0xcLbfUSvU9A6xaFW525Qgm
         t6Jnrh+nmjmhMOUF1vf6m7h16g2lWjQm9Ec+pJ4LywQjXUEWZAcdjC7nCrOOZIMq/Jnk
         0+Fn/e8jqRh18skfh/DPwQK9oFM5jRt2BmAot+XYAbyFFCTG/iB7xPHfXQrCcJGF+rSt
         TJ9A==
X-Gm-Message-State: ANoB5pnLkHV9POtVab9YMcr1utZd8grmjpZyJWoqh00lIs3xrgrORm+i
        /RgQeeenSCgv2OIs9o5wcebmIVoSgIIrQSTPHFU/JZDnTvI=
X-Google-Smtp-Source: AA0mqf4TqM/6FxEnEkkGkv+huDUQdQke7Q9mGJQnYGiulzF74ygjZnDqtQKrylpvBw00t64kEioCbkFx7QtcHtG8bDY=
X-Received: by 2002:a05:651c:988:b0:279:7ab3:8738 with SMTP id
 b8-20020a05651c098800b002797ab38738mr3111555ljq.232.1669316609626; Thu, 24
 Nov 2022 11:03:29 -0800 (PST)
MIME-Version: 1.0
From:   Ioannis Barkas <jnyb.de@gmail.com>
Date:   Fri, 25 Nov 2022 21:02:19 +0200
Message-ID: <CADUzMVY-BVTO3S0jXiNpDLmkhJahFwppeJvT8yspFtpA8QAH3w@mail.gmail.com>
Subject: Re: BCM4401 LAN
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

thank you for your replies. Now I understand what happens. It is an
old chip having a hw limit though it was used on a 64-bit machine
having much more memory than the LAN IC limit. As you said, it worked
fine without any issue.

Take care!
