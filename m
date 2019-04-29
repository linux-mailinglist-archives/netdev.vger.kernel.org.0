Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC9E225
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 14:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfD2MVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 08:21:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbfD2MVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 08:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OXXckRwCsZ5XP7UWBMHy7IbjoWzh65OQAJgbJO4qalI=; b=VzbCzMLsY5hN3cmDv22acszba
        6Iymep9wfJQ4OjZyS9Nzj2DhxVGhwwH+Ap24b4+Jk8ORVR+PYYUVHCB9ri+ou2g1g/SD1WOrKu5L2
        uTgN4o6jdHlpT5s9LZcZDldV/pTkKyMOKeSFrR69wSZkt4Fq2YGTl14SgUsWb6z6b5ccbdxurvMuW
        bAR+7Q8wYIp4fdK6JW4k5mEKoZdJWAfnMb8C7iY+wOEag6hiGkZi839FMnTItGwJEuTIm/TZW7wWN
        sOYxRvpaYPyVuA5tiFQuYsIy61lowKUctie8vzCBCkb1SMwkZG2LqKZgsVci4MOUSxnDV3UB/Osl7
        7U5sR9YLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hL5Ho-0001el-Hu; Mon, 29 Apr 2019 12:21:32 +0000
Date:   Mon, 29 Apr 2019 05:21:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nicholas Mc Guire <der.herr@hofr.at>
Cc:     Edward Cree <ecree@solarflare.com>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rds: ib: force endiannes annotation
Message-ID: <20190429122132.GA32474@infradead.org>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
 <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
 <20190429111836.GA17830@osadl.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429111836.GA17830@osadl.at>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 01:18:36PM +0200, Nicholas Mc Guire wrote:
> changing uncongested to __le64 is not an option here - it would only move
> the sparse warnings to those other locatoins where the ports that 
> became uncongested are being or'ed into uncongested.

Than fix that a well.  Either by throwing in a conversion, or
add {be,le}XX_{and,or} helpers.
