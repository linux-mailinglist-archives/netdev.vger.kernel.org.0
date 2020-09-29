Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8FA27D9DE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgI2VWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgI2VWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:22:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12F1C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:22:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEED411E48E22;
        Tue, 29 Sep 2020 14:05:29 -0700 (PDT)
Date:   Tue, 29 Sep 2020 14:22:16 -0700 (PDT)
Message-Id: <20200929.142216.862070318231684318.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH net 1/1] MAINTAINERS: Update MAINTAINERS for Intel
 ethernet drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929210618.51987-1-anthony.l.nguyen@intel.com>
References: <20200929210618.51987-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 14:05:30 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Tue, 29 Sep 2020 14:06:18 -0700

> Add Jesse Brandeburg and myself; remove Jeff Kirsher.
> 
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Applied.
