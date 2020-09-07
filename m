Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F5125F2CE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 07:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgIGFtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 01:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgIGFsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 01:48:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA11C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 22:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wDv1D2Q60PKZXexDOzlHfJ+fHjyjHvnYvWlWf1YGsD0=; b=vaAaNB9qxk1sEddwYZJk6h0DC4
        QZlerDq6eAGcE63kCaDL8Z44DR646Hex8UnhxKKmaQm6/6khw7eFrBF9vbKw63XNbHJtBRRxCcedV
        TgcrO/iTjJc3dZ+gnN781vT0JvTZixz/vQX63LpY33bt2tmI+jeDeJWIvGAJ73L1aM1wULVmZ0aTV
        ey015daLLOaHHg8iK5CAWv+GamOVUCU4RVVpZSht1VWExoDGu0OZrYXan3Vbv4RLcU6gjdROcximW
        tqkS48sdd7SuZliYOPxdAnb48qIKEGJLDcBNfy9ai2p8IqbnCaL9TdFUXxb9krWvG1fcHLr2Fh25h
        vQr7ldIQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFA16-0002W3-KB; Mon, 07 Sep 2020 05:48:36 +0000
Date:   Mon, 7 Sep 2020 06:48:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes a
 socket
Message-ID: <20200907054836.GA8956@infradead.org>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 04:05:48PM -0600, Jens Axboe wrote:
> There's a trivial io_uring patch that depends on this one. If this one
> is acceptable to you, I'd like to queue it up in the io_uring branch for
> 5.10.

Can you give it a better name?  These __ names re just horrible.
sock_shutdown_sock?
