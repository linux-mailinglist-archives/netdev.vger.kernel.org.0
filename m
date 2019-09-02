Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5FBA5C89
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 21:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfIBTIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 15:08:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfIBTIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 15:08:11 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 256A415404E44;
        Mon,  2 Sep 2019 12:08:10 -0700 (PDT)
Date:   Mon, 02 Sep 2019 12:08:09 -0700 (PDT)
Message-Id: <20190902.120809.714564690159194501.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.chevallier@bootlin.com, mw@semihalf.com,
        antoine.tenart@bootlin.com, stefanc@marvell.com,
        nadavh@marvell.com, lorenzo@kernel.org
Subject: Re: [PATCH net-next 0/2] mvpp2: per-cpu buffers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902102137.841-1-mcroce@redhat.com>
References: <20190902102137.841-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 12:08:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Mon,  2 Sep 2019 12:21:35 +0200

> This patchset workarounds an PP2 HW limitation which prevents to use
> per-cpu rx buffers.
> The first patch is just a refactor to prepare for the second one.
> The second one allocates percpu buffers if the following conditions are met:
> - CPU number is less or equal 4
> - no port is using jumbo frames
> 
> If the following conditions are not met at load time, of jumbo frame is enabled
> later on, the shared allocation is reverted.

Series applied to net-next.
