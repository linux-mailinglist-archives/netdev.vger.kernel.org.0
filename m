Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD31B5B9B44
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 14:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIOMrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 08:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiIOMrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 08:47:08 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D850C5A880
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 05:47:06 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id m130so2059994oif.6
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 05:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=beB8LSzEsaNR2CbcQc81rNfenwmrBfiEq78JjolS3qY=;
        b=HeLkuDhCh2ab7xIUnoVYq5SWV1kj7EOQj/DMwk6m83PD4FKQm+HsTuIYUajD+0UmNQ
         ocwVtG7Blzs76dbFqYgSgCTKr7ZDLuBwVQfZwPJGgkfISDlWwDm4DmdpgHXJB3M481DT
         O7tBWGZZD+4scgQnmmVWkyffqRNctyXNXkbDBp9fEXzxyR/YE2/u+IVYs7MMvL+xo1BG
         u+4e+QUFS1TUID/X1gO2/qIHVRdf/tVBiqJZNJdWy0CyB1PVBn+cFdDSht8P8pUpJaVO
         Tkr3Og/izmRot7DEPej63stndp5EvF6BVKbJ3t0GhG7i8i0atECAANmitXfqnQnFFneX
         3/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=beB8LSzEsaNR2CbcQc81rNfenwmrBfiEq78JjolS3qY=;
        b=6xMLnzc3dJGtaY8AdU/Vck9/RSa9yzaVzfeL0NBzO7vYlmpH6V+Dpf6SuIoBwn0fMz
         1LnPjyn7pi4Ea2id9Rrk0XVLdvlE3fRSVXikVzunpfF96dvfGiS22edbaDY9tRCIDXF9
         nOONgXZ6Du0NCZusXYQE71lzfpUzn3yW8FCh2Kb3MkHDK1dsBDslKKj0n342LnSyihUQ
         lfBe1BDkGGFD5DA/Lvu2b9coV54Zd3ta4sGCk6w9EbBwZ7LL7VqNDRrA59yyTMC/blzh
         gYBpKIMpk6SDLSJkIi5tndCjsf8OHLei+xkeh+QRBuOuHCKeeZXANRNXRktz8/kBlTBt
         CvHA==
X-Gm-Message-State: ACgBeo1gOrw2qFRkvjTvqio1iL+HE7BnxZayL7foXzgogxyiHtuJmYfE
        tglMvXsG3ThoPG2Nie6QBZkih9X95Ssz9vYTtyc=
X-Google-Smtp-Source: AA6agR5tu2Kgr84k0MJkl67WoeSv1iCB+7b03HnN+szMIIeO+EeVVMjO4r80ZPhOy8yF1U6BeSUsaZgrSXoJGNHnZtE=
X-Received: by 2002:a05:6808:13cc:b0:34f:951e:2422 with SMTP id
 d12-20020a05680813cc00b0034f951e2422mr4036806oiw.160.1663246025885; Thu, 15
 Sep 2022 05:47:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:2920:b0:b2:49cc:c892 with HTTP; Thu, 15 Sep 2022
 05:47:05 -0700 (PDT)
Reply-To: miltonleo137@gmail.com
From:   Milton Leo <guynancy96@gmail.com>
Date:   Thu, 15 Sep 2022 05:47:05 -0700
Message-ID: <CAP15NF4PqFvZmMk5Yzpxom9mPOht6sQDt+7BxEVh4ujqJfuvuw@mail.gmail.com>
Subject: Hello my good friend,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:235 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5508]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [guynancy96[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [miltonleo137[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [guynancy96[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How are you? Hope you are fine,
It is my great pleasure to contact you,
My name is Mr milton leo,
I have an obligation that I would like you and i to complete ASAP.
if you dont mind.Hoping to hear from you.
Regards,

Mr milton leo
