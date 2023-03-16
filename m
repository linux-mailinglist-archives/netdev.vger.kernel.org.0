Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA26BC680
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCPHIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCPHIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:08:40 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8518AA254
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:08:32 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id i22so527239uat.8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678950511;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNFhsPbkfGfOWNF5M4aRb8nwKD8L5aVj2WV/H46NM8s=;
        b=eVxQom+r48xFY9tIdlF+XkFt7282kbfgiBodu/V25Qd0qVDA3tJbnwTSrjDwOxTJDK
         hxrnZumTsl4glO4Lu2SHyANgorjDFyOqQ0mFK676iBmEdUnCm/QV80VCR4b+zUVMr0LR
         K6sp8A+MwPV94SknD4ErmWbfzorwYw2uhK+F4vltfb0j5BCkF1FcwO4fheuauVRIdpef
         8fWhPKe48uwVp45MzI22daxiMUAjGtA33C+EeBZUJLoWBibxG92rnxn2Sr+Lr33ZUD+c
         iHPZ/8RvnhJsrrk9SDydt2tISqZrq1vZiCmkvzuphQkV0+zHtKspuEr8n2SrbTZZrtDy
         lDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678950512;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DNFhsPbkfGfOWNF5M4aRb8nwKD8L5aVj2WV/H46NM8s=;
        b=W0Hgo0ClUDo6eI3+XMke7otQXfSwphBLQfueIJyjW95TZPkUcnsF4zNSqzMabR8hI3
         n/CIuFGDtLxVb4LLAQ+O3ExO2E5s+hcwmE4uQo0P+9EiZy6quspnJCfJMNSaCCUi52+/
         hAkCAbZLYL7yx+qSBYO4ntJBHkc9T1R7CbaNADv6fyKAc8L4p0W1gVQ9oZ2JwzalGXPN
         zWvJ3EFFPoFxHmV6tSDf0O6Dz+9CbiovmlvcqjtQ4cMngfmtAVGdD94RnA21LUWjItoK
         ZPaJoq8UrrWaQoYk4URcd/1L0FZ20Cewj6Vv5/GMiIW6E8kGcaNv0b5bsYZEDpQaT9mM
         Ad1w==
X-Gm-Message-State: AO0yUKX4AY9zPWSY4xpKAuCzgRf6nbEGv2loV9pWDqad5MsUa76GIXoj
        eh//nnSmu2O/Nf6tSPnz9cx4VzKLzI8+ICqse48=
X-Google-Smtp-Source: AK7set/08qupiTSZRxHgyBZIgzqM8hyOqzzliOAx+rHUMKaKpUZAof04aTuooVrzF22tNYAUccdVwKwJ70xvxscTf38=
X-Received: by 2002:a1f:9ecb:0:b0:432:6a3c:d1bb with SMTP id
 h194-20020a1f9ecb000000b004326a3cd1bbmr2558388vke.2.1678950511671; Thu, 16
 Mar 2023 00:08:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:a847:0:b0:3aa:d23b:8f3f with HTTP; Thu, 16 Mar 2023
 00:08:31 -0700 (PDT)
Reply-To: dorismartins807@gmail.com
From:   Mrs Doris Martins <sdo185325@gmail.com>
Date:   Wed, 15 Mar 2023 23:08:31 -0800
Message-ID: <CAKum-LtHmfaO6fvMDnYGB9ew0cb5zRH5XzZDOEj0fA=v0Qbkgw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:92d listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7103]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sdo185325[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdo185325[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dorismartins807[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I wonder why you continue neglecting my emails. Please, acknowledge
the receipt of this message in reference to the subject above as I
intend to send to you the details of the mail. Sometimes, try to check
your spam box because most of these correspondences fall out sometimes
in SPAM folder.

Best regards,
