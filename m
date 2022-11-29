Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BCD63C199
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiK2OAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiK2OAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:00:41 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB882AC5C;
        Tue, 29 Nov 2022 06:00:41 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BDAA6732D; Tue, 29 Nov 2022 15:00:35 +0100 (CET)
Date:   Tue, 29 Nov 2022 15:00:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>
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
Subject: Re: [PATCH 1/7] media: videobuf-dma-contig: use dma_mmap_coherent
Message-ID: <20221129140034.GA15560@lst.de>
References: <20221113163535.884299-1-hch@lst.de> <20221113163535.884299-2-hch@lst.de> <95cf026d-b37c-0b89-881a-325756645dae@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95cf026d-b37c-0b89-881a-325756645dae@xs4all.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 03:10:43PM +0100, Hans Verkuil wrote:
> Very, very old code :-) Hopefully in the not-too-distant future we can kill off
> the old videobuf framework.

That would be great for various reasons.

> But for now:
> 
> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> I assume you take this? If not, then let me know and I will pick it up for the media
> subsystem.

I've actually picked it up a while ago.  So without a reabse I can't
add your formal ACK, but I hope Linus is fine with that.
