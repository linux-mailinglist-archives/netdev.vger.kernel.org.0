Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A12E230
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 14:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfD2MWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 08:22:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfD2MWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 08:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xl4MrYPDmF4P7eoHhj1V5OKIKtqTlTb2zUS6E3j/D/k=; b=urzXn1TjNfhZgYIXvoNGdwcEL4
        t32R7kXmkyDSDQ8U38vmgrR+PE3OEpsGs2J1p8qyU84uSDRMwJp4FZOCpIdDSVXWvMsDoT0+2JP2z
        XNYcto0rN83HQx8dovrIibRYuZiernalkybiVBLziDtJ4OVr90Gvho1ip9OXiRTryUyGidMlj7Kbv
        BkEwJrkIRessWqBBV40J+H7O5zd8oGPLTfKDWUwzoDo8wjTuHo4Sd8Q12kPlasjjsUM1hELMZ8n0/
        U7mTMPPQKj2Pu/Bopf53s0bWYZQJQKNBMgwLYhVlOLWfwrfJsQzL5lx0ACoA2NoJTUE78c4EzZlle
        bpg2Kz8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hL5IQ-0001hq-Mt; Mon, 29 Apr 2019 12:22:10 +0000
Date:   Mon, 29 Apr 2019 05:22:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Nicholas Mc Guire <der.herr@hofr.at>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rds: ib: force endiannes annotation
Message-ID: <20190429122210.GB32474@infradead.org>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
 <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
 <20190429111836.GA17830@osadl.at>
 <2ffed5fc-a372-3f90-e655-bcbc740eed33@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ffed5fc-a372-3f90-e655-bcbc740eed33@solarflare.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 01:02:31PM +0100, Edward Cree wrote:
> ... are some bitwise ops on the values (bitwise ops are legal in any
>  endianness) and incrementation of the pointers (which cares only about
>  the pointee size, not type).

Oh, true.  That is why the underlying annotation is called __bitwise :)
I'll take my previous comment back.
