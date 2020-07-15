Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC8A221672
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGOUnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgGOUnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 16:43:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068072065F;
        Wed, 15 Jul 2020 20:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594845829;
        bh=okKNAClXMm7f+owKlz4U5E1CAhcTvP/RVlCw6Qo1KQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KRXLn2KGBvT7qYSefUWZ6oe5DcJOauuNtDcJ0MV2RNUjKo8MMy8OfIuXNFur+eH/d
         Gown9e/vFYCbMTEwdwNA34ozBDCzKvu5fS3MADH3cSLf7rnI+cTlhnaB81AvSYUuco
         DXyppICDefAE1fEDPQ2Y1IOlObBDlTVRbnQIPvm4=
Date:   Wed, 15 Jul 2020 13:43:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, gnault@redhat.com,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next] bareudp: Reverted support to enable & disable
 rx metadata collection
Message-ID: <20200715134347.6a9324ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594782760-5245-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1594782760-5245-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 08:42:40 +0530 Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The commit fe80536acf83 ("bareudp: Added attribute to enable & disable
> rx metadata collection") breaks the the original(5.7) default behavior of
> bareudp module to collect RX metadadata at the receive. It was added to
> avoid the crash at the kernel neighbour subsytem when packet with metadata
> from bareudp is processed. But it is no more needed as the
> commit 394de110a733 ("net: Added pointer check for
> dst->ops->neigh_lookup in dst_neigh_lookup_skb") solves this crash.
> 
> Fixes: fe80536acf83 ("bareudp: Added attribute to enable & disable rx metadata collection")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Looks like you didn't remove the mention of the RX_COLLECT_METADATA
flag from the documentation - is this intentional? 
