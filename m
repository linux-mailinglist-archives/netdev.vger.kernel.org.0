Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53547EFE5
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 17:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353104AbhLXP7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 10:59:16 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44564 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241840AbhLXP7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 10:59:14 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9A3C3607C1;
        Fri, 24 Dec 2021 16:56:37 +0100 (CET)
Date:   Fri, 24 Dec 2021 16:59:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_set_pipapo_avx2: remove redundant pointer
 lt
Message-ID: <YcXuTSFXRGPKyf0x@salvia>
References: <20211221193757.662152-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211221193757.662152-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 07:37:57PM +0000, Colin Ian King wrote:
> The pointer lt is being assigned a value and then later
> updated but that value is never read. The pointer is
> redundant and can be removed.

Applied to nf-next, thanks
