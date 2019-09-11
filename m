Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682CDAFE77
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfIKOPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:15:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfIKOPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:15:43 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47B2315437097;
        Wed, 11 Sep 2019 07:15:42 -0700 (PDT)
Date:   Wed, 11 Sep 2019 16:15:40 +0200 (CEST)
Message-Id: <20190911.161540.47924151528319045.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next 0/2] qed* Fix series.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911114251.7013-1-skalluru@marvell.com>
References: <20190911114251.7013-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 07:15:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Wed, 11 Sep 2019 04:42:49 -0700

> The patch series addresses couple of issues in the recent commits.
> Patch (1) populates the actual dump-size of config attribute instead of
> providing a fixed size value.
> Patch(2) updates frame format of flash config buffer as required by
> management FW (MFW).
> 
> Please consider applying it to net-next.

Series applied, thanks.
