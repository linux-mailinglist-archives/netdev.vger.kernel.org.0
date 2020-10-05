Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A7F2832BF
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgJEJGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEJGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 05:06:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E59C0613CE;
        Mon,  5 Oct 2020 02:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1EF6wluHXZZQbxxruHBZVKhSsdB86bW7HId3ixl01Rk=; b=okIq3TOU7DG3KHaA2nyw2+GMvt
        BHJG2zTD8SgJRhe6+zMtODQXFTUA10m9pOAyVUZ8W1Fzml6ffOkjIDPqFektiyR37gXZkOgGfw2Ta
        KloIHuhETHt/Hu8pjcRrQ7jkfxrLLUgpscRMv+j2ISQ5YKwwmOqnRFZAsgx2Z/rXSYdAPHg60L6VK
        d18MPg9DRi4iqA1iLG/pVUTZQql4PUu0kqew++P20VNmkwqDZ/hHngabX2UB3tg5h19xfIRv2/ht7
        tltC/EeQ0f6x9udK69PgKox3+CIFzY2RH7Mxgbn/gp/ctpLc++sSeKPAZEp3vhHE+qI+5G5rB6nCE
        bjeDAXuA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPMRb-0002Zq-Np; Mon, 05 Oct 2020 09:06:07 +0000
Date:   Mon, 5 Oct 2020 10:06:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bj??rn T??pel <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, Bj??rn T??pel <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        hch@infradead.org
Subject: Re: [PATCH bpf-next] xsk: remove internal DMA headers
Message-ID: <20201005090607.GA6771@infradead.org>
References: <20201005090525.116689-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005090525.116689-1-bjorn.topel@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 11:05:25AM +0200, Bj??rn T??pel wrote:
> From: Bj??rn T??pel <bjorn.topel@intel.com>
> 
> Christoph Hellwig correctly pointed out [1] that the AF_XDP core was
> pointlessly including internal headers. Let us remove those includes.
> 
> [1] https://lore.kernel.org/bpf/20201005084341.GA3224@infradead.org/
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
> Signed-off-by: Bj??rn T??pel <bjorn.topel@intel.com>

Thanks:

Acked-by: Christoph Hellwig <hch@lst.de>
