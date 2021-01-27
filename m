Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DBA30631C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhA0SUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhA0SUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:20:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694C3C061574;
        Wed, 27 Jan 2021 10:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D3TJPgrJ5YshgHkFrIwWuRkV9IuWlSNDimvPxh+E1UM=; b=Xopkea3EtCLVU4AOI8ULGtFPKE
        mu7R4khUDvkoD508Ng/zaiUJSdi+QAGEzyBrFrR8fuV2uV0kTrrBVD3BxlQfsrYQslQDZVpsDei5e
        RInsFUo+YdX7/upI33IXwmOsVyMk3c4/ntwMKtv3d+5qxs619rcLwbrcG4bE0VLDiWxASWGWWhfZT
        T5x+GE9XQMTFJ+kiLWYVN08/eJn9mUY28OnjlS0eKDbvMrF+4hVdE5bxYplwP018wWiiwO1P5UGRk
        uXyR5wDqs3a2r+d0CHMvVp6Q1Ky4N8mBgREUz2w9pyVvgS/Oe+A/GTFIMTvZfuISduQnlNgzEDbiv
        gKBmamdQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4pPn-007LBQ-Su; Wed, 27 Jan 2021 18:19:41 +0000
Date:   Wed, 27 Jan 2021 18:19:39 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/4] remove compat_alloc_user_space()
Message-ID: <20210127181939.GA1749574@infradead.org>
References: <20201124151828.169152-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124151828.169152-1-arnd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just curious: what is the status of the various compat_alloc_user_space
removal patches?  It would be great to kill the function off for good.
