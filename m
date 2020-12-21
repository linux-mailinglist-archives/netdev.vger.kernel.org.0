Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4602E00B9
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgLUTKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgLUTKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:10:18 -0500
Date:   Mon, 21 Dec 2020 14:09:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608577777;
        bh=Vs/wCDAlf1tXrLmrsYBElNZPfe5oXS5d4dOycNslqBw=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=hKd3wzV6JTACaL0Kc3NwWtIH7mFpgzb3d6YQy1+OZ88IBTR3ttit5FOVAC49uQFII
         BUJGpSNB8BK/wPFEB+EwL8qdihnSP3C2grLJCE7B1rTPMbdscOXgcqyqxrk1q0zZcA
         gRPoJlsKkZKHlyIJeIsLeNltY2k+GmjjZ086lpPNBzqOvhEQ/Pbjlxl/+ww8/KI9YS
         ny7EPOflRr6a3yslsC2wl1rMbIuDjtSJ0AnKmPF/JLPauZmHfBZ0hAGnPKZrSJRZo/
         vPcvwFBXh+O2C6h2bJluqK/FcwTt0GXh3Ppfaw9Or9U7ljIO8tHy2XWwyNgXd6c3jL
         h1F/XAt0a7feg==
From:   Sasha Levin <sashal@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 08/10] selftests/bpf: Fix array access with
 signed variable test
Message-ID: <20201221190936.GF643756@sasha-vm>
References: <20201220033457.2728519-1-sashal@kernel.org>
 <20201220033457.2728519-8-sashal@kernel.org>
 <X989/9omnIGyDvzV@larix.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <X989/9omnIGyDvzV@larix.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 01:05:19PM +0100, Jean-Philippe Brucker wrote:
>Hi,
>
>On Sat, Dec 19, 2020 at 10:34:55PM -0500, Sasha Levin wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> [ Upstream commit 77ce220c0549dcc3db8226c61c60e83fc59dfafc ]
>>
>> The test fails because of a recent fix to the verifier, even though this
>
>That fix is commit b02709587ea3 ("bpf: Fix propagation of 32-bit signed
>bounds from 64-bit bounds.") upstream, which only needed backport to 5.9.
>So although backporting this patch to 5.4 shouldn't break anything, I
>wouldn't bother.

I'll drop it from 5.4, thanks!

-- 
Thanks,
Sasha
