Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E161350CC
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgAIBD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:03:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59878 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgAIBD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 20:03:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/mWM8oRP55OsjqF9FfoGCj1hXV5GCmbKiI9l/netkOE=; b=FGylA5/hwZS7JCS7ZIoNyi5t4
        S+zNXtRAWl3ABfuKkQcShbHoYNMSRgOhJnQ8YxbHo8qUsLSesyQXk0mIPlpG6IvXED+sKpnKLTcY9
        kBDBDB3CMVKY+Ju0KGwT778EWhlI+3NfBccDP2XdSWUeSwyO1hP1l6e/xtaX/wlvMDZlrQKdv4LGI
        5VIT9Q43yaC/a0DHoqbQG1c7r56eSojtk51MKqghiM86ZdxN3VZr3lAPMMIqJF6hTxebuvrNlmuup
        rWQZV9TmNLjtYqcg2+CvY+/chR/zsBsNbD0n5guteId2JEYH4Tbjww+fzAwI2/Mjw8KFszlm+vRvr
        Tj5m2p6pA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipMEi-0001wt-J0; Thu, 09 Jan 2020 01:03:44 +0000
Date:   Wed, 8 Jan 2020 17:03:44 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     yukuai3@huawei.com, klassert@kernel.org, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, netdev@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200109010344.GN6788@bombadil.infradead.org>
References: <20200106125337.40297-1-yukuai3@huawei.com>
 <20200108.124021.2097001545081493183.davem@davemloft.net>
 <20200108215929.GM6788@bombadil.infradead.org>
 <20200108.150549.1889209588136221613.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108.150549.1889209588136221613.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 03:05:49PM -0800, David Miller wrote:
> From: Matthew Wilcox <willy@infradead.org>
> Date: Wed, 8 Jan 2020 13:59:29 -0800
> 
> > This waas a mistaken version; please revert and apply v3 instead.
> 
> Are you sure?
> 
> [davem@localhost net-next]$ git show e102774588b3ac0d221ed2d03a5153e056f1354f >x.diff
> [davem@localhost net-next]$ patch -p1 -R <x.diff 
> patching file drivers/net/ethernet/3com/3c59x.c
> [davem@localhost net-next]$ mv ~/Downloads/V3-net-3com-3c59x-remove-set-but-not-used-variable-mii_reg1.patch ./
> [davem@localhost net-next]$ patch -p1 <V3-net-3com-3c59x-remove-set-but-not-used-variable-mii_reg1.patch 
> patching file drivers/net/ethernet/3com/3c59x.c
> [davem@localhost net-next]$ git diff
> [davem@localhost net-next]$
> 
> There is no difference in the code of the commit at all between V2 and V3.

v2:
-               mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);

v3:
-               mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
+               mdio_read(dev, vp->phys[0], MII_BMSR);

