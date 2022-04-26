Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693C150F353
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344102AbiDZIHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiDZIHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:07:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806AD41607
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 01:04:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so1552636pjb.5
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 01:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=dKcUIpiaOihT4R5jeXs4xTqFm8l6J3OzRyPekvqQPa8=;
        b=kTdSALqxVjCmXE/H5l6MThSS3l0V05OkY411qPyAwqYYcIpG1e9TMjBa3qDnuBYOH9
         BFHo0bclyxQ1FE+5nPShFhw9Nx12p1WJTgsEVqTAf+Tp5pO/lBIKwLaIDJtPXePf3adg
         PuB1atEphD8M6t8E13cQCd+gmXT1Du0RNv6XDse95A51KGpP84s3HV0k88Vbbs2q9+0u
         wyXNjcMY6QDMibrg/FtT3mTe+GwoJXt1sHvCPj+DHT50QLdBEw21SdQ8r/uyN9R9eUnG
         6I+Q0BQRMGmmfMjeACmM199QwDs0GVNwdE+37W4LFP6biKXDvq7mVKV0IGl9b82Qce/O
         /TNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=dKcUIpiaOihT4R5jeXs4xTqFm8l6J3OzRyPekvqQPa8=;
        b=N2ZMbgPZNrMrETKT+/PRLUbdIu4nerZt8XRzA+mk3RDVW/voZpaFX3U6OfN6yoi3Dz
         XSvUnyxMhckwSDHfXtJcr0aPupiZgHyP6C6iTpu3AAr1q+HWDbSKT+eCOtBvnL+YNfC1
         QYVr1MJLWaVn68xhnoEmfbyfJsKOLgOMTZg4G0vS5deXaC08kQrJMo6U2QWOOquSMh/6
         +0jzbipyC4x5B90M6oCwRTucgqAqTxYaOeBXQCVNN7Aiu3waL4yoAlcdX/0fCqe1Qq2D
         4Nkz4P/LRILtMrzg4PMBis8w1y+4CU0IlYyYv2MJmIuGnUkiKpe3e25rm+1LCbFE5y/D
         lpBA==
X-Gm-Message-State: AOAM532BmkQhxD7jZj3vkRY2/E/2+ZayV0jDik2cDA4uypfE7Gr+podd
        kdL+cR8qt3YiVuh4KTL1n6PRHbCwfuE2LTmLwBM=
X-Google-Smtp-Source: ABdhPJwfCiX/zG/V4xN2siRbZ0R0GPVs6hwlruWSGLBLTx3eWcg9WmuJYRbNeagDFIZupNzKcqk9QDPx9CpkmhmKb4Y=
X-Received: by 2002:a17:902:6b8b:b0:14d:66c4:f704 with SMTP id
 p11-20020a1709026b8b00b0014d66c4f704mr22490977plk.53.1650960264978; Tue, 26
 Apr 2022 01:04:24 -0700 (PDT)
MIME-Version: 1.0
Sender: rev.mongol@gmail.com
Received: by 2002:a05:6a10:e882:0:0:0:0 with HTTP; Tue, 26 Apr 2022 01:04:24
 -0700 (PDT)
From:   Aisha Al-Qaddafi <aishaqaddafi633@gmail.com>
Date:   Tue, 26 Apr 2022 08:04:24 +0000
X-Google-Sender-Auth: 1dQxWED1WUu6EebQa-SHWL8pQUA
Message-ID: <CADHYjy68AaDx-j_J-F29RVkoy9r38hbNFM_uY1=6pV=eJ1rmkQ@mail.gmail.com>
Subject: Investment Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_HUNDRED,MILLION_USD,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY,US_DOLLARS_3 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Investment Proposal,

With sincerity of purpose I wish to communicate with you seeking your
acceptance towards investing in your country under your Management as
my foreign investor/business partner.
I'm Mrs. Aisha Gaddafi-Al, the only biological Daughter of the late
Libyan President (Late Colonel Muammar Gaddafi) I'm a single Mother
and a widow with three Children, presently residing herein Oman the
Southeastern coast of the Arabian Peninsula in Western Asia. I have
investment funds worth Twenty Seven Million Five Hundred Thousand
United State Dollars ($27.500.000.00 ) which I want to entrust to you
for the investment project in your country.

I am willing to negotiate an investment/business profit sharing ratio
with you based on the future investment earning profits. If you are
willing to handle this project kindly reply urgently to enable me to
provide you more information about the investment funds.


Best Regards

Mrs. Aisha Gaddafi-Al.
