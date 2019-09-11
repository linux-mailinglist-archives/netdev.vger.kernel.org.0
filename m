Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D620AF7F6
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfIKIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:30:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKIaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:30:35 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97D4015567B3E;
        Wed, 11 Sep 2019 01:30:34 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:30:33 +0200 (CEST)
Message-Id: <20190911.103033.1889508833586793614.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH] lib/Kconfig: fix OBJAGG in lib/ menu structure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <34674398-54dc-a4d1-6052-67ad1a3b2fe9@infradead.org>
References: <34674398-54dc-a4d1-6052-67ad1a3b2fe9@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:30:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 9 Sep 2019 14:54:21 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Keep the "Library routines" menu intact by moving OBJAGG into it.
> Otherwise OBJAGG is displayed/presented as an orphan in the
> various config menus.
> 
> Fixes: 0a020d416d0a ("lib: introduce initial implementation of object aggregation manager")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks Randy.
