Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E437A483D3C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiADHxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiADHxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:53:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC64AC061761;
        Mon,  3 Jan 2022 23:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5PWaYW/OkT7Anqvi+DI48etTN6eiDX29uzAqA4c4wt8=; b=u94E3xAMya2C8ycWHi96lgca/w
        mr/quhdazQLTasd2H7ZAcRyN3U+xSDLbOsr2ZTh323HieZjeEK3ZwULbtBpO7Vnl6TP0EqL60h5ER
        dc6xDKBebDh9KZ1wTh7TaVoW+eAIOlssoheYG/VVZuud1fesmt8LROwXIXJvilmp/JVAZqCFsfqtL
        W3J+s6rfbCWkaQaE6f7ckmmXl3c+SGBe3sLRFXH/DIdaC/fivTD/ZWLqM9R/xQiR22uFXufq3x9z1
        F07hkMVP3GtHntZNokxTA9dau0iMFBOCz7zVr7d4O8NSRaC/xN9x8EhEKutyG6QkFIcSQdZ7ikXcE
        oGp3pNwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4ed2-00AZBN-G0; Tue, 04 Jan 2022 07:53:08 +0000
Date:   Mon, 3 Jan 2022 23:53:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] intel: Simplify DMA setting
Message-ID: <YdP85Lj/vCdSVDg7@infradead.org>
References: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although normally I'd expect one patch per driver.
