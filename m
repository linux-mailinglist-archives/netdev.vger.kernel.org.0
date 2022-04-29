Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990B75148B1
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358799AbiD2MCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiD2MCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:02:48 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C0EC8A89
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 04:59:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l7so15027196ejn.2
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 04:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:cc;
        bh=jcv14XD1FEIAH5YEbByn5Xomdekt/dYfYEZFWkwU5FU=;
        b=R782T1vbEbGeRdLXYD/8ETbC8TOiAE8vzY7mGNEJ9vyfIX6eTj6GWqPKbgYqteklyd
         dCEww4fHdmSkNFG8kPF0VdWD92STeo2CdKihV6k7dh1gIk4Ts5EujF5i0MWaJhmkrzQD
         zkv6cXf+nZfHk3U5U24xy/adQ2CYAeJ/OgaFYPcn8lx1v3qfa5SEn1Qj8TP7yxqKs2VO
         D51SjHZxokkYnb8gs70Rvcd9lZfNjdgCVlIOcspVz+CQPZzdo/Bg9d3hb6aRxoJcSa/c
         0cxtVlvqtFVEhWTW6waO0nLYBCusIvftrpqwM5kFaWGo5wOJAHCSpH1l5nO+xq53ETHz
         xLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:cc;
        bh=jcv14XD1FEIAH5YEbByn5Xomdekt/dYfYEZFWkwU5FU=;
        b=QljariCqLJf0ZnJtiCOsYnXPCJUB05oUPTsJ4/r+VichTs1eeLKv7E5aOsEgJc3ocG
         MBUBmPLD0uaUk+qk775WW6jSZXtAFTCJ4GQikWD6/XmhSgCsz1xcTXcH9yA6lQtglLzs
         KNxCrHlXUEGx2Xb4++6PfK4zoSgrf3dnAxo65KHyQoDETel4c2kry0XU8cIBVG7ohKu1
         VJ/fSXTWhMD50L3NmvJaWYiGY8Xxkad1AKq2isjBB8POWop3efbADwHswBJq5rztNmq4
         r+TAvcbf8LIveFVgX2ILJosZSVwCoLpcNp+rfPlg4gR0bzV2p06slb1CqLab09NU3krw
         j1XQ==
X-Gm-Message-State: AOAM533VCuPEVBquoWQdsh7FNwRhWunmsv0kAOM/6O0pCEV29A48QQow
        MBrmg2zKVTa1s/CnGmqtAKUljXnXoV+nTmYgMpA=
X-Received: by 2002:a17:907:6d22:b0:6f3:a9e5:d074 with SMTP id
 sa34-20020a1709076d2200b006f3a9e5d074mt14473075ejc.639.1651233568684; Fri, 29
 Apr 2022 04:59:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a98:b407:0:b0:151:9bf6:acf5 with HTTP; Fri, 29 Apr 2022
 04:59:27 -0700 (PDT)
Reply-To: israelbarney287@gmail.com
In-Reply-To: <CAF-T75h4QFY-2qF_suLDkiOPzdr1xmp0_RFPSAokx_BZB4TZ3A@mail.gmail.com>
References: <CAF-T75gKTtnseVz+h5g6Quhp8m11W_2Bs8YEkOjFixLHG1+0yQ@mail.gmail.com>
 <CAF-T75gD_Ls7BHkye7oExOpXXxzrb7v_T_0eVGwaUGNeO9rcLg@mail.gmail.com> <CAF-T75h4QFY-2qF_suLDkiOPzdr1xmp0_RFPSAokx_BZB4TZ3A@mail.gmail.com>
From:   israel barney <gkristen481@gmail.com>
Date:   Fri, 29 Apr 2022 11:59:27 +0000
Message-ID: <CAF-T75iQhjQazcPdVSAaPosZfTNTkxVjFH=DeC-WHYTd2QJbQQ@mail.gmail.com>
Subject: good morning
Cc:     israelbarney287@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        MISSING_HEADERS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings to you! Please did you receive my previous message? I need
your urgent response.

My regards,
Mr. Israel Barney.
