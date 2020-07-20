Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C4225536
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGTBOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgGTBOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:14:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6AAC0619D2;
        Sun, 19 Jul 2020 18:14:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 986491284AF4D;
        Sun, 19 Jul 2020 18:14:35 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:14:34 -0700 (PDT)
Message-Id: <20200719.181434.2176745106414380735.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: atm: lec_arpc.h: delete duplicated word
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200719180801.11913-1-rdunlap@infradead.org>
References: <20200719180801.11913-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:14:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 19 Jul 2020 11:08:01 -0700

> Delete the doubled word "the" in a comment.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied to net-next.
