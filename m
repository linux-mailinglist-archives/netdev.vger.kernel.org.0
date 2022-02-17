Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA04B9CEF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbiBQKUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:20:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiBQKUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:20:47 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301782AB508
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:20:33 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id f3so7952475wrh.7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Prmmfg2rEV4uJgRWjd+vofDxNghZEzQF4wrdv02e8Pg=;
        b=h/owCrYaDtZy8RKdnNl2H+rCIFCGXUJ7poE5ygjxqJpP0X+x8Sw5BTqw4GwN8vuU7Q
         DvoqHqT60KJw0MjsL4pd7ZlLx8YEWUH226uFRr6Vo4W4+eq++CHC7iXZIEtPbfutBCTA
         jg+GzerdA4y6fQG3yEd+mDtfwIrqC5j7O7ng5FNZObMsX3GXTxnEiLB5G9fVsGC4NKaU
         McUiBuk3RQ2cdmVCONHKEjsBcHcDNhqNZr422szq+6+MxDcWpIXiwH9Qt9GlLcjBBZNW
         dcQJ1sIGAXrCxB9SlxA6tGXpkVN0gLWfMwHese5JDmc9GAdSVHJN1rs5a+qjl9YfAXnz
         m2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Prmmfg2rEV4uJgRWjd+vofDxNghZEzQF4wrdv02e8Pg=;
        b=KcMQIDFBIDdyqYXnH2KwMitut51l9ZSHre/+mFLrQEf33StbwVGb4JNDKj4jVy+q0k
         tEyYDUiEcuz7MsgrK5akq8K9vIzMsmM/+FCvPvsXd9WQHZ447Uy5palOgd2/UEEuMKGF
         rvmDU4UcX7ajXsWuPcGDT92XPvv/7oBsWbJoI7xd8q2IujtCy8+9cynwm/HFgBrJ0i72
         ONzEZANOzHf2u6I1ClSL7PC+KSKX4/8S7tKCDBKJ2V8UQ8YK+UFpTSHx442o9YISD3yZ
         kttC8Ndi1P0uOgG/bmhjAzYDyYXlQZUpx8pUff0RSKzWnf2P73/s+Cv15hnBf9oiQJCf
         h5qw==
X-Gm-Message-State: AOAM530j6OnqXGGtOP0RzvhP4lFkkgJ7476s4welZXDnJDkDnz65pO9A
        WmQtMCgor+aJ0R/vn1Oqnzn+x6SD+ZZUgGCGQHQ=
X-Google-Smtp-Source: ABdhPJyECbCbYg/4x8WZAYw5kcUXWU/2llXxj76JnmuiXVWUsxpMqjtoZgu/VwXN7YC6oy2jfFNQ/5QSqoSqBiqk2rU=
X-Received: by 2002:adf:ec51:0:b0:1e3:d68:6398 with SMTP id
 w17-20020adfec51000000b001e30d686398mr1687071wrn.203.1645093231762; Thu, 17
 Feb 2022 02:20:31 -0800 (PST)
MIME-Version: 1.0
Sender: gb676779@gmail.com
Received: by 2002:a7b:c155:0:0:0:0:0 with HTTP; Thu, 17 Feb 2022 02:20:31
 -0800 (PST)
From:   "Mrs.Latifa Rassim Mohamad" <rassimlatifa400@gmail.com>
Date:   Thu, 17 Feb 2022 02:20:31 -0800
X-Google-Sender-Auth: TwzQrrS2-WBpiuSRbm5tPOLDjjE
Message-ID: <CAO9H84Pot5y_PjMkHoVi8wx1+_9bGZW9A=aff_5v9wPMVQiVRA@mail.gmail.com>
Subject: RESPOND URGENTLY...
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Morning from here this Morning and how are you doing today? My
name is Mrs. Latifa Rassim Mohamad from Saudi Arabia, I have something
very important and serious i will like to discuss with you privately,
so i hope this is your private email?
