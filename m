Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280F829F418
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJ2S3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgJ2S3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 14:29:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2922820732;
        Thu, 29 Oct 2020 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603996183;
        bh=c4xmi/u0PLiEv+/2i9iSo4juWyGOfphEjvHX1ZdMHdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DNC+30hyoBdHqdgXtCRVsRzJAbctAYUXfIfmTt626ANPkUEHT83Mw28SDwYMP5vBT
         OH2pQJmGUZfZ2cl+DX069MrNObt4EzFUGxw41OVa9B8dBbSWEJfaN9ZXfXZBQ+Omez
         5nshKhFHPNmOi+8aeRnsHGeh9/riwSinoNZy8/F4=
Date:   Thu, 29 Oct 2020 11:29:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: add missing memory scheduling in the rx path
Message-ID: <20201029112942.773b5b74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d7886714-7b92-9be8-441e-73c48c52d62@linux.intel.com>
References: <f6143a6193a083574f11b00dbf7b5ad151bc4ff4.1603810630.git.pabeni@redhat.com>
        <d7886714-7b92-9be8-441e-73c48c52d62@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 15:46:11 -0700 (PDT) Mat Martineau wrote:
> On Tue, 27 Oct 2020, Paolo Abeni wrote:
> > When moving the skbs from the subflow into the msk receive
> > queue, we must schedule there the required amount of memory.
> >
> > Try to borrow the required memory from the subflow, if needed,
> > so that we leverage the existing TCP heuristic.
> >
> > Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied, thanks!
