Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AE25D6D7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfGBTXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:23:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBTXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:23:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7AB2E13C4F731;
        Tue,  2 Jul 2019 12:23:30 -0700 (PDT)
Date:   Tue, 02 Jul 2019 12:23:29 -0700 (PDT)
Message-Id: <20190702.122329.529953597219619097.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next 1/1] qed: Add support for Timestamping the
 unicast PTP packets.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702150412.31132-1-skalluru@marvell.com>
References: <20190702150412.31132-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 12:23:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Tue, 2 Jul 2019 08:04:12 -0700

> The register definition in the header file captures more details on
> the individual bits.

Where is this register definition in the header file and why aren't
CPP defines from there being used instead of a mask constant mask?

Thanks.
