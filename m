Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8370462B51
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbhK3D44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhK3D4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:56:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4826DC061574;
        Mon, 29 Nov 2021 19:53:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7768AB81696;
        Tue, 30 Nov 2021 03:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAB7C53FC1;
        Tue, 30 Nov 2021 03:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638244414;
        bh=Xbqf1Qw6VkwibXpQT6sF1yneZieb5lH3C6moEpEclXc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fuFPviqEOmamZpz8C2DTDGCwzLhGarGz55wRbxS1jA2kVZ1HCu4VqidsXBYJfFqaH
         9s/WQuWESoClsDt6VQ9Wwb8bop2Vi0eyMOw2pU27Z8obS0E2lbR3XGpjMLY4EIijff
         yI3xta4YBVp0Ax/zSNL4f+X0IUi6dNjbk72FN6a1ifVJWpVZOPjnSDEoUUJzSBQZmF
         /+87NMAR2Sm7ULdDyB2Tn7xiVKfcxQgfVawGCLLxnYAmD0uYBNfcVv8XjaNbBtJTpf
         OvjjYL8TpV96/hyfkVrt5YYeyNzPk2l0gJW7n/7arUYxbN8CGDENoJ4t+AW9mSMoLO
         7kQjzplUWQyRQ==
Date:   Mon, 29 Nov 2021 19:53:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tls: simplify the tls_set_sw_offload function
Message-ID: <20211129195332.06704cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129111014.4910-1-tianjia.zhang@linux.alibaba.com>
References: <20211129111014.4910-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 19:10:14 +0800 Tianjia Zhang wrote:
> Assigning crypto_info variables in advance can simplify the logic
> of accessing value and move related local variables to a smaller
> scope.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
