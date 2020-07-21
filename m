Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927F9228CAE
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgGUXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUXYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:24:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76961C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:24:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37B9311E45901;
        Tue, 21 Jul 2020 16:07:38 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:24:22 -0700 (PDT)
Message-Id: <20200721.162422.2081293958584509335.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: add support for TBF offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721163825.9462-1-ioana.ciornei@nxp.com>
References: <20200721163825.9462-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 16:07:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Tue, 21 Jul 2020 19:38:22 +0300

> This patch set adds support for TBF offload in dpaa2-eth.
> The first patch restructures how the .ndo_setup_tc() callback is
> implemented (each Qdisc is treated in a separate function), the second
> patch just adds the necessary APIs for configuring the Tx shaper and the
> last one is handling TC_SETUP_QDISC_TBF and configures as requested the
> shaper.

Series applied, thanks.
