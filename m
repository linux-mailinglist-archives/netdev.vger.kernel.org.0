Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE7D0872
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfJIHj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:39:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48254 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIHj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=baiVv4a2Uea2yTZJrebYsEwZaUn70mxXYupOEm3dQbc=; b=qRZLYML8fZIGPOUFVit/FLmvx
        qgVXvUHJYoCdC+71GLaypG+EIWHXjTQXPpbTF2mxm9WrpMRbP6OJRVJWjFgaiaW/llFXBOJAR78Vs
        9Q+px+8LlW9mqzCJImURq9QaryTQdwKGtD4cnbhbuoFslmYUkQs3Extmb7giDPFCEMrtrUyQAPIWT
        sU9OIgrOfYqTm+AVwzxif+67dDyGiyPrTbb8IxwoQhmR1hy8v0P9oxWmwhhPGm4qq+NDnM38pGTbc
        9xdXEex2JMqcg6uVZDb36+pDd/1yMHL7h5UhJzoV1OSxImjVtAOzjkWdN4KrKTazYF5G4uilXa9hW
        0Qgz+JOTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI6ZC-0006WF-Mu; Wed, 09 Oct 2019 07:39:26 +0000
Date:   Wed, 9 Oct 2019 00:39:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, roy.pledge@nxp.com,
        laurentiu.tudor@nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
Message-ID: <20191009073926.GA6916@infradead.org>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
 <1570536641-25104-20-git-send-email-madalin.bucur@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570536641-25104-20-git-send-email-madalin.bucur@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 03:10:40PM +0300, Madalin Bucur wrote:
> Centralize the phys_to_virt() calls.

You don't need to centralize those, you need to fix them.  Calling
phys_to_virt on a dma_addr is completely bogus.
