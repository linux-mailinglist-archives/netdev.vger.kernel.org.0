Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444BD453A37
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240024AbhKPTff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:35:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240003AbhKPTfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:35:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D01CF619EC;
        Tue, 16 Nov 2021 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637091153;
        bh=68wjAV21qLXiQKL7SZDYBLt94SebE1SFnj7Xh9wy44k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gr1CdqkLLKyhDwoYPEk6OC+wCnKcKdBqXwR92slWtdckhKuqiZYxKF4jWKleSgbcA
         zzr8Bpapbx5v5sF5S+YJ9W4wx71s0MvUSeB8JZSeafLDJT91vr13bgoFG+O/rqB5Q1
         b2YFwymBfmdVrodf1uGK29+G9ImAyKjdEcw/pSdpSrMu3sZ3QYC7nQpcRzh3DhR4Gh
         /y9OzzZVGkKhNThRMCP9sUG9tJaImcthOdbWsSjGf9Zxj335uf8talSeP+98lnos52
         6Z+qZ42uz/r7s4XY8vtHQ5MVPVDBG3vYkOQj5qNnEDVsdJIxApOQCVW1Jg52rGVucy
         z6VyjHuDmy64w==
Date:   Tue, 16 Nov 2021 11:32:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] tipc: check for null after calling kmemdup
Message-ID: <20211116113232.45eceecf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <997876b6-39b4-64f0-648a-8b042b03a3a8@linaro.org>
References: <20211111205916.37899-1-tadeusz.struk@linaro.org>
        <0f144d68-37c8-1e4a-1516-a3a572f06f8f@redhat.com>
        <20211112201332.601b8646@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <997876b6-39b4-64f0-648a-8b042b03a3a8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 21:42:11 -0800 Tadeusz Struk wrote:
> On 11/12/21 20:13, Jakub Kicinski wrote:
>  [...]  
> >> Acked-by: Jon Maloy<jmaloy@redhat.com>  
> > Hm, shouldn't we free all the tfm entries here?  
> 
> Right, I think we just need to call tipc_aead_free(&tmp->rcu);
> here and return an error.

Would be good to get an ack From Jon or Ying on that one.
