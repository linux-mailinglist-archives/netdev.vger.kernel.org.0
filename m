Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E92261FF2
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgIHUIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730319AbgIHPTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:19:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A111C0619C9
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ETX2yXbRY3IvsR50vh7vJ5kYFrtPZYtnNrVGt3+FuVo=; b=XA1oBo4ELAL3/n9SjwPkSk3nPC
        e3eDguGaqFtwbGwXEcTWYfRdIHG2Pw20hoX73WecOs/pcVvFNGLlJLGZoXZokxcm55jUr7AqXY6py
        hDW9zRjfIWwV921FuWamrCrDTEHdkkDDXMxWwyPV82sUfu1RCNCV38VLNIXdBB6DVk+XZkObpnCpa
        J0gUuZgmIRPPhZmpoFx/TZrKemJbw/32pLNTtFnyE6BtpAuemJkPcVdIXrodgNuB11bCcNyG/g88r
        UKKGN+a2fW9DLyP07yF84PGOh2YEZvInQS6S7xEJxycMySvgIyh/W8bjcGX+qYi1zigP8QTPVHgbu
        piaZycKQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFfJ4-00046Y-5c; Tue, 08 Sep 2020 15:13:14 +0000
Date:   Tue, 8 Sep 2020 16:13:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-net-drivers@solarflare.com, davem@davemloft.net,
        netdev@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH net-next 6/6] sfc: simplify DMA mask setting
Message-ID: <20200908151314.GA15543@infradead.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
 <3140001a-66eb-b770-e7b8-c5be71dbd41b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3140001a-66eb-b770-e7b8-c5be71dbd41b@solarflare.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 05:15:48PM +0100, Edward Cree wrote:
> Christoph says[1] that dma_set_mask_and_coherent() is smart enough to
>  truncate the mask itself if it's too long.  So we can get rid of our
>  "lop off one bit and retry" loop in efx_init_io().
> 
> [1]: https://www.spinics.net/lists/netdev/msg677266.html
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
