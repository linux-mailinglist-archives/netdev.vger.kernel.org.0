Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752ED2192CD
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgGHVsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:48:37 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CF7C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 14:48:37 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id y18so27727410lfh.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 14:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLy55D+0/BwpBtr1ZxsTL1vopgXGP3cZae8SXAEegmM=;
        b=fykGTcPtMrs8wwk8rhV0vVrxQAOMjyEZdy6lx/oa4PQkQvQUDJXNDvAqTF1KS1FMtU
         K39vdQxHQXD8Ihht8pGgVet27cv1u1V2GRCd543eWycDNyv/pu9xGjebKVfBI/+RDu6E
         UGpQ2uS4HqGB4SgEumZ5VtIoNnBrrOb/R9M1Fve7QghdlUIcRoPW/6ROX2eqDo1JiR1Q
         9J+uS5CA9MoWTeCX37pthJnV7dApZ4W/2v8keUTQS7VPdoDQ1v5JkFvYKTTirkAnRcsm
         8JY+bZQLn2hWxcenJ8Xr0bHQn1U0LvudfyHI0ymhDeVmCeQqsM0sO1UcgFoQ6/IUdU+n
         k5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLy55D+0/BwpBtr1ZxsTL1vopgXGP3cZae8SXAEegmM=;
        b=P0vqWQiA6EJKhk0LRRxCD8Q+UIMAcYaRKi3PHaC0ghaEOV222PV/YATaRq8bqw1VIN
         Pe4nqe3rA2eRBobxo0ndVWyR+hVnaYr7GBtS1ajCO6KvZb0mG6hclqiBeSVcVkA1tbY7
         Qtwp0mRXHJPgkL/UiZLC5JKhnjSh+QgB+pssKtQ1IZQ1MDPJhgtUVgMSDR3Kpd2v/mT4
         sioBQw/lDhXjA7a117C0XpuaZ91RhvS6GGUwYSEwjBzQyM3gor5RRtNQek7e4GNejYJF
         VYNv708SXdcPc/cUF4FTfx9DhgVkxcVuehgHu0aLn4sP8fQhzZre/sEZtz8yUb9kPos/
         7Syw==
X-Gm-Message-State: AOAM530FEMqYCIvgtnx1yKT1BFLYcU8uPcITK6GMDXCyAjCmhxFNKk5B
        u7ZtZWrC6/Rvks+BOn0UNtC2Q/K1Nqfl2d+YYJN2hQYcgJw=
X-Google-Smtp-Source: ABdhPJxSl7lVdzhcZPC39sKTHaxj5U1ajPKiof3AwBgBr0/Pue+oC6+O438JzjssM8BnJrqQqQLSa2MvVXWwRx25Gbk=
X-Received: by 2002:a19:8608:: with SMTP id i8mr25290458lfd.54.1594244915951;
 Wed, 08 Jul 2020 14:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200708123801.878-1-littlesmilingcloud@gmail.com> <20200708084028.143d1181@hermes.lan>
In-Reply-To: <20200708084028.143d1181@hermes.lan>
From:   Anton Danilov <littlesmilingcloud@gmail.com>
Date:   Thu, 9 Jul 2020 00:48:04 +0300
Message-ID: <CAEzD07+PmoX-wXJ5Vc_i6LEYKB=A0POFJD+CNAO2QNbLnxihnQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] nstat: case-insensitive pattern matching
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Stephen.

Thanks for feedback.

> Why not just make it the default?
> I can't imagine a scenario where user would want to match on icmp different than ICMP

Yes, I'm agreed. I'll make it the default in the v2 patch.

> Perhaps it should also be applied to ifstat and ss.

I'll prepare the patches for ifstat ans ss too.
