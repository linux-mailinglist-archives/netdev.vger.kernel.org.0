Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3263196DF8
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfHTX6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:58:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfHTX6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 19:58:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E7C814B4DFDE;
        Tue, 20 Aug 2019 16:58:35 -0700 (PDT)
Date:   Tue, 20 Aug 2019 16:58:34 -0700 (PDT)
Message-Id: <20190820.165834.1420751898749952901.davem@davemloft.net>
To:     willy@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820223259.22348-30-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
        <20190820223259.22348-30-willy@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 16:58:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 20 Aug 2019 15:32:50 -0700

> -		idr_replace(&head->handle_idr, fnew, fnew->handle);
> +		xa_store(&head->filters, fnew->handle, fnew, 0);

Passing a gfp_t of zero? :-)
