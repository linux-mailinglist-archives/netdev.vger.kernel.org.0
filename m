Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C278F64CD9E
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiLNQDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238731AbiLNQCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:02:38 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3C923167
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:01:53 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gh17so45641065ejb.6
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mwuIivs2bXND3SDhAV+zSYDmApbibgZQPxXCRZ6VkeU=;
        b=oJ0BTx8/fzc/1SJo4ZpoTeJmjzZKHFk+5WZC+5jf2UzgKYGPAJo56tOsxPYbj8ivHh
         gxbfpk5xDGQxSBcmogzTRsuGc1BAdEH6hN3ReMmZB9E4RUvM4/QBeYmMfE98qxLVlqmC
         8yIHDDRduUZbrFqts4OKX4/THvLp5PgxLHEaa1QHAFU+3Lmx9HaWOCckE5SOqeVIcXM3
         wCbSXiEXhEPK49FNl3Jy6L+FlIf1y6xp2X1oD2aKfQb/F+LnvMh1OoJgrCiNV4U5FIXW
         kqifKkSbP3q01Xe9wc60oD9roYoAj/mPh5b7PJj8XeV9F/S2aYAvOafsth5YGke8qhSd
         BRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwuIivs2bXND3SDhAV+zSYDmApbibgZQPxXCRZ6VkeU=;
        b=ACVSeiUGO+3G+wIyvtKoi1evuMvfc3GPp9tkX7tOvwIdw6dLky70Gf6QsQ2JWxMQun
         FT/xcd0bR5l8j6NJYSXsmzQQrbXuj/MdwEIOialzkDneiLZ3ZA8+ALp40bKho/mSNLN6
         K6XX1DKV6LVtkjwxDzoIFManBvTByEN/PqUCawZ7k2tfj+BOwjRNKfA3dWQ8j7Vtn5vL
         OAQ13gg3S/LAnnXTnbRvMTlMxLBHyWndgSBmTc7q+uDINMmnhBVXnt7Zl0ZMM2pDsFLw
         IXQnACy8f8QSgqnRj5WzP0Q+5iNLZJD/zoloYfG0ORNE1lAEBRVtphnJ0SGseAM7sA9i
         xa9g==
X-Gm-Message-State: ANoB5plXFAC7TxZaNMyF+XdeGXs7KCEFiGuxqjn8tr+v9r8gSD8M5FN/
        8s8IXe2BVMETZx409sxFLm9qEm8oX8Qweg4O9R8=
X-Google-Smtp-Source: AA0mqf7cBkamVBK8eQK2lgdVYhLyugjTlAnsaHM7oC2o1BBluzJDeClHoXnsSLHDsUwlp/T5QoEak3h8XuqWGr4Lark=
X-Received: by 2002:a17:906:4a03:b0:7c1:13b6:fc50 with SMTP id
 w3-20020a1709064a0300b007c113b6fc50mr9325199eju.70.1671033711591; Wed, 14 Dec
 2022 08:01:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:bc46:b0:7c1:30c3:9613 with HTTP; Wed, 14 Dec 2022
 08:01:50 -0800 (PST)
Reply-To: chuinh021@gmail.com
From:   chuinh <correasilva505@gmail.com>
Date:   Wed, 14 Dec 2022 17:01:50 +0100
Message-ID: <CAOwfSSoJ9Bji_gbo74JEOrjdtUNoQ3C1i11kRE1c3xsNoyomxQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
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

-- 
Dear Friend,

I have an important message which i want to discuss with you.

Your Faithfully

Mrs Can Yeu
