Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF73082C3
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhA2A5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhA2A5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:57:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE06564D99;
        Fri, 29 Jan 2021 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611881792;
        bh=Ta0wY4oQs9Q1Evxv6kiib5oToe6W0JcAYPk5n/IMhvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bLInykDUhYwzld0uGwmB/USwNSi3MB8S8YIBlw0ERRyrBsJHF+MeSC3cc4s6EuN+X
         kq9gDOocrUYQ1ZM4Yw959n1fmIYqBVYPEl/1D/ZNNX3oN8RmjmBfgFtHiKCQsqzVa0
         YVI9VBrpjCMyTIuSQ5gVLJDPCdnJ/GrMzvGMAe7zolO6PPEF5xLsGqPmNpmpIwueea
         QBUQIa4kn/fvHo1oKonsW4I9Zr5FP0JNMkgZQP30b3MJc56BoyOC7k2rfoAFEy/pqc
         Z+atzp35ym0e4p3GjSoBVkAZzTtrtu0Liukdn8S0gGCaHoK3H3sLy9lPIDUOLTQsRu
         fgrLzdi1KroDA==
Date:   Thu, 28 Jan 2021 16:56:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: reduce indentation level in
 sk_clone_lock()
Message-ID: <20210128165631.35a4d940@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127152731.748663-1-eric.dumazet@gmail.com>
References: <20210127152731.748663-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 07:27:31 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Rework initial test to jump over init code
> if memory allocation has failed.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
