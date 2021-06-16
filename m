Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690A93A911E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 07:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFPFXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 01:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhFPFXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 01:23:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D988FC061574;
        Tue, 15 Jun 2021 22:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sxjUz+Ejc/4WE2gmhLls9n4YZud0RJdZK2yLZKH0tfA=; b=LD/VLC3tt3aYNEJgkGSKANrdPa
        lz7Sygw1Ey2XeJE7btenkXSNDq53fYgI1YWW1iKJd3QuIzq7cGhZl3jLhI50kPN3t1946kE8Tn/ZX
        2jmGhsgqLIgzisFsnvOmfcCXr/QBVMfwyRFKDvm9PZztVmMD5WgnJFeSd3f2gNHW/1O4Csl0iiLGU
        29EIEynnAOD78vWrOsbRaZF/pDp20B4QtzEYm+KAg2Sg2H5zS0QTd+nIb/Xgpc6kSmssruI2qKTD9
        ddobAcPgPZqn0WXGYMuVqL366v2EryD/D/1llivLUtnzn02jeje2GDuJLNm3kQTS4xLg937RvVyHm
        VwU6Epnw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltNz2-007d0P-4y; Wed, 16 Jun 2021 05:21:05 +0000
Date:   Wed, 16 Jun 2021 06:21:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pv-drivers@vmware.com, doshir@vmware.com
Subject: Re: [PATCH] vmxnet3: prevent building with 256K pages
Message-ID: <YMmKPIEk6XQsXq9T@infradead.org>
References: <20210615123504.547106-1-mpe@ellerman.id.au>
 <76ccb9fc-dc43-46e1-6465-637b72253385@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ccb9fc-dc43-46e1-6465-637b72253385@csgroup.eu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 02:41:34PM +0200, Christophe Leroy wrote:
> Maybe we should also exclude hexagon, same as my patch on BTRFS https://patchwork.ozlabs.org/project/linuxppc-dev/patch/a16c31f3caf448dda5d9315e056585b6fafc22c5.1623302442.git.christophe.leroy@csgroup.eu/

Maybe we really need common config symbols for the page size instead of
all these hacks..
