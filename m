Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A26A2DA4D4
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgLOA2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 19:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgLOA2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 19:28:31 -0500
Date:   Mon, 14 Dec 2020 16:27:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607992071;
        bh=KMxg5hRVuG/hBD2ju7vFj5JRBbZYMSvIFCB2EzXBhq4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=FUVXAtijwTcYe8yPUvDfdO4W2I3nDe340j4X6r/Y5shME7a8JraePqOE+6IIMSvuK
         nDIqVYWhgV1XPvRaN6QZyFVP4hAbKrVwV3Q7qxaziQW+xNwHBtj7lVcVR7Hcuz0QjI
         xDhAbHwkK/ByGfcPoKKa95A0Gx1yDY93xTN3CK/2ZqLNAExBP6ORXiWDxkLETt38UL
         R+/XcPTphGVXH+BlsPP4lRTvj0EvP5y+sJQ15uaP/B4mqrqTYT864bdVmJvsI26gOh
         h/FePElt6J0dwYeJzTzQlvE55yiEoD1g4W+mDRB4gbZQV9o1V6wdKffpj0gM8UMOtJ
         ptYghRMvpoqjQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com
Subject: Re: [net-next 0/2] Adds CMSG+rx timestamps to TCP rx. zerocopy
Message-ID: <20201214162749.75dc5488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
References: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 10:44:17 -0800 Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> This patch series provides CMSG and receive timestamp support to TCP
> receive zerocopy. Patch 1 refactors CMSG pending state for
> tcp_recvmsg() to avoid the use of magic numbers; patch 2 implements
> receive timestamp via CMSG support for receive zerocopy, and uses the
> constants added in patch 1.

Imperative please:

  tcp: add CMSG+rx timestamps to rx. zerocopy

  Provide CMSG and receive timestamp...
