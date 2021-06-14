Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621BC3A5C8E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhFNFwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 01:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhFNFwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 01:52:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E3CC061574;
        Sun, 13 Jun 2021 22:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cRGwSxQF9rL7/z4W4kadPyPPQxWQDJw1aSVOOE037fM=; b=TQq68SZUCOA+gqEbGQmoYVNOwK
        Hk4gfD0h/2W7VjZ7grHaH7D8SQmq4GtQLcGaRzRdNKMx+o5OhKhZl1LAiNB2h88GGVNdDVfVM1ZuK
        Unyoe0ElPPCfD5g5JEJ/OffYCBh8og65gpQ2+kjhlrH0odb/vpmjxOLuTraQFkumjOj2/rWYKKOiB
        WOPXGXZJaG2eHVK2HeTxjPxg0fPDN0fHW7dCjzpe5JD3yKnNm3MjKYD6hSr81/OWFVo7xb84WohWI
        byebFddvB9xhh1vjnYI6yUUylQChrcMpCsZ28j0oMFyHAK65KITaZjda3o1tlPszlftkqTJCcbdVQ
        1Pl6eMKg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfTX-005409-Gt; Mon, 14 Jun 2021 05:49:33 +0000
Date:   Mon, 14 Jun 2021 06:49:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH V3 2/6] PCI: Use cached Device Capabilities 2
 Register
Message-ID: <YMbt6699/6r85MYy@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-3-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623576555-40338-3-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +			if (!(bridge->pcie_devcap2 & PCI_EXP_DEVCAP2_ATOMIC_ROUTE))

Overly long line.

> +static void pci_init_devcap2(struct pci_dev *dev)
> +{
> +	if (!pci_is_pcie(dev))
> +		return;
> +
> +	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP2, &dev->pcie_devcap2);
> +}

Wouldn't it make sene to merge this into set_pcie_port_type?
