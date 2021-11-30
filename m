Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ADA463E38
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbhK3S7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbhK3S7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 13:59:04 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4B4C061574;
        Tue, 30 Nov 2021 10:55:45 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b13so15683982plg.2;
        Tue, 30 Nov 2021 10:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qv79wVTcK+nZ5LSvR3T9ntnRBhY6KehuqGBysRBPuRE=;
        b=fNUaEzNSlII0Vfa59e+1be7oMLK8TQ7us7zeZxsLaU9dikgRXmTDdr1un4Eh3cwvuL
         NABoPv86mfNDNV31zgWBztC5ZmiULBzdT53duK9FNI5G4JMR63bUgeiGc9E5HdK86ndo
         zVOfiXoLajoPQSj97S8aNISyNTY6tQ0j4veaRKrQDUTsQCSTBikgoNwWo4/1JLYDnvJI
         aPCRVuS86eY39RI0Jxny1nlohMCgeCfr/F88nOLJ4LPywgk3mLJDQikYGuv7Ul/g6cSe
         OZf/3MVt1K33FmGUc86Mi3s2Pmru22CKasp02I56eLLmvd1vovHJKbn2Pd0TRQRnzYVS
         o7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qv79wVTcK+nZ5LSvR3T9ntnRBhY6KehuqGBysRBPuRE=;
        b=YP6qCgw06zkH5gAq+L6gAhS070OWlAkcv45dcm+Ufg+hxdAUs7G/HQgoioOqaeiJuo
         esGPlvSV48B6/mvQlYQSTIrbMZZiYOCJ2E5X5mcGzk6AhY8UtjGHxOJtNHjJ98K6uPKL
         94Bnw1XBeaFwA7T8NUwX0pGBMTegJ8/zs2mZviQYa+Gddmcxsl/d4jf4rFlgDQLN61qo
         /4+lwRZbT+HKEvM6QqNZf0W5aVfec8Aosn5KkghxaGA4z+mVobwdanOWyXGdyFqeLyiG
         3bDYmq3DyEnIfIE8ql/bvsyVy7dUA0aPu7PMqnA6C/E4fZOj55LdjxW+WJZ1ZuO3exhJ
         Uigw==
X-Gm-Message-State: AOAM531FO41M/8lUHDXfWiV2r+Jvz64/f3Mqyd6jUckFO8PikMrUCaGb
        MoLauoPU3mZB26xrY8QVWvuBuL/Fe4uppEyo978=
X-Google-Smtp-Source: ABdhPJyNnukIlGCEjBI/qU6SfJP5DjYZ5pJQl8SyGBTZLU+zruRWUvFKNCWKti6h2p/r8e103Xphua89ismzUHqqSuc=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr972516pja.122.1638298544945;
 Tue, 30 Nov 2021 10:55:44 -0800 (PST)
MIME-Version: 1.0
References: <20211119163215.971383-1-hch@lst.de>
In-Reply-To: <20211119163215.971383-1-hch@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Nov 2021 10:55:33 -0800
Message-ID: <CAADnVQKymbNQw3U5YhO_f8Aecon4KXbx9HvuZz=syc1LgOCT1w@mail.gmail.com>
Subject: Re: split up filter.rst v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 8:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> for historical reasons filter.rst not only documents the classic Berkely
> Packet Filter, but also contains some of the most fundamental eBPF
> documentation.  This series moves the actual eBPF documentation into newly
> created files under Documentation/bpf/ instead.  Note that the instruction
> set document is still a bit of a mess due to all the references to classic
> BPF, but if this split goes through I plan to start on working to clean
> that up as well.
>
> Changes since v1:
>  - rebased to the latest bpf-next
>  - just refernence BPF instead of eBPF in most code
>  - split the patches further up
>  - better link the BPF documentation from filter.rst

Applied. Thanks
