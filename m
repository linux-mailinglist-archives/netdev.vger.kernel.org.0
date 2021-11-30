Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70C04640C3
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhK3VyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:54:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:51930 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344608AbhK3VxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 16:53:14 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 46ABF607E0;
        Tue, 30 Nov 2021 22:47:30 +0100 (CET)
Date:   Tue, 30 Nov 2021 22:49:42 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: Use memset_startat() to zero
 struct nf_conn
Message-ID: <Yaacdlj7UX1StO5Y@salvia>
References: <20211118203113.1286928-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211118203113.1286928-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 12:31:13PM -0800, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_startat() to avoid confusing memset() about writing beyond
> the target struct member.

Applied to nf-next, thanks
