Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2481E20D4C8
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgF2TLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:11:39 -0400
Received: from verein.lst.de ([213.95.11.211]:59074 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbgF2TLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 590416736F; Mon, 29 Jun 2020 16:22:25 +0200 (CEST)
Date:   Mon, 29 Jun 2020 16:22:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: add an API to check if a streamming mapping needs sync calls
Message-ID: <20200629142225.GA22336@lst.de>
References: <20200629130359.2690853-1-hch@lst.de> <b97104e1-433c-8e35-59c6-b4dad047464c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b97104e1-433c-8e35-59c6-b4dad047464c@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 03:39:01PM +0200, Björn Töpel wrote:
> On 2020-06-29 15:03, Christoph Hellwig wrote:
>> Hi all,
>>
>> this series lifts the somewhat hacky checks in the XSK code if a DMA
>> streaming mapping needs dma_sync_single_for_{device,cpu} calls to the
>> DMA API.
>>
>
> Thanks a lot for working on, and fixing this, Christoph!
>
> I took the series for a spin, and there are (obviously) no performance
> regressions.
>
> Would the patches go through the net/bpf trees or somewhere else?

either the net tree or (my) dma-mapping tree would be fine with me.
