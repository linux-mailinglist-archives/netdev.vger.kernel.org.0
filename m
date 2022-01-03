Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A23483126
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 13:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiACMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 07:53:24 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:49007 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229514AbiACMxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 07:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641214399;
        bh=5UnHtZFJgrqLBAR8Hrb/PgFy4iZk/U0MY7LdjigH0ic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=wKwUpR5EbNhjAaKsQSA4S9mT6NU8YGcUsWl9ElTUbyEicYpjXqf+NjatrPYzctXSU
         R0k6pEiCk3G1rGwDd2s4tZfRC8icf6F1DpCq5krBfEF+1iAc4/CdDuK1UXxFj92lFW
         jlw44Dz7zCSMEx1yy4Hg4bvEAg/iBHsa9/dGCsyI=
Received: from localhost ([119.33.249.242])
        by newxmesmtplogicsvrszc7.qq.com (NewEsmtp) with SMTP
        id 559874A7; Mon, 03 Jan 2022 20:21:25 +0800
X-QQ-mid: xmsmtpt1641212485tv9xhm9b7
Message-ID: <tencent_E30BB769A8609EADCF03F1FDA7C0AF146205@qq.com>
X-QQ-XMAILINFO: MFX4IRS9whvrf5HDZtuPh7vVui8uydB0fUmSNFEih2xKoZzCct6DBpCCwi9U2w
         hTq++kehHUe32B8lLEm6hnJ5slUnK2CIMU9evNbEEM5u6HPwecQD3y1OyR7Nx27tRlHGyCzAU/6O
         u2nvF9t4VkyQJjqkOazznSk8emzw4MW+/dL3Z8aG9DvNxG0pmEEk9rRJqapoqSCyBOMXNTGMHYTS
         Bc90UB+q8/D4XhthBihZ7fLhjiWzrCVM0hBm0VietBwSmznC9C37jTa4aL5mJbRUzn0hYUoz4lBI
         UBvuxxTnnNDrb55SXRo/29/9Khn1FsBAnd4aLA8nPaltO7mutkLakW2KzPecG9YxJ+5z1uIC+7gs
         sdVhzlq6JDlE9pM0K5CgajoKCxhpkHVOLjdWxCA3jFL9YXLWYnR/DsPk6dqMwVTsvzbg+FjneZuF
         Ja1uDckS8AjMBddLh24DEcyZb3XghcXaLB3tOTD3RBcyuj/DQ+ukkV3l39RLgFCIhUEaGPbYIBA8
         fda6QaFst4otTN2rs8ruX39SKSC7RzFvS6uy5vjrS8fqiYz+/XqJX0l/lNJv/QWVdl6UbeoxloER
         mVghavEMr7JXJMnfDSsVJpqvGHhR8PagJISXREkd9A8ky+UYyvT0IINwCUS54c9gpFi2C86//NN5
         muoHqRbt1X16Vj+bBag14xMrWR37wyX3ZuGMCOYw23+4RZsF2BKDT9h0NjPY3+1iSugtumKj9m7r
         CeF2SwAIRw2+HwICmqKUIX/1BxSqpD24Q/CLgDhx6zKOLkwdRzc1C+jKE+IRLX7mLWacj/u8H8/U
         7Og62zRksgpD8niQUgcc6jBOGRDyCW2U49eSt4Zj2fVtrEggYfpRCBe/NhPNpftuCzFe05ZJlThA
         ==
Date:   Mon, 3 Jan 2022 20:21:25 +0800
From:   Conley Lee <conleylee@foxmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
X-OQ-MSGID: <YdLqRWGsVXwBzl/3@fedora>
References: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
 <Yc7e6V9/oioEpx8c@Red>
 <tencent_57960DDC83F43DA3E0A2F47DEBAD69A4A005@qq.com>
 <YdHjK+/SzaeI/V2Q@Red>
 <tencent_67023336008FE777A58293D2D32DEFA69107@qq.com>
 <YdLhQjUTobcLq73j@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdLhQjUTobcLq73j@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/03/22 at 12:42下午, Corentin Labbe wrote:
> Date: Mon, 3 Jan 2022 12:42:58 +0100
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> To: Conley Lee <conleylee@foxmail.com>
> Cc: davem@davemloft.net, mripard@kernel.org, wens@csie.org,
>  jernej.skrabec@gmail.com, netdev@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
> 
> Le Mon, Jan 03, 2022 at 10:55:04AM +0800, Conley Lee a écrit :
> > On 01/02/22 at 06:38下午, Corentin Labbe wrote:
> > > Date: Sun, 2 Jan 2022 18:38:51 +0100
> > > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > To: Conley Lee <conleylee@foxmail.com>
> > > Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
> > >  wens@csie.org, netdev@vger.kernel.org,
> > >  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
> > >  linux-sunxi@lists.linux.dev, jernej.skrabec@gmail.com
> > > Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
> > > 
> > > Le Sat, Jan 01, 2022 at 03:09:01PM +0800, Conley Lee a écrit :
> > > > On 12/31/21 at 11:43上午, Corentin Labbe wrote:
> > > > > Date: Fri, 31 Dec 2021 11:43:53 +0100
> > > > > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > > To: conleylee@foxmail.com
> > > > > Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
> > > > >  wens@csie.org, netdev@vger.kernel.org,
> > > > >  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
> > > > > 
> > > > > Le Wed, Dec 29, 2021 at 09:43:51AM +0800, conleylee@foxmail.com a écrit :
> > > > > > From: Conley Lee <conleylee@foxmail.com>
> > > > > > 
> > > > > > Thanks for your review. Here is the new version for this patch.
> > > > > > 
> > > > > > This patch adds support for the emac rx dma present on sun4i. The emac
> > > > > > is able to move packets from rx fifo to RAM by using dma.
> > > > > > 
> > > > > > Change since v4.
> > > > > >   - rename sbk field to skb
> > > > > >   - rename alloc_emac_dma_req to emac_alloc_dma_req
> > > > > >   - using kzalloc(..., GPF_ATOMIC) in interrupt context to avoid
> > > > > >     sleeping
> > > > > >   - retry by using emac_inblk_32bit when emac_dma_inblk_32bit fails
> > > > > >   - fix some code style issues 
> > > > > > 
> > > > > > Change since v5.
> > > > > >   - fix some code style issue
> > > > > > 
> > > > > 
> > > > > Hello
> > > > > 
> > > > > I just tested this on a sun4i-a10-olinuxino-lime
> > > > > 
> > > > > I got:
> > > > > [    2.922812] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): get io resource from device: 0x1c0b000, size = 4096
> > > > > [    2.934512] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): failed to request dma channel. dma is disabled
> > > > > [    2.945740] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): configure dma failed. disable dma.
> > > > > [    2.957887] sun4i-emac 1c0b000.ethernet: eth0: at (ptrval), IRQ 19 MAC: 02:49:09:40:ab:3d
> > > > > 
> > > > > On which board did you test it and how ?
> > > > > 
> > > > > Regards
> > > > 
> > > > Sorry. I sent the email with text/html format. This email is an clean version.
> > > > 
> > > > In order to enable dma rx channel. `dmas` and `dma-names` properties
> > > > should be added to emac section in dts:
> > > > 
> > > > emac: ethernet@1c0b000 {
> > > > 	...
> > > > 	dmas = <&dma SUN4I_DMA_DEDICATED 7>;
> > > > 	dma-names = "rx";
> > > > 	...
> > > > }
> > > 
> > > Helo
> > > 
> > > Yes I figured that out. But you should have done a patch serie adding this.
> > > Your patch is now applied but it is a useless change without the dtb change.
> > > You should also probably update the driver binding (Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml) since you add new members to DT node.
> > > 
> > > Furthermore, why did you add RX only and not TX dma also ?
> > > 
> > > Probably it is too late since patch is applied but it is:
> > > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > Tested-on: sun4i-a10-olinuxino-lime
> > > 
> > > Regards
> > 
> > Thanks for your suggestion. I will submit a patch to add those changes
> > later. 
> > 
> > And the reason why I didn't add TX support is becasuse there is no any
> > public page to describe sun4i emac TX DMA register map. So, I don't known
> > how to enable TX DMA at hardware level. If you has any page or datasheet
> > about EMAC TX DMA, can you share with me ? Thanks.
> 
> Hello
> 
> You can find TX DMA info on the R40 Use manual (8.10.5.2 Register Name: EMAC_TX_MODE)
> 
> You should keep all people in CC when you answer to someone.
> 
> Regards

Haha, got it! I have been looking for the docs about emac register map
for a long time. You really help me a lot. I will submit a new patch to
add driver bidding and enable both RX and TX channels. Thanks ~
