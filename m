Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062F9631B98
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKUIhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKUIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:37:13 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D931F2FE;
        Mon, 21 Nov 2022 00:37:12 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CDDBA68AA6; Mon, 21 Nov 2022 09:37:07 +0100 (CET)
Date:   Mon, 21 Nov 2022 09:37:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 6/7] ALSA: memalloc: don't pass bogus GFP_ flags to
 dma_alloc_*
Message-ID: <20221121083707.GA27649@lst.de>
References: <20221113163535.884299-1-hch@lst.de> <20221113163535.884299-7-hch@lst.de> <87leod52l6.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87leod52l6.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 10:04:37AM +0100, Takashi Iwai wrote:
> It mentions something about sparc32/64.  I hope this isn't relevant
> any longer (honestly I have no idea about that).

It shouldn't.  sparc is using fairly generic code now.
