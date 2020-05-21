Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C67B1DC36A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgEUALC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgEUALC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 20:11:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C542075F;
        Thu, 21 May 2020 00:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590019861;
        bh=8eIfE1itBSEOZ9OXLTe/icTIY4KBnTHvfRYvjcl9zbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vOBCH45x2pxD81nIiPP9Gwt0lutnHnW66gO9+cHmQ/YKkdN8L7dVihQPXqs5dYM6B
         vir7SCtg7XCQ38YDbY9/gJ1+cgaHAsSC1kIM0QKzWaDbPSKwL5uSrpwltfF+2U9Mly
         gO/r3jT6f/YWqHkp0bqS7Rl7q/b2xrmY3gUQLggo=
Date:   Wed, 20 May 2020 17:11:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] rxrpc: Fix the excessive initial retransmission
 timeout
Message-ID: <20200520171100.46482c16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <159001690903.18663.2345549941598300103.stgit@warthog.procyon.org.uk>
References: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
        <159001690903.18663.2345549941598300103.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 00:21:49 +0100 David Howells wrote:
> Fixes: 17926a79320a ([AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both"")
> Signed-off-by: David Howells <dhowells@redhat.com>

FWIW

Fixes tag: Fixes: 17926a79320a ([AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both"")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
