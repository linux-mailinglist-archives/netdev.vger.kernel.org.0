Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA08817B128
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCEWFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:05:04 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37264 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgCEWFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 17:05:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id a141so250659wme.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 14:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=EhKBVdcz866K4wnwDswHBvfCjaO9wEJhCH3XfiyKgH0=;
        b=MYUSp1yyHIyfUQoBkSk++6L+gN9r2CwS6n7XkTuy1COjDTQP+RfiPbvYpgCWNB/Dv8
         sb5vDOYw1Z7pFoHO5thDajUFJAo6C4pYdDrdygO3xiE8rrUEFoFH01hJcxq+Nqgjrdgy
         OXDziGaw1xQ8TuYPiJ3kjXynyA6ecUiNdvFOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=EhKBVdcz866K4wnwDswHBvfCjaO9wEJhCH3XfiyKgH0=;
        b=QUCAjbKBQnpXN7jgkQgF/4Jkpd2TyIXnfAB2PTyBAJuF95UaZOh5ltCMtfI9BN6qnU
         orS7xvgwiELxWWRpDNAxccmdiXjl+KIPrwKdrxdblN/82W827Q+3gqgs8Ss+slQAboxN
         8T1XRngIozTgrpRWUZ/JhcmHxP4rmRIfVCjhLSczArcIqOoSqwCkbhUwWVagP53VjLEB
         rcWz4LO7YjMAfeY6CAFXOSMbW5U2vK+Ahf9mzwCxcog8zpNF57WKbW4g6wKOuHta/rdA
         Inq2gRzmi1rrG7vIwwOcGtPZc1GsxD+U0qEY/l9OVe6YyJVMzvvm/V5Kx0by/Zksm5X3
         WXiQ==
X-Gm-Message-State: ANhLgQ1mVvdvpBpIHY3Tl3vZAnMcwFUAaMw88xPlWsFQM+8sOXD5TPy5
        e54F5Vvk9qg6L29LMrsWMQx1kg==
X-Google-Smtp-Source: ADFU+vt6t8EoUGCNV2n58jrEKH2onN0n0W2VGeqOhMgZzwWhHn5Ke5k36KI3cmY21zNutLgVSU0kHA==
X-Received: by 2002:a1c:e918:: with SMTP id q24mr865012wmc.25.1583445902100;
        Thu, 05 Mar 2020 14:05:02 -0800 (PST)
Received: from chromium.org (77-56-209-237.dclient.hispeed.ch. [77.56.209.237])
        by smtp.gmail.com with ESMTPSA id p16sm46052523wrw.15.2020.03.05.14.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 14:05:01 -0800 (PST)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Thu, 5 Mar 2020 23:04:59 +0100
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 5 (bpf_trace)
Message-ID: <20200305220459.GA29785@chromium.org>
References: <20200305175528.5b3ccc09@canb.auug.org.au>
 <715919f5-e256-fbd1-44ff-8934bda78a71@infradead.org>
 <CAADnVQ+TYiVu+Ksstj4LmYa=+UPwbv-dv-tscRaKn_0FcpstBg@mail.gmail.com>
 <CACYkzJ4ks6VgxeGpJApvqJdx6Q-8PZwk-r=q4ySWsDBDy1jp+g@mail.gmail.com>
 <CACYkzJ5_8yQV2JPHFz_ZE0vYdASmrAes3Boy_sjbicX6LuiORw@mail.gmail.com>
 <CAADnVQ+K4Vc2_=tB7COFFBy3uswike-TERoSF=1=GdnWFDUutQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+K4Vc2_=tB7COFFBy3uswike-TERoSF=1=GdnWFDUutQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05-Mär 09:38, Alexei Starovoitov wrote:
> On Thu, Mar 5, 2020 at 9:32 AM KP Singh <kpsingh@chromium.org> wrote:
> >
> > This fails as we added bpf_test_run_tracing in net/bpf/test_run.c
> > which gets built only CONFIG_NET is enabled. Which, this particular
> > config, disables.
> >
> > Alexei, if it's okay with you. I can send a patch that separates the
> > tracing test code into kernel/bpf/test_run_trace.c which depends
> > only on CONFIG_BPF_SYSCALL.
> 
> In such situation we typically add __weak dummy call.

I would prefer this. Less chances for breaking something. Sent:

  https://lore.kernel.org/bpf/20200305220127.29109-1-kpsingh@chromium.org/T/#u

> May be split will work too.

We can do that separately (if needed).

- KP

> or move tracing_prog_ops to kernel/bpf/core.c ?
