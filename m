Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B01A2F1A25
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388353AbhAKPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:52:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731466AbhAKPwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 10:52:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A07EF2251F;
        Mon, 11 Jan 2021 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610380303;
        bh=Es2k0h+26hNNjATG11DvaX8uXnVDAE5QUnH9ejSvFPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l71kPYjBBbCPdO3SBsxD9bpm7OE7Zi/6v3Lk3CtXQee3op9frz+YUPOXjg89qfgug
         RlEU7Aj0H/k5S6HVwXDpRPKgWzXaCCIUjsWIg7HXsR+k6XoW/4jNYZ7QpYQ31Mtvck
         ScGnT4FNMVsav4D+gfKmZBo26I+OftmauN+EWx4NFySxHHe0H3cQpRaJsS03wE0XgC
         BcqEZYPFgaaUEc0FODjwMcUkudt+AvwzqtFegyVsemSXvVFWoNkc4gOXRhAAcpP1Z5
         +QwJ5NamXBo3yT6prJZhFDP316a14MCeZBzJ5vFYZvFYNzxwS8mW4fiY2QbL/HA/sV
         qHlTKBJr3B6uA==
Date:   Mon, 11 Jan 2021 16:51:38 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     giladreti <gilad.reti@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Signed-off-by: giladreti <gilad.reti@gmail.com>
Message-ID: <20210111165138.652a5525@kernel.org>
In-Reply-To: <20210111153123.GA423936@ubuntu>
References: <20210111153123.GA423936@ubuntu>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Signed-off-by line should be last in the commit message, not first.
First line (which becomes e-mail subject) should describe what the
commit does (in a short one liner) and where it does it.

So for your patch it could be something like
  bpf: support pointer to mem register spilling in verifier

The commit message should be written in present simple tense, not past
simple, ie. not "Added support" but "Add support".

Also we need your name and surname in From: header and Signed-off-by:
tag. So instead of
  giladreti <gilad.reti@gmail.com>
it should be
  Gilad Reti <gilad.reti@gmail.com>
if that is your real time. If it is not, please provide your real name.

On Mon, 11 Jan 2021 17:31:23 +0200
giladreti <gilad.reti@gmail.com> wrote:

> Added support for pointer to mem register spilling, to allow the verifier
> to track pointer to valid memory addresses. Such pointers are returned
> for example by a successful call of the bpf_ringbuf_reserve helper.
> 
> This patch was suggested as a solution by Yonghong Song.
> ---
>  kernel/bpf/verifier.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 17270b8404f1..36af69fac591 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
>  	case PTR_TO_RDWR_BUF:
>  	case PTR_TO_RDWR_BUF_OR_NULL:
>  	case PTR_TO_PERCPU_BTF_ID:
> +	case PTR_TO_MEM:
> +	case PTR_TO_MEM_OR_NULL:
>  		return true;
>  	default:
>  		return false;

