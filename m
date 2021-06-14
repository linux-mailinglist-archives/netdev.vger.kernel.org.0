Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7053A5CA1
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhFNF6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 01:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFNF6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 01:58:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC57C061574;
        Sun, 13 Jun 2021 22:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jEUVYgEPFJL+watG0HwEmyW16yb2OMznEcroA+8PQ6E=; b=HR8ZX1vL1XkTljJLgLrRPQwnvC
        TZTiDzXT2cbFyujWrVRZpqOHxl6rys3pAhUq/Bmj4UtLhlqeXz2NfQupn8lnkbz+8UI0AposYuRRM
        E+ryW2fRyb+ssYRnHfmh01LyjoI00xeTJ7yA4y3G7wrenSH/gW1+tBQwBVWPZsYiJ+d1AszmR6fWF
        mfEv0sRAo5W3+L5mj2G3VDEyN85yGx315DO8RS0XrOipBEUp5HLCeWbCOSVBTSYmRrUZIoLAS93lF
        cgyRIevjAX6JUStrGBz6vzk43rZCsoYN/+uvGDL14iop4Zw9OvueU63AF/PaHoUcCLpKNSSTmesdf
        2B7JzKBw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfZM-0054FW-Lu; Mon, 14 Jun 2021 05:55:37 +0000
Date:   Mon, 14 Jun 2021 06:55:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH V3 5/6] PCI/IOV: Enable 10-Bit tag support for
 PCIe VF devices
Message-ID: <YMbvVD2WY/lJN/H4@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-6-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623576555-40338-6-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 05:29:14PM +0800, Dongdong Liu wrote:
> Enable VF 10-Bit Tag Requester when it's upstream component support
> 10-bit Tag Completer.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
