Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE36E1B4CD4
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 20:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgDVSp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 14:45:26 -0400
Received: from terminus.zytor.com ([198.137.202.136]:42279 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgDVSp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 14:45:26 -0400
Received: from hanvin-mobl2.amr.corp.intel.com ([134.134.139.76])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 03MIi1bp1756663
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 22 Apr 2020 11:44:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 03MIi1bp1756663
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020032201; t=1587581047;
        bh=dIQ0s7CSMK1UKyQ0AWlyM0gbBVakPmljyV3eEPda8bM=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=hYv6h7G1OIqP2oGYDKFgihUJ7y1uBmklu81bwutsUBYb5uLTqvrf9EdHSior/oD0i
         DVy/dJw6Pf1/mu6noDD+0raFOhCGDpUZLNx3DiB2urI3khadAf120qbLu9iGwHpT6w
         bRXeNpyQOuyk5F3yT41bDsH9/KBdYPSSlF9dP1iSx/u/iS/awSQ0tT5fTIev1SR1KB
         pRtgLXoBB5nMFyjr1OyFzZl/Ay2YRjjSdZ5Z99HM86hAwGAtFMTp8iGn0TXCqyeX6L
         DMHF+8t7dtHCgdHwKlcb9/YXGAxG3Z1xL0OqFbrP4jz0R7A7OAPsFLBmJF1M+84i9M
         5qbMVq9zVwufQ==
Subject: Re: [PATCH] bpf, x32: remove unneeded conversion to bool
To:     Jason Yan <yanaijie@huawei.com>, udknight@gmail.com,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        lukenels@cs.washington.edu, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200420123727.3616-1-yanaijie@huawei.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <dff9a49b-0d00-54b0-0375-cc908289e65a@zytor.com>
Date:   Wed, 22 Apr 2020 11:43:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420123727.3616-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-20 05:37, Jason Yan wrote:
> The '==' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
> 
> arch/x86/net/bpf_jit_comp32.c:1478:50-55: WARNING: conversion to bool
> not needed here
> arch/x86/net/bpf_jit_comp32.c:1479:50-55: WARNING: conversion to bool
> not needed here
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  arch/x86/net/bpf_jit_comp32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

x32 is not i386.

	-hpa

