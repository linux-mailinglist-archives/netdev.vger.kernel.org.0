Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92C1634959
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiKVVfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiKVVfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:35:14 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13336BEAFC;
        Tue, 22 Nov 2022 13:35:13 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e13so22426849edj.7;
        Tue, 22 Nov 2022 13:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cWvFlRLFU7LxrYn/RLpYUbjQ3plVi0tJneW/bVBsyxw=;
        b=LLRKmHZJ1FLrE+Q7xD9f28XFkVSJaJpFTSHzIMu/jCX2IqoRBzKgqByPmZmfJniTCV
         mYUoY0OKqq3VxFluJK6DATs4r3DEwG5lUM54yi+u5aLVdoyUl2mbSTAOjKFjazkmcoQj
         iGyM386wFl1/DXAFiiOsgrWk4cq3hJHcv5vyYk4caEbrQC/4rQ29QCT15ilDbcYAUdSZ
         gzZ3fySLeXQq3UrTilnyVf2SMc+Jsr6cfSJUKpaveYbZKzDGr599z6nCiZ1wfCOlgmFb
         r/mo/V19UFi206+KpcyWKWEBdpq9miwfWRGfC2p//E7+1Fuofzb+ODezJCWTciDMgT4Z
         /Hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cWvFlRLFU7LxrYn/RLpYUbjQ3plVi0tJneW/bVBsyxw=;
        b=jmeJM+h0pF8Ckk0t+MZKWNDYh3A/QaIsXAaKvDvIEdgKur2KOvaDjCJ2npHlVxgNYF
         SmbzSqUETAua+8ecTz0nTQGHG/tk69qkX1IKnOhGDG/xJ7hrzjiuJShDNUNzn1f8n6+t
         z9xbIqjtQmDcjLvadD8Kktq7e7JfYp82gLWQ+wdQ8yGwb+p1GuSglIcVSzowzmkS4Ysx
         Ndu/yHImb8R266aSBUU3P/Hsg918FfR3EhJbUyRET9nvJ4ZU25mFmXGNuily5RpL1wdk
         d75axnYKbuASU4LrzESVbOz4wGf2M12lIgj4bz6pw9A3EArbgmZSPuXv/YG3rtTMdluK
         63xQ==
X-Gm-Message-State: ANoB5pl2e9HkF5Oxjp9pf5wZ/6hPlhv/yHi7INEf/Y2lnpEFifsJtqp+
        MiZzkCxdh3RFW9TggBM2PuoIh2Y45aZnVWJFrkilsXyR
X-Google-Smtp-Source: AA0mqf798oCyCTmC7/hNZb1PoaevfH2dXyc5dL93XgeOtgwyFtilBdL3o+96iXAGdWGth+nYeYqk8nGIi0/iOnHrJvY=
X-Received: by 2002:a05:6402:5289:b0:462:70ee:fdb8 with SMTP id
 en9-20020a056402528900b0046270eefdb8mr23224297edb.66.1669152911428; Tue, 22
 Nov 2022 13:35:11 -0800 (PST)
MIME-Version: 1.0
References: <20221123082409.51f63598@canb.auug.org.au>
In-Reply-To: <20221123082409.51f63598@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Nov 2022 13:35:00 -0800
Message-ID: <CAADnVQLEeeu5qyjqGFfQLEed8b2_LwZccyAkPKidyO4Yb+yPBw@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 1:24 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   6caf7a275b42 ("Revert "selftests/bpf: Temporarily disable linked list tests"")
>
> is missing a Signed-off-by from its author and committer.
>
> Reverts are commits too.

Ahh. Fixed and force pushed.
