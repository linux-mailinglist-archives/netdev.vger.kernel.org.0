Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5455E786E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbfJ1SbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:31:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfJ1SbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:31:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AD0F14990E77;
        Mon, 28 Oct 2019 11:31:04 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:31:03 -0700 (PDT)
Message-Id: <20191028.113103.1377557829145109822.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-nex V2 0/3] page_pool: API for numa node change
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023193632.26917-1-saeedm@mellanox.com>
References: <20191023193632.26917-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 11:31:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jesper has given you feedback asking you to show him the code which was
used to disable the mlx5e page cache during your testing of patch #2.

It's been 5 days since he asked for that simple thing, and I haven't
seen a reply yet.

Therefore I am tossing this series.

Please repost after you've worked things out with Jesper.

Thanks.
