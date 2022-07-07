Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA05569D0A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiGGILr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiGGILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:11:12 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C316255
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:10:23 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e69so24657072ybh.2
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 01:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UetDmIRwbM+K1YBf+rGh8kIkXFwtqHPVx61P7P6H/CQ=;
        b=DDFBkGoCQGFrEHH4IozrRiLZYWqQ85oW+zXKGo+yojJA+ap4YWJ6W0xT2l7QN3t6iV
         rxLf1mO4XADUjD4Hda8zQGDE7zPxqnsWdIHau15TcyrL63YpA8ahVcT80i6RzmqoZxSL
         MdRJizJMSyEcFcIncIyZcskisJHnIEQ+cctL5+pLEh1ASGXwASgtA8HsrAWBOLb3Ei+z
         9+fxEfvem/hzRcBvMyv2K3wemnFtZuWvyhSSqRtGpc1PdiIhGjiPQGfP1L9oAJibwc4y
         8o4RjTgQvmxqZg+9iIRYewM/E2b2+w3uVYcZXo2Aaby6BGqkhWT4RJra5RC6qI8dLca7
         /7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UetDmIRwbM+K1YBf+rGh8kIkXFwtqHPVx61P7P6H/CQ=;
        b=XszFDOd7oWBShvNrIbHnC/YGKE7t5IH28qRR9mFujvrpk0hjJUoV0+8uDSUNyhZdTC
         vGqwzpVjYaj4pH7fjXESTHTKDtrAevkKT8Xt3zVady8Q4Pb82vIXlXohvXMlrK1NpUwE
         84lZFwltyyGccIslU7z6VeVb5/0TUHzc+VMPbr4RW2SxE9RUSuU4KYSyKAZRs2GOB362
         r09spSjlDmPP09nFEzIqbG3pOFmm5s7Ws7fxvjISDbFTy1MbPlsj0tOjjDOxVFqPCJMo
         EihrMh6oA+wJlCwimJvQPDClhrB8lAL9lQkhvUnLyEMoxY9v/RCgwgGcv+oosHB/UyDG
         W0qA==
X-Gm-Message-State: AJIora8H9VJnGrHiK6AyCUzKcXbyKfSqAgW8ck0WSx0PdfNj9pTGOARK
        2x7HcdRS9gPO39diXDbbUSC+zBdITMLkIBm+P4ZrQw==
X-Google-Smtp-Source: AGRyM1vUkqI3mlESVWUjE4emwmYLOQCOkBeHZVqoCDHA3S9/Ed3Gzw8tRQOmlbJBK6a24uGOVXn9QXDVGEFuH1w7I50=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr50052401ybh.36.1657181422558; Thu, 07
 Jul 2022 01:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220707080245.180525-1-atenart@kernel.org>
In-Reply-To: <20220707080245.180525-1-atenart@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jul 2022 10:10:11 +0200
Message-ID: <CANn89iJFqJFRYXFOZALCTyOAnj1QSeQxM+VMMV4ZMjfk0AxvNg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] Documentation: add a description for net.core.high_order_alloc_disable
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 10:02 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> A description is missing for the net.core.high_order_alloc_disable
> option in admin-guide/sysctl/net.rst ; add it. The above sysctl option
> was introduced by commit ce27ec60648d ("net: add high_order_alloc_disable
> sysctl/static key").
>
> Thanks to Eric for running again the benchmark cited in the above
> commit, showing this knob is now mostly of historical importance.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
