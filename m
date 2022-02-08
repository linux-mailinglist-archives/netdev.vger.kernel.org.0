Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669A44AE23A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 20:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbiBHT2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 14:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiBHT2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 14:28:39 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED29BC0613CB;
        Tue,  8 Feb 2022 11:28:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t9so184477plg.13;
        Tue, 08 Feb 2022 11:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6e4MDxl3wHvTXN2TRdnmx0NOv76W0iY7xMa5vcXZ9A=;
        b=n+xFrX/Pw4gYdmCS3efRMvgO+v2Xw0v3oMimkNHW3CdnrjRl914hdt4Aj2RjN+F2Et
         57ZAJtPxGjHg2PUETdKViHYUyocFplEZ7hu0+gKIxFg9Kve41QZLgHt6zAcgLqodzJGJ
         jhrpkWIn3ZGP2Bubhy6knJxTWGKVqFtsmpQAI6yxLYz/7aHKWJxSTIYGrVexBWHIOouy
         E+YW+yxnZiIOsTwM4CfNKKy5CFZ98Xw0Q54HzGtywO7hv1nJX6ZkQECxNnI0diNvNI8L
         jGJHDWj8CmFNMdhGqCplZS6KwUa0uFDHm6Gjeww9HrFZ7Ufv6ndwaXjAAxGtc41EHG9p
         O+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6e4MDxl3wHvTXN2TRdnmx0NOv76W0iY7xMa5vcXZ9A=;
        b=0c9AkyXQDbJidTVev0SYyaUVcWxfqjQVpU/UM6esgUODnf2uVnklU5FE9zjfcziSBW
         asINKAAICFg1SgZnWUpbzsmz/Tj0tYfinewPTU6KAyaQ4j++r/Iv51tFPxQXvQpFk71W
         fYYqCjvy61bSaMbHt0UCuttW2a30zh09hktyf8lJpmoIzt7v4yI/orMAPF1268XVsywE
         R7YLUGu8dCMNZcRB76kzP1KRQHL6325EkSbwY6PHyIOkc4MxF+NebPNaK9Le7DjlGRoC
         2GSRUKJuAqx7LpX97nfq4aOIqsbmEz7kvGNH2EAwl/vTy38MKK8S1jdH7e8GCQi6pG/L
         1Dtw==
X-Gm-Message-State: AOAM530Vog6f7exiau2wndDV/4FN8clbuThgKvXKtY29APwMW0q8gM4f
        S66pIEjbfy0UfMlfwk0UNUraFqYSZ0OHg3E9u3o=
X-Google-Smtp-Source: ABdhPJyVRbJxQu+H/asVSNzd1KZzwhvauoH/33k+i0pzLsza8y5hTO6gSDAWDyt/eNvO5Y+AoMCwipQ5CSByjED7Xmc=
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr6042404pls.126.1644348517409;
 Tue, 08 Feb 2022 11:28:37 -0800 (PST)
MIME-Version: 1.0
References: <20220207131459.504292-2-jakub@cloudflare.com> <202202080631.n8UjqRXy-lkp@intel.com>
In-Reply-To: <202202080631.n8UjqRXy-lkp@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Feb 2022 11:28:26 -0800
Message-ID: <CAADnVQKGF=YaKvzWZFO1c9bO63XHoiD=i-w-chCeSbaNoRfdwg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Make remote_port field in struct
 bpf_sk_lookup 16-bit wide
To:     kernel test robot <lkp@intel.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        kbuild-all@lists.01.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 2:05 PM kernel test robot <lkp@intel.com> wrote:
> 7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1148
> 7c32e8f8bc33a5f Lorenz Bauer 2021-03-03 @1149   if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {

Jakub,
are you planning to respin and remove that check?
