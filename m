Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4586C3D84
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCUWNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjCUWM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:12:57 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCDA56796;
        Tue, 21 Mar 2023 15:12:53 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id t9so19799169qtx.8;
        Tue, 21 Mar 2023 15:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436772;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiM63SAw3Y6vdnFpuNvnkhrzfxrGykvOu70AYopANq8=;
        b=68ji1NiEBV/9ZOC0v1faDz1C4DSNj+9ELH7rKMqBlBT67jxPXJofXqAH1OhJpxkR/X
         ztMUl6t781kdfhZz5CbTqn11xQnuQ6mnkzR3xjb5f31cTDyPgdhkprlI71SrXWu64Tjd
         QenEh3Xo7cHSh7ADr42jR1ol8fQu+auzw3O2kwZoSLxmc7c8pwxO9GhffZezrqL2TxvG
         bagUPFb6dfOeYHnxFs71K7DlI7mq6kIJK+8HzqBFx7w0iqirqqclLmIeMTrH7xiWx+6l
         C6CA2IhmJpZsXercfHn/tH6tpmdo8JmsflIRwbiahKyXrfb0TrDC6hhnVq9O6gRVbGaT
         nohw==
X-Gm-Message-State: AO0yUKVCXf4PlBNsocmlQAt8nkuwRd8KPdYJd1njaF2alO+q3styMDWx
        F/M0F6td/6q3Xt5+LV9B3zI/q1um096Rbg==
X-Google-Smtp-Source: AK7set+GfHDVAINEE24tfeYdSQgo1pJxYA7zGf/vef4jFda6Kn5TqmdrGtDLDqcvpi45+75n3umnuQ==
X-Received: by 2002:a05:622a:180f:b0:3b9:bc8c:c1f6 with SMTP id t15-20020a05622a180f00b003b9bc8cc1f6mr275819qtc.1.1679436772158;
        Tue, 21 Mar 2023 15:12:52 -0700 (PDT)
Received: from maniforge ([2620:10d:c091:400::5:be69])
        by smtp.gmail.com with ESMTPSA id i19-20020ac87653000000b003b9a73cd120sm1371200qtr.17.2023.03.21.15.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:12:51 -0700 (PDT)
Date:   Tue, 21 Mar 2023 17:12:49 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/4] libbpf: Rename RELO_EXTERN_VAR/FUNC.
Message-ID: <20230321221249.GA239208@maniforge>
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
 <20230321203854.3035-2-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321203854.3035-2-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 01:38:51PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> RELO_EXTERN_VAR/FUNC names are not correct anymore. RELO_EXTERN_VAR represent
> ksym symbol in ld_imm64 insn. It can point to kernel variable or kfunc.
> Rename RELO_EXTERN_VAR->RELO_EXTERN_LD64 and RELO_EXTERN_FUNC->RELO_EXTERN_CALL
> to match what they actually represent.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
