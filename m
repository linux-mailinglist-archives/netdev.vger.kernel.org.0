Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE90443DAC6
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 07:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhJ1Fgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 01:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhJ1Fge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 01:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DDC60FC0;
        Thu, 28 Oct 2021 05:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635399247;
        bh=AdJsroB2m4N/mcOAS9TBrbsJCkhR18EYD+Bj6Kog6+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vvUNnNQUQwgRQI/Ve5DoxtG9rFs22IzvE7WMuampCFn3rxohuJxiBa/k/dwllI1Qd
         9A702w46K0XaF75Vbl+z/FuWFmNkD8j95WLfr0cpzz/sg/tBsPiToHM2ogIqp6pzyp
         Uzb7ANh4WX7MDT8K5BtOn0Lnk13gCIpEQmjZeEJw=
Date:   Thu, 28 Oct 2021 07:34:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH ebpf v2 2/2] bpf: Make unprivileged bpf depend on
 CONFIG_CPU_SPECTRE
Message-ID: <YXo2SpgjcsDzsD9O@kroah.com>
References: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
 <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 06:35:44PM -0700, Pawan Gupta wrote:
> Disabling unprivileged BPF would help prevent unprivileged users from
> creating the conditions required for potential speculative execution
> side-channel attacks on affected hardware. A deep dive on such attacks
> and mitigation is available here [1].
> 
> If an architecture selects CONFIG_CPU_SPECTRE, disable unprivileged BPF
> by default. An admin can enable this at runtime, if necessary.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> [1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf

This should go above the signed-off-by line, in the changelog text, not
below it, otherwise our tools get confused when trying to apply it.

thanks,

greg k-h
