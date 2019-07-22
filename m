Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA670E63
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 03:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbfGWBBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 21:01:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730868AbfGWBBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 21:01:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D7CF15305034;
        Mon, 22 Jul 2019 18:01:40 -0700 (PDT)
Date:   Mon, 22 Jul 2019 13:45:58 -0700 (PDT)
Message-Id: <20190722.134558.164292247131682609.davem@davemloft.net>
To:     willy@infradead.org
Cc:     hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Convert skb_frag_t to bio_vec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722203959.GH363@bombadil.infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
        <20190712.112707.1312895410671986857.davem@davemloft.net>
        <20190722203959.GH363@bombadil.infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 18:01:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 22 Jul 2019 13:39:59 -0700

> No further feedback received, and the patches still apply cleanly to
> Linus' head.  Do you want the patch series resent, or does your workflow
> let you just pick these patches up now?

Please resend for net-next inclusion, thanks.
