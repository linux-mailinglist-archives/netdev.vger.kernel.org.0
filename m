Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DF36A114F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBWUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBWUi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:38:56 -0500
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04D31A4BB
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 12:38:55 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id bp25so15459646lfb.0
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 12:38:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NE4PNyhoRgvvNS3itxbGOS64hS81oxscA9jR/Dt131k=;
        b=YQ4AB0NYVT2A+LAP4xfUe0dvNd741lt7LdI0tbJ3P/9hSWSDrZJ1Ybv4rdbArdYoXZ
         b+j/Vvof/CuzjeFGcCUiwG3y2VFQSfcqextJ+mQbcTF609Lx0YqsRV9OlM8t1sFVMq3P
         1Sm66ZDV3wteI4M/8W83hYPhjK+Pl0rMN5kMObprlcRxTK0TCfsGSVFsP5Dqum0oi8z0
         7XMB+nOPpCV89Qj2czZJYt3NEKpjne3Kwpom026wuxaSfb6uPrrvmt5SdeaB5dkzqulG
         iUjqyCdETY/7Qqwx1ZtLkxXult9Wi18/ibpFScgKZsiTLQ2nI13+IP9S5pBTpR5XPAea
         PDgw==
X-Gm-Message-State: AO0yUKWQOn33qDb0KninrfDFIavewitX0MDA26LC1AVEVDmPvpNFXZW7
        NZ39PCc5jv95t65+KFU5N43D3cw+8vfIFB84h2c=
X-Google-Smtp-Source: AK7set8Tyfy45qUWcGBNNxvaNISS4n1Wia9G92XQuGMolQhnA9SjjL6SZ3XXgzeExfi3wP6wWNPvpg==
X-Received: by 2002:a19:5208:0:b0:4d8:4fed:fa0c with SMTP id m8-20020a195208000000b004d84fedfa0cmr3896280lfb.9.1677184733736;
        Thu, 23 Feb 2023 12:38:53 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id y21-20020a197515000000b004d8540a1f51sm156114lfe.107.2023.02.23.12.38.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 12:38:52 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id f16so12045326ljq.10
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 12:38:52 -0800 (PST)
X-Received: by 2002:a05:651c:487:b0:293:5fb9:3c10 with SMTP id
 s7-20020a05651c048700b002935fb93c10mr4106168ljc.10.1677184732770; Thu, 23 Feb
 2023 12:38:52 -0800 (PST)
MIME-Version: 1.0
From:   Thomas Devoogdt <thomas@devoogdt.com>
Date:   Thu, 23 Feb 2023 21:38:41 +0100
X-Gmail-Original-Message-ID: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
Message-ID: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
Subject: Re: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on
 Linux < 3.12
To:     Thomas Devoogdt <thomas@devoogdt.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I now see that these headers are simply synced with (and even
committed to) the upstream kernel. So having a kernel version check
there is probably not something we want to do. Better would be to
incorporate the "libc-compat.h" header as well to fix compilation on
Linux < 3.12. This is similar to the added "if.h" header itself in
commit https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/uapi/linux/if.h?id=0b09751eb84178d19e4f92543b7fb1e4f162c236,
which added support for Linux < 4.11.

Let me know what you think, and if further action is needed from my

Kr,

Thomas Devoogdt
