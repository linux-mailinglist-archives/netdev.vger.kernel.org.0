Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898FB447E01
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbhKHKbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:31:43 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46806 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbhKHKbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 05:31:41 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AFCE26063C;
        Mon,  8 Nov 2021 11:26:56 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:28:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiabing.wan@qq.com
Subject: Re: [PATCH] netfilter: nft_payload: Remove duplicated include in
 nft_payload.c
Message-ID: <YYj74yX8H0+p9SN2@salvia>
References: <20211102091355.21577-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211102091355.21577-1-wanjiabing@vivo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 05:13:55AM -0400, Wan Jiabing wrote:
> Fix following checkincludes.pl warning:
> ./net/netfilter/nft_payload.c: linux/ip.h is included more than once.

Applied.
