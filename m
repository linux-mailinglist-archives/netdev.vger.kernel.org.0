Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C600C2AE618
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgKKB6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgKKB6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:58:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3807216C4;
        Wed, 11 Nov 2020 01:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605059928;
        bh=8Ugfj7AyDCOgoVGG/IcR1mvDQbdjCGoRoBOMK8EPMSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qPRPh04xqzL823otozlZKKK7JmT803K22YMsVZbha0N8RoUb+V1RrPfmOWrkzQJTR
         p2i6QKS3R5Xun+t5ZEhDUjbnK2V8EnceR3IL1lrJuOSDA1BRJv7FLubJI6ADK1MAa6
         TuIKyJYWHRAvuDUdTvIBz/PZwCmmXIQqLlz+Ih/8=
Date:   Tue, 10 Nov 2020 17:58:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 0/2] inet: prevent skb changes in
 udp{4|6}_lib_lookup_skb()
Message-ID: <20201110175846.118c4ca3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109231349.20946-1-eric.dumazet@gmail.com>
References: <20201109231349.20946-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 15:13:47 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This came while reviewing Alexander Lobakin patch against UDP GRO:
> 
> We want to make sure skb wont be changed by these helpers
> while it is owned by GRO stack.

Applied, thank you!
