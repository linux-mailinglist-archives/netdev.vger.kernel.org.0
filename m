Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5C63F31EB
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhHTRCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232906AbhHTRCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 13:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906B0610CC;
        Fri, 20 Aug 2021 17:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629478913;
        bh=xTkMIkuRn3ljkfmNjAERQ5Fr9C6u5cx0vFhpd6KNW+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JRdx79AsJcT6Zc5Uyn3gZruJaO9Ff23MDu6d+m+7oqP29/sX9gQVEwXJ2AeQAvYc0
         Gbj4drL6XtAfuPnBOpHkGOmJyLNU4axMlP6hU2K8yQWsZtoR/0udqGOoyr+e0SyeUL
         h/zn0BeNrl5W1t/Rrzagp6aUcwFJ+sqt32KbWJMX0tMG95IPUZTAEy7D94QBIgjyG4
         AWNc+N7kUZWfDUL2cpSqufQsJMDPeaOCmnNMrrLR5VXHkfbEL5KgGvvEUbS7XC130Y
         pm71LqlZNBlv+F4oft0cZObRc89TZJ3pVd7rdL2OURCZ5lz4rRIBFIUnlAJ+gdXObM
         KH2HThdFFtQHA==
Date:   Fri, 20 Aug 2021 10:01:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/3] net: Cleanups for FORTIFY_SOURCE
Message-ID: <20210820100151.25f7ccd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819202825.3545692-1-keescook@chromium.org>
References: <20210819202825.3545692-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 13:28:22 -0700 Kees Cook wrote:
> Hi,
> 
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> These three changes have been living in my memcpy() series[1], but have
> no external dependencies. It's probably better to have these go via
> netdev.

Thanks.

Kalle, Saeed - would you like to take the relevant changes? Presumably
they would get into net-next anyway by the time the merge window opens.
