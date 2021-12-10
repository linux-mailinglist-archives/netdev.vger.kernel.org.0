Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3353647054B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhLJQKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:10:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35354 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhLJQKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:10:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B33B828A8;
        Fri, 10 Dec 2021 16:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7BFC341CB;
        Fri, 10 Dec 2021 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639152397;
        bh=FXw+X46FJDb+N51VzNwvo7FkfBLgll06tDuKFIWiAV0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CRRz8zGClKmgOpis4VREWosgQ3KDQ1bMgLt3BMq4djfEXY1Lw29XJjI1TD+3RYW6T
         DWwEj6g0EQ1A2tMCDn5DEWKY6qaD6ghFREUXDTdcfnFOyvUf3DOE1VTt8zNleCNUvr
         ckRXVfIJ/ciuy86csJXUUznPt/qu+lIDexEfLHiglefLAf1fgacgh6yWTFCWENdKOl
         572pSPCJa3n+0A2cJD744xG3USskICgA8fOuLNPrP+KsBEkOfd+sKb/HfeyJBLBNLl
         SKHZ2Q6wKBMpRB/juSOZNur8AfIZ0os9ca7sZ3XGJUgFka5ItAtaEo1gfMswuaff6t
         t1I+XBuojp7Bg==
Date:   Fri, 10 Dec 2021 08:06:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: stmmac: bump tc when get
 underflow error from DMA descriptor
Message-ID: <20211210080636.3c1ab98f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB57852B80794A0B487167D3A2F0719@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
        <VI1PR04MB68009F16CAA80DCEBFA8F170E6709@VI1PR04MB6800.eurprd04.prod.outlook.com>
        <20211209184123.63117f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB57852B80794A0B487167D3A2F0719@DB8PR04MB5785.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 03:11:16 +0000 Xiaoliang Yang wrote:
> > > 5 queues with FIFO cut-through mode can work well after applying this patch.
> > 
> > This never worked, correct? It's not a regression fix?  
>
> Yes, it's never worked when the underflow error is observed in the
> case of NFS boot on i.mx8mp. I'm not sure if other SoC have same
> issue in this case, but I think it's necessary to increase the
> threshold value in case of underflow error.

Oh, so NFS boot works for the most part on i.mx8mp but under certain
conditions (or with certain configuration?) this error can be observed 
and the boot will fail?

> Do you mean that I need to send the patch as a bug fix to net branch?

Your call, if you would like for the patch to go to stable and LTS
releases -- then it need to be resent for net with a Fixes tag.

LMK if you prefer net or net-next.
