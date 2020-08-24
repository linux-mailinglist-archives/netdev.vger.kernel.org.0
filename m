Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C1B250B16
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHXVrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgHXVru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 17:47:50 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4578EC061574;
        Mon, 24 Aug 2020 14:47:50 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f26so11401255ljc.8;
        Mon, 24 Aug 2020 14:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8AEMx+c+PIG8pVY+1WZJabYi9uVpApSHXqIEELfdGY=;
        b=YkjD+uj+Uvg9cAMLJes7/IcruEFSRaXCc2h/WETwH7QH1oHaNOxh50r52bZ09fQiYQ
         EIMMtqWFIsAFYR38qEiZiiox7Tyla+H151srxmmEUdzuikHxOd7vPry1wFGV2t4OCzil
         FO17CT4i+sc0HQLXvsJnP2o6JxatA6ziAoeWKGwcVlC688T6r2MELrimnVWOS+qWvcYr
         H8xJ1pnmR0v1MMfwgQ57kO5NQ2y0A24+XUxKtd6Are8kja8Fa0U0j/hNrdYKtg8hB8OV
         pnS+U20s9Y5WACZCLZXreWJ7sESdJg1Tvy3ouot/WWdzkpt5EuFNtoZrAlsF+x4fDGOt
         Ryiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8AEMx+c+PIG8pVY+1WZJabYi9uVpApSHXqIEELfdGY=;
        b=aNht+UZInZmuukI1j1LdyILaWPo4hlCiB+iXvrYaGNKggAL8YWkqoWrdW4qD3J+j35
         m5HE2ciNEwIeBUmEWVXkYds62rfIRwC1XpVPigNuB6/QL7FmenPcD6HwPMq+zyc1ON1z
         7T0xxJxJ0kgf1FRwDx7VXuDbzsjQ2miOaY8QZGNIF8BNenKC+MXdDu6VOegrmCKKxpiI
         J+z8OCK6OvUmeFl7WQ1zairv/93jAzHhINQG8k6jKupq5Esn/mVaM3AyRtIQ4hy2cKyN
         SqHDwoKE4U6RpAN8nJPmJL2ILmJ24BAM9seIfPGbxWlzQXMyVexpYXRP7V41TyW8CrET
         ji3w==
X-Gm-Message-State: AOAM533sLT3Ju7XLbb8qQ02TwokkWtMFD5WuaPUhmA6y9Ihq8+y8DNk0
        xScudIEG2h+ezmFkFnI5ZV6vNjK+JRMFliW1f00=
X-Google-Smtp-Source: ABdhPJyvIf4NPitY4M02yDuGYpeLWF7mxpYui7UX/35anjxUsVgeX0RbTHSoNCMqzVX6fW9WyUIZRqlPnzoirTWNkhM=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr3563500ljb.283.1598305668740;
 Mon, 24 Aug 2020 14:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200821100226.403844-1-jakub@cloudflare.com>
In-Reply-To: <20200821100226.403844-1-jakub@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 14:47:37 -0700
Message-ID: <CAADnVQKm8nQsTVamtNZbSJz0feezdLk=vYKitp_zjT02TV9ejw@mail.gmail.com>
Subject: Re: [PATCH] bpf: sk_lookup: Add user documentation
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 3:02 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Describe the purpose of BPF sk_lookup program, how it can be attached, when
> it gets invoked, and what information gets passed to it. Point the reader
> to examples and further documentation.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied to bpf-next. Thanks
