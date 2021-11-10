Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2344C41B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhKJPN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhKJPNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 10:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9269261205;
        Wed, 10 Nov 2021 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636557035;
        bh=KO1wbmDTsKwN26qcykYTGxLKSQsWtEAPLuJDerbfYL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W17mnBoJJaz7nsZdcdk8XJ2/vS3rvvgy5TQOod5YIGlCPPFpdw14dW3G4a6zC/WwI
         q3OJQQ8yAEcIXKw7KBZeqL7bFgiAfN3/VIj69f/Wd3Vq3qmWziJtNAlzScrGGc7Tmz
         +NouBH1EjhniPhAKbiKs3BXzZqT/pbdiLFHif56tVcPd+p0XZq3u2MTUJ3e2zO2oQ/
         EmOOxiHjz2hMUB1oVcpWJaTe/gYZXn2dNWqKp6mLTvpm5eiyFOomMNx/l5gAKi8EJ9
         dnSLcdBWW/IO9wUFc8pGQ/RD80m30lceDANu5bXnlXgCD0u/yPjDK3iwCAAOyOR0Rq
         6Yl4NfDL0C2Xw==
Date:   Wed, 10 Nov 2021 07:10:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Joe Stringer <joe@cilium.io>,
        Peter Wu <peter@lekensteyn.nl>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and
 .gitignore
Message-ID: <20211110071033.23d48b10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211105221904.3536-1-quentin@isovalent.com>
References: <20211105221904.3536-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Nov 2021 22:19:04 +0000 Quentin Monnet wrote:
> Bpftool is dual-licensed under GPLv2 and BSD-2-Clause. In commit
> 907b22365115 ("tools: bpftool: dual license all files") we made sure
> that all its source files were indeed covered by the two licenses, and
> that they had the correct SPDX tags.
> 
> However, bpftool's Makefile, the Makefile for its documentation, and the
> .gitignore file were skipped at the time (their GPL-2.0-only tag was
> added later). Let's update the tags.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
