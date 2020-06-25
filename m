Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7F9209804
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 02:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388798AbgFYAxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 20:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388760AbgFYAxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 20:53:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEC7207DD;
        Thu, 25 Jun 2020 00:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593046380;
        bh=jhI7zt/HktgIHIVgqLy5ckzxuQe685jyp/iDxPVNzdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oEX/1q8aGwVWrLI/9fv9IUY1/iRUzUw/bsALOVu2lQq2D8zBWNKBHsg5WHNV3YIkp
         G23rkWuI1IH8z83aGrI3mVhEEcjl4Ltf/sk+srmhwubIa+U3vd3+FLdcZMwToWteGC
         Vl2/o3LYRRI7FcOBfHN4qpZPRPOAWDvTUnvZ+ggI=
Date:   Wed, 24 Jun 2020 17:52:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] dpaa2-eth: fix condition for number of
 buffer acquire retries
Message-ID: <20200624175258.2b7806e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200624113421.17360-4-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
        <20200624113421.17360-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 14:34:19 +0300 Ioana Ciornei wrote:
> We should keep retrying to acquire buffers through the software portals
> as long as the function returns -EBUSY and the number of retries is
> __below__ DPAA2_ETH_SWP_BUSY_RETRIES.
> 
> Fixes: ef17bd7cc0c8 ("dpaa2-eth: Avoid unbounded while loops")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Looks like this should be targeting net?
