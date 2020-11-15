Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113B12B3193
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKOAW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgKOAWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:22:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A6124073;
        Sun, 15 Nov 2020 00:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605399774;
        bh=2aVgTInTQtRmCoqwyjK7dLuBWSRcR6hGaDbFbwcbEn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K96scIA4fD6D/LH8snljRd1b2kRtsVSKwScPQe/fzlwdzqYzf4JH3VOoWPjGzYGs2
         LnPJSaoofUKoN+Vk2M9CF/651y7Z71BcYRwWXqKdCu9Nn/hRCUoE5cDskzobc4DLjB
         dYXhAlMgwNRYQxOVLsMkNqzbo9yoTbM/GXC6hsSg=
Date:   Sat, 14 Nov 2020 16:22:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] inet: unexport udp{4|6}_lib_lookup_skb()
Message-ID: <20201114162253.65be6c21@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113113553.3411756-1-eric.dumazet@gmail.com>
References: <20201113113553.3411756-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 03:35:53 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> These functions do not need to be exported.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
