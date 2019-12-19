Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C95E1265F2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfLSPlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfLSPlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 10:41:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A79206EC;
        Thu, 19 Dec 2019 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576770105;
        bh=KF60Qe5gV74XQJzFH9w0KtJr6zzItpIRfiJtfel+FtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mX1sOidzues28HZ3z4Rp9rVat7pc28SuwQU3f/f5w7GvesHpULS+NBePQFyYs2E4u
         eSW17ZipKIZ4SRxxp/vB9x6/Vo8NuMsvT/3DuXqkW3HKNWjZTFuMvZzPIJJ3uQbI6l
         zDqpC5kp7AZDRe3zqkKOMrOQ8MC2GLspIZPT9aIw=
Date:   Thu, 19 Dec 2019 16:41:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aviraj CJ <acj@cisco.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [PATCH stable v4.14 1/2] net: stmmac: use correct DMA buffer
 size in the RX descriptor
Message-ID: <20191219154143.GA1969379@kroah.com>
References: <20191218131720.12270-1-acj@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218131720.12270-1-acj@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 05:17:19AM -0800, Aviraj CJ wrote:
> upstream 583e6361414903c5206258a30e5bd88cb03c0254 commit
> 
> We always program the maximum DMA buffer size into the receive descriptor,
> although the allocated size may be less. E.g. with the default MTU size
> we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> memory may get corrupted.
> 
> Program DMA using exact buffer sizes.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [acj: backport v4.14 -stable
> - adjust context
> - skipped the section modifying non-existent functions in dwxgmac2_descs.c and
> hwif.h ]
> Signed-off-by: Aviraj CJ <acj@cisco.com>

Thanks for all of the backports, all now queued up.

greg k-h
