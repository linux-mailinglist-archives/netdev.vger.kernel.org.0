Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C964245AD7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 04:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgHQCy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 22:54:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37502 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgHQCyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 22:54:25 -0400
Received: from mail-lj1-f198.google.com ([209.85.208.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k7VHz-0008Qt-Rr
        for netdev@vger.kernel.org; Mon, 17 Aug 2020 02:54:23 +0000
Received: by mail-lj1-f198.google.com with SMTP id q15so2574848ljp.2
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 19:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2jjPmQel1pxO3MR/VLtINS4dkeaCDgPDRMj2nur9GY=;
        b=I8dbqR+7LGgV4CYqG265LMBZaBMESz5enwq5yagGaedmbzJtILfWjZ0I4ExL7ByFwV
         KjoGpqvxC+29SE5dlTC43OHzVZP03/lx5zSXp5CaHuvz94YnZq9ZPXLkUwFxe5OOWPHi
         Q1BnAqoF2N31feBwP01Dne35Jmtp4ZzGS5Bg7WnSllSKZPzd+qN/cq1r6bhckGvB7/3J
         C37xjtAFWjpJmLzGwSKtjwa3mK3aweZYGmgIUJyj26izdtPi9EQ6swr/ujwU2w0ZokHa
         UOB5VshsMGhswtb1IDBS8ClBR2HDlXoodYpo1dm7JZ87/1ZdV14foQj3LD8slNPnF7Z4
         2kPQ==
X-Gm-Message-State: AOAM533W8WCHn/uNtYoptQMJ6SlbS4IdP3cpe0is01YwuocT40X+O2sI
        udiPu0yRx7GBVKuO/JdWmlLW+FogI/F6JJH7y/b8UnVSWcy5cx3nscsfmZbVRaIHSFHIwG9ZJBG
        DjLdnfRx9oK7rj4g/NsRTe/XgA0sES4vzqf0XVKPFx8BueTa6
X-Received: by 2002:a2e:5852:: with SMTP id x18mr5999008ljd.132.1597632863218;
        Sun, 16 Aug 2020 19:54:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKXtlo/YWR4lvo0OddtBB/rs+kUFiIctf6mWJJC51t+bciEX3/ht7hX9V6E1ApK6z9Nw/nUfoKWf/ZsXlQ39Q=
X-Received: by 2002:a2e:5852:: with SMTP id x18mr5999003ljd.132.1597632863006;
 Sun, 16 Aug 2020 19:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200813044422.46713-1-po-hsu.lin@canonical.com> <20200814.164354.1568500831741804705.davem@davemloft.net>
In-Reply-To: <20200814.164354.1568500831741804705.davem@davemloft.net>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Mon, 17 Aug 2020 10:54:12 +0800
Message-ID: <CAMy_GT8bnVCDEgDfDEbVexpV6vgmCBRPe+v6WVxnOYdCXft=nQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: rtnetlink: load fou module for kci_test_encap_fou()
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 7:43 AM David Miller <davem@davemloft.net> wrote:
>
> From: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Date: Thu, 13 Aug 2020 12:44:22 +0800
>
> > diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> > index 3b42c06b..96d2763 100644
> > --- a/tools/testing/selftests/net/config
> > +++ b/tools/testing/selftests/net/config
> > @@ -31,3 +31,4 @@ CONFIG_NET_SCH_ETF=m
> >  CONFIG_NET_SCH_NETEM=y
> >  CONFIG_TEST_BLACKHOLE_DEV=m
> >  CONFIG_KALLSYMS=y
> > +CONFIG_NET_FOU
>
> You need to assign it a value, not just add it to the file by itself.
Oops!
Patch re-submitted.
Thanks for catching this.
