Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3689631BAF
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKUIjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiKUIj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:39:29 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4D28E23;
        Mon, 21 Nov 2022 00:39:29 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1F9D768AA6; Mon, 21 Nov 2022 09:39:25 +0100 (CET)
Date:   Mon, 21 Nov 2022 09:39:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: stop drivers from passing GFP_COMP to dma_alloc_coherent
Message-ID: <20221121083924.GA28048@lst.de>
References: <20221113163535.884299-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113163535.884299-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've picked this up in the for-next branch of the dma-mapping tree now.
