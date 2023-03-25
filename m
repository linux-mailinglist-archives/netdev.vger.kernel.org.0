Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B686C8C28
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 08:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjCYHW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 03:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjCYHW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 03:22:27 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A545C196B0
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 00:22:25 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id cn12so16172626edb.4
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 00:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679728944;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saNBroOvM1I22v58z+1jlGQi08thNGmZ6cK60YX0TO0=;
        b=IuOAgocF9RzRECslaS1GFtenH6BLVeKoyK1+RPytfkjQaT5phQJrOJCPSFtlYbRXwf
         5UZ4mPY3fuC/g1CFfjb2eJyynhLsfrLDQgeD0848igaIoWyhIKqfpDxyyx4rxAPu/abJ
         qQukCJghFbqrjSGC44DQj2sLRQ45zWovXyHB5xxDfde9ro7Os2Lk9cN04+OCR7PSlbTU
         d5JJqRYwQ2gkBfBlDn2boK+2sr450oruRPWxhnIydPLmEJIZ2jrdHqTt9Q3G7KAZDpCS
         nmbe1dRp55G47ggPrVOdpkm5v5IS7vjeM+1iQPxK5jBmMhfq/F8SFuvdnnHnay8jkgJj
         lTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679728944;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=saNBroOvM1I22v58z+1jlGQi08thNGmZ6cK60YX0TO0=;
        b=JNQshmKB8MlaxDgO1bNhYA8lsSU2UkdvHCmzqY6Xwf+AlyHz6eYjanQzujQ9pyYrQz
         29Sdogt2M/8nDQ7WLYxt4VVcLOAnx04q3MzIJCyDwVRJlS2Ih8qfiZg8p3rw3ri5BWO8
         dDfs/0MZRcbv7Aopv1Lm9jr/UhtoY1L0zJB1mY8jIgAmTeX1SDClGBBI1iyC1vqhfaIH
         /6CnxnlVxx5kpVbUmOz+Sk/6AFPINYibpQlv+Ed0Q5Bd2gv7URlZ2MLklZIEGwvvlLyw
         4NmNyGRlaYiLLyaj2agm9SMWgkIaWPb6IbS/agwp1yf41aSvJvIePkDjm+l9eYh8E2Fq
         1AXg==
X-Gm-Message-State: AAQBX9e99J2o65pqaTX4t5sttKA38cABLIK+4a2ji+UNC7sO/aTj3wOS
        SX7jiajsO7M9/uedLpNLAgQtUMcJzxQ2DsglGzY=
X-Google-Smtp-Source: AKy350a7YiY6F5g4GUQwV6NWXEJSInnzJf9PS0n+V+N4U/hVup2OrlAffRnZUSSZT9Z57unbN1x8A8nyd/GKdJvqA44=
X-Received: by 2002:a17:907:a49:b0:931:6f5b:d27d with SMTP id
 be9-20020a1709070a4900b009316f5bd27dmr2788601ejc.0.1679728944343; Sat, 25 Mar
 2023 00:22:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7412:ed41:b0:c6:cc67:5f5f with HTTP; Sat, 25 Mar 2023
 00:22:22 -0700 (PDT)
Reply-To: carteralex166@gmail.com
From:   Alex Ben <alexbigben200@gmail.com>
Date:   Sat, 25 Mar 2023 00:22:22 -0700
Message-ID: <CADqKhr4ScWF1cAvWZj+Os7H2L6vhaZZa6EXz=5U++Cz+KJ=oBw@mail.gmail.com>
Subject: Business Proposal.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 

I have a business proposal for you reply for more info.
