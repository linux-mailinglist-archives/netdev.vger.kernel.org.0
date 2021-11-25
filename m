Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D36045D307
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhKYCQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243053AbhKYCOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:14:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04F00610C8;
        Thu, 25 Nov 2021 02:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637806300;
        bh=we4lzqjpqmLtrFPZIH6eDyosFWOCIeDfTAbZLnC5JEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ioce4Z4Ct0hZSqrLkP75ZK4WgmQMbocYTw83zBOPMtTo7mdfcUFLfypEIDsW94e8R
         IlxxSzDY87WrJJA3bf9P7v0842XNTsxaQ3pXy9mSSAADBSFVwmTwMWv/N/teFPMDfE
         0Y15597kHGu8ryBptk6Cirf8/mtkh6cXBDRJRZlYjKgBimUMqzwCghaqSQsklcSvUE
         5RgnkaTPiRH9pbZxE8WfmyEwg9bH9wEuoopCioQDrO/lt1xVNNuzmdcHddxXad4H+T
         3NHlXVTT/BOOnbb3rxmJETWdcsBRezOK/RuY/FMixLcnru7tYJqZFSuzNkT2ikyTYh
         d87WGLBpf4T8g==
Date:   Wed, 24 Nov 2021 18:11:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 2/2] tsnep: fix platform_no_drv_owner.cocci
 warning
Message-ID: <20211124181139.406ab72e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANr-f5yDK=voAX3q6S8dEz=wPBa78QaWVrVctx+YmXFz+oV7OQ@mail.gmail.com>
References: <1637721384-70836-1-git-send-email-yang.lee@linux.alibaba.com>
        <1637721384-70836-2-git-send-email-yang.lee@linux.alibaba.com>
        <CANr-f5yDK=voAX3q6S8dEz=wPBa78QaWVrVctx+YmXFz+oV7OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 21:32:27 +0100 Gerhard Engleder wrote:
> >
> > Remove .owner field if calls are used which set it automatically
> >
> > Eliminate the following coccicheck warning:
> > ./drivers/net/ethernet/engleder/tsnep_main.c:1263:3-8: No need to set
> > .owner here. The core will do it.
> >
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Applied this one and took Gerhard's patch for the resource size thing.
Thanks!
