Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A91B52B6
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgDWCyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWCyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:54:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB141C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:54:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB154127AFC4F;
        Wed, 22 Apr 2020 19:54:16 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:54:15 -0700 (PDT)
Message-Id: <20200422.195415.1693834195593514712.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mrv@mojatatu.com
Subject: Re: [PATCH net-next 0/2] Add selftests for pedit ex munge ip6
 dsfield
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422164830.19339-1-petrm@mellanox.com>
References: <20200422164830.19339-1-petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:54:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Wed, 22 Apr 2020 19:48:28 +0300

> Patch #1 extends the existing generic forwarding selftests to cover pedit
> ex munge ip6 traffic_class as well. Patch #2 adds TDC test coverage.

Series applied, thanky ou.
