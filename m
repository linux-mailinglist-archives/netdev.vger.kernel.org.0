Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E7E3AFCF8
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhFVGUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVGUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:20:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DF3C061574;
        Mon, 21 Jun 2021 23:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=sGLIc9uWYsQD89kIatkVPtBNDc
        s6KZXAzk6r1inIDiAIGVsfcoV3YTNDNypqU7w4dYfiypyZqmfRbFIRRpnFBpD1JZc2pzmT5xGoQty
        /396i8UJobVRtjrEEUPByAG/R6Y1YOf5tWAiRDF8i/HUMthb1bXKvSz8+1hOMEVFdUxc7L6belnWa
        20xLdNVvK50ObrTPBMNft4JOx5ldt8NoBl8Q2eF0B5Z9oTvoQfEX6Ox3wCDgBq09nfi+9wpcv9/V1
        K9D+BD+sAPDGTU5l7awz8L7ZEKn3tNCmIxbK7TZ16N9EzbMT0ggZRXLSdqEKJGhuKg/S+j+eyo2Rd
        UvtEg9Aw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvZjD-00DxNN-Hp; Tue, 22 Jun 2021 06:17:48 +0000
Date:   Tue, 22 Jun 2021 07:17:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V5 2/6] PCI: Use cached Device Capabilities 2 Register
Message-ID: <YNGAhwsjYTdFL0/z@infradead.org>
References: <1624271242-111890-1-git-send-email-liudongdong3@huawei.com>
 <1624271242-111890-3-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624271242-111890-3-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
