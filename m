Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8E3A5C99
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhFNFxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 01:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbhFNFxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 01:53:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8284EC061756;
        Sun, 13 Jun 2021 22:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=J/ZryCn2YaIW172I0MC/9PL20o
        gl7mMXm5UiCT3KZCJWRJ1zBvCvfRnPO6sAcDv5HMGH5hgwor7GPH+0lZeAPiFvpUA0LzqVJPeNRP6
        dZKqq9dHayxLl7D34p/WSlevFolWLI5UisGodlILwCbmBH9P/NN0QDXD4PL31ry5lH1uRoYBZP3xO
        NAbIf/09Fvoo6YKTJKwo9cVptEJXOA4SY6j+2vxUlXVhAQbWHwfE0/XNN3WgNgPBzfx8whJ5ZT9wK
        UHtlEB/VtwrAeb9iMkjfoY1+mjvqmVRd9HyG6gYhOvZDNGxED3wC7hMGFguBZT35MBqB4esmfF9dc
        giIICKzQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfUm-00544p-S0; Mon, 14 Jun 2021 05:50:55 +0000
Date:   Mon, 14 Jun 2021 06:50:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH V3 3/6] PCI: Add 10-Bit Tag register definitions
Message-ID: <YMbuOJc5aTlq4X91@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-4-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623576555-40338-4-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
