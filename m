Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA7FA2B33
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfH2XyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:54:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfH2XyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:54:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17B5F153C23DD;
        Thu, 29 Aug 2019 16:54:04 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:54:03 -0700 (PDT)
Message-Id: <20190829.165403.674137540164224492.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v3 1/3] dpaa2-eth: Remove support for changing
 link settings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567001295-31801-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567001295-31801-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 16:54:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Wed, 28 Aug 2019 17:08:13 +0300

> We only support fixed-link for now, so there is no point in
> offering users the option to change link settings via ethtool.
> 
> Functionally there is no change, since firmware prevents us from
> changing link parameters anyway.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
