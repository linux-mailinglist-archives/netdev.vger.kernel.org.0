Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F192240DC5D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhIPOH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235997AbhIPOHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7BC660238;
        Thu, 16 Sep 2021 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631801193;
        bh=XSsf+GSDjITbK0Hdi9SCvdXW8e3z1CcUJcD7Q9CQaYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z2DQqN56hsCdDV4ck7KLbh4x2R9X2xccEp91OQwBVuv4WWB6upw638tv9Xuu7tgaE
         k94Gtpjk2h1Ls5vocUn/OmZFN/RnhNR/kk6WbHmb4d+pRqA6z8nlpN+tdDP/jZE6sU
         MtZb1nc0fiFp9mSZYxOGtsjGQLcjhwgG/y1cFXzXz7vnsEklZHgM43v3tGIiCvAafg
         1Hg29tEVuTOgVe1hbbOpff0ysp2eNKAbRGZbhQmEVYrFwoNWv08YavNMm+oWOaF6d+
         kFOgBs25lOiZSKttJ5r5QGHrw5d4xGy4Ch9P0Cwn4oh+tAW69VeOw6f/xIFOJLFodC
         vNuEFMu/2WbEw==
Date:   Thu, 16 Sep 2021 07:06:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
Message-ID: <20210916070632.2ee005e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 20:21:04 -0700 Alexei Starovoitov wrote:
> +In HW
> +-----
> +
> +The HW can choose to execute eBPF instruction natively and provide eBPF runtime
> +in HW or via the use of implementing firmware with a proprietary license.

That seems like a step back, nfp parts are all BSD licensed:

https://github.com/Netronome/nic-firmware/blob/master/firmware/apps/nic/ebpf.uc

> +Packaging BPF programs with user space applications
> +====================================================
> +
> +Generally, proprietary-licensed applications and GPL licensed BPF programs
> +written for the Linux kernel in the same package can co-exist because they are
> +separate executable processes. This applies to both cBPF and eBPF programs.

Interesting. BTW is there a definition of what "executable process" is?

But feel free to ignore, I appreciate that polishing legalese is not
what you want to spend you time doing. Much less bike shedding about
it. Mostly wanted to mention the nfp part :)
