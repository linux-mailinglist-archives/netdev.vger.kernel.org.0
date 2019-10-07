Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF11CE64E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJGPAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:00:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGPAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=durQ/zIFS+d7BPv+c4GQQ5x/qr95LXTfrUb9U1/mljA=; b=BUH6xrb6tYI919QXCcEWKU2+t
        qBCgtnESE5DuMl9Zl9hKF7kF4HSIQ55yJCHrVZih7d6eFGHHByZyjg0mErqoB4M5aVkTaHb9UMWDl
        hE8tp6q72xQjUKE2V6nXU8Hlmej20kafZ8Ub0zuvWKeNbQd8FfFP1jhHVPmO8C/yOsCfSeW/tJTAk
        5ImFwh4iDyK6+ZMXr/gFdXeW2wK08oIWb4V2twuNI0h1lel0XcGDIJlgy0x2yMQDiOg7LSugE5MXW
        L/CnCggpvWyOUIYaPZxp0rzXlvpv4TpPYgE0O7B/OvtWWdvSoaJWQYmQyGgPt/qHiRCrwT8UOYqqd
        /UHryC6mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHUV7-0002nk-7M; Mon, 07 Oct 2019 15:00:41 +0000
Date:   Mon, 7 Oct 2019 08:00:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007150041.GA3702@infradead.org>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007135933.12483-3-leon@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>   */
> +
>  static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,

Same like an empty line sneaked in here.  Except for that the whole
series looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
