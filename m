Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CD0B7853
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbfISLVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:21:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfISLVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:21:49 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC62C154FB2D4;
        Thu, 19 Sep 2019 04:21:48 -0700 (PDT)
Date:   Thu, 19 Sep 2019 13:21:47 +0200 (CEST)
Message-Id: <20190919.132147.31804711876075453.davem@davemloft.net>
To:     paulb@mellanox.com
CC:     netdev@vger.kernel.org
Subject: CONFIG_NET_TC_SKB_EXT
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 04:21:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


As Linus pointed out, the Kconfig logic for CONFIG_NET_TC_SKB_EXT
is really not acceptable.

It should not be enabled by default at all.

Instead the actual users should turn it on or depend upon it, which in
this case seems to be OVS.

Please fix this, thank you.
