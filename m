Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7932CC773
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgLBUHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgLBUHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:07:19 -0500
Date:   Wed, 2 Dec 2020 12:06:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606939598;
        bh=svQ6C/OrYDVXDydR4542Gxx1RyfdBi4y9ZXbce2JbwU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=nY/UJX8XdWl5u4GaSGduQnQisn96+nPsqMo6Du0cpreYG0I187120fGVCySPyFCEz
         1X/fRphJbVMdzu8+RIz7W6vTxUwN0EFb5QZotdXf3KUT6Tu7jvHIO2MgYGEBPk2Qcv
         tf2ShJWmo6UMjYduRN9R7+Ov8hqkE5zJhXFCbrr73MR0ABQ1nwenayKI9AdD/t+yOI
         FKnWy/ZMOKizfJ5ldQVhI0HtZa63aP1tiW+jp56cojNqLRohg+QbpbdmVA4+O7BOXK
         kP5Ggm3Iz5/7f1RjM7WnDYdJe4tIhGx2BqyYxj8ymBX2EdT8TEnBHrQQb+MaxSjiEw
         waHN3OZGYGBFQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] mptcp: avoid potential infinite loop in
 mptcp_recvmsg()
Message-ID: <20201202120637.1b6abbd5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202171657.1185108-1-eric.dumazet@gmail.com>
References: <20201202171657.1185108-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 09:16:57 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If a packet is ready in receive queue, and application isssues
> a recvmsg()/recvfrom()/recvmmsg() request asking for zero bytes,
> we hang in mptcp_recvmsg().
> 
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
