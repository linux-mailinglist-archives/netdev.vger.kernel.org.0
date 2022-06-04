Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6B53D6A3
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbiFDMBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiFDMBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:01:03 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C490954027
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 05:00:59 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id r8so10507923ljp.1
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 05:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=MeNHKCbc/XVwe161xH1MhP1HhpnsPYGeIRS9Pmc8tLI=;
        b=KG/g3yjGCxVvh0FnNjY8twtNquxzdkz4HP7WuT79MDpIqv/YfGFwO1jMo1urgk9D02
         Be+o9+9K5SyrL9Yv2z3icuRGNdIlW4hnwbOt7gIvOgGoPTuGPdhoMd4OWUmQfg0plaAu
         ZdAOX/YL2OfnSB45RemrpJCF8Xke3fyett367QHNQA5rCfOElUc+n1bCxoMthACAXHU3
         X1RT/7pexOR3w4D2W8EfnnswN0E/SsZuG/La/Q/LCwQCcWXvWLS71YXTIno/Slyke0qg
         F20JLnkoxwm2bcR7aHP1y47QyTYRpVj2kutAkh0lMF69N3JstXG3i1fr2/gMFIaM8KFV
         nesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=MeNHKCbc/XVwe161xH1MhP1HhpnsPYGeIRS9Pmc8tLI=;
        b=B9/459qdrpZCCT7PEeg699nRDAC0ys2U+DoxfHsp/dk4mdjfZsg/dB4Ny1M6Sm/OP3
         6JsexvLkUfvHhKr1gZ5rMk/FOPyX1Q/SMMDz95bTrNCqrDhBppkfnIE67GECX6m3bc0a
         F09TDVPwVKVXFT/wkSVlATuD237/aRUwvYgKfS5wpOUTxZT35p/HmgAYugLYjBs2dw3X
         DcAX7neu5/VlIRnN2ON+Hs1n0VtktpxZTZyrHloaWh5tVUEyLXvKW64FlQTwG04aEV42
         zGYOKPRZsfXgNVJHY990+Cze59y8daO1uyQPxpz7PHEHLJStakARghIH/xuOGP7Y6MWf
         ykgA==
X-Gm-Message-State: AOAM533w4z92yuVry5i1x1T8aWEib9gCkaJ6qw/KSnicwC9cnnmMCiQV
        /xDVvFw0fbavJcoCMoYWCzHYAQvzcddwzRQzLX8=
X-Google-Smtp-Source: ABdhPJyhxxREd0IR0P8/lWvSJb0PibRsPjwHEg2vcFUgF8TwX1DsPMsfNBDhYKWvQlCRH52eg/X9qXLnGgEQuUBV3Sg=
X-Received: by 2002:a2e:9048:0:b0:255:758b:449b with SMTP id
 n8-20020a2e9048000000b00255758b449bmr6828816ljg.123.1654344057866; Sat, 04
 Jun 2022 05:00:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac2:4e0e:0:0:0:0:0 with HTTP; Sat, 4 Jun 2022 05:00:57 -0700 (PDT)
Reply-To: danielsmithinvestment01@hotmail.com
From:   Daniel Smith <aw3483888@gmail.com>
Date:   Sat, 4 Jun 2022 05:00:57 -0700
Message-ID: <CADekC5MD+KQy95s_bweEUdL4i-XkCMJzSGZ3bAHArbxTUZT7cw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Apply for a loan.
