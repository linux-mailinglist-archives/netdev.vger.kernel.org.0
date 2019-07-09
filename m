Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE7462EA7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfGIDRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:17:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfGIDRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:17:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAF1513408B29;
        Mon,  8 Jul 2019 20:17:08 -0700 (PDT)
Date:   Mon, 08 Jul 2019 20:17:08 -0700 (PDT)
Message-Id: <20190708.201708.1951328081226207691.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net-next 0/4] sctp: tidy up some ep and asoc feature
 flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 20:17:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  9 Jul 2019 00:57:03 +0800

> This patchset is to remove some unnecessary feature flags from
> sctp_assocation and move some others to the right places.

Since I'm trying to close up the net-next tree first thing tomorrow morning
I've taken the liberty of reviewing this the best that I can and it looks
good.

Series applied, thanks Xin.
