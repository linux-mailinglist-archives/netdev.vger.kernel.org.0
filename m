Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC3A28F869
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbgJOSWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgJOSWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:22:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54C5F206FB;
        Thu, 15 Oct 2020 18:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602786157;
        bh=ggOS7Um6cbE2+Z8oEmcBMEN6ltRBOm2OkCxaZ3hf2Ys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=baf2UZ6dPM3DMksCo4dhYYUHwL2Wf04o31DffOeE1C2B5XIuGXuvLurCS0eF4k59B
         SqUw6h9YKg+xr339d/8Fsvxgpvj2xXtGWjvZaYyVka6OcfcoLf6hoL5IfOxIN0RtpI
         VHRaIZstTxHCuEuUgIClGO0Hp43dXexfmv8KTJGA=
Date:   Thu, 15 Oct 2020 11:22:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] rxrpc: Fixes
Message-ID: <20201015112235.35ae3bcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
References: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 13:59:11 +0100 David Howells wrote:
> Here are a couple of fixes that need to be applied on top of rxrpc patches
> in net-next:
> 
>  (1) Fix a bug in the connection bundle changes in the net-next tree.
> 
>  (2) Fix the loss of final ACK on socket shutdown.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-next-20201015


Pulled, thanks!
