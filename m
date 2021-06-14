Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D633A5C9D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhFNF5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 01:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhFNF5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 01:57:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A1CC061574;
        Sun, 13 Jun 2021 22:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b/VCSDcG/G4Bq3256bAnQ0T8CHGeUw7BS7HwOPKZqNA=; b=fdwZ7BbveuLg6fX6xzT/z1xouy
        3xIcnoIl42lxCSDd5DwN8keMLIL+TEwjMSy4wNISHDRM4e8sVoSwZmLSfyX9o9IBKpJI/pxcCw/Ph
        R2/rKIAy1dOlmeDn1hrMX/GgO7SYdNN0nJr5AHZ/5z0wEb2+/t0BiMmEo3AIOckXxugYtwWFN5VTS
        H6g1tybNCVwbf8474hP0Zsxjfh8DjzJ+9qgZ/e9JNPDU8M9rd1aOshKGJtKzb+lxGwkuBvRwKFCE/
        q0jRVLOxaqxo32gRf+FFf/C3gsOnj3bkVw6aegeOPvB5LDNc3z9QjbcZO4OvvrXwOCLgUJTl/nQzR
        +k0R9f7w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfYP-0054DF-2q; Mon, 14 Jun 2021 05:54:41 +0000
Date:   Mon, 14 Jun 2021 06:54:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH V3 4/6] PCI: Enable 10-Bit tag support for PCIe
 Endpoint devices
Message-ID: <YMbvGYR/pAMwKMbB@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-5-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623576555-40338-5-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 05:29:13PM +0800, Dongdong Liu wrote:
> +static void pci_configure_10bit_tags(struct pci_dev *dev)
> +{
> +	struct pci_dev *bridge;
> +
> +	if (!pci_is_pcie(dev))
> +		return;
> +
> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
> +		return;

Doesn't the second check imply the first one?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
