Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32713277E71
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgIYDOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIYDOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:14:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75D8C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 20:14:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9F9D135F8F3E;
        Thu, 24 Sep 2020 19:57:33 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:14:20 -0700 (PDT)
Message-Id: <20200924.201420.631527074833721167.davem@davemloft.net>
To:     jamie@nuviainc.com
Cc:     netdev@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH] net/fsl: quieten expected MDIO access failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924145645.1789724-1-jamie@nuviainc.com>
References: <20200924145645.1789724-1-jamie@nuviainc.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:57:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>
Date: Thu, 24 Sep 2020 15:56:45 +0100

> MDIO reads can happen during PHY probing, and printing an error with
> dev_err can result in a large number of error messages during device
> probe.  On a platform with a serial console this can result in
> excessively long boot times in a way that looks like an infinite loop
> when multiple busses are present.  Since 0f183fd151c (net/fsl: enable
> extended scanning in xgmac_mdio) we perform more scanning so there are
> potentially more failures.
> 
> Reduce the logging level to dev_dbg which is consistent with the
> Freescale enetc driver.
> 
> Cc: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Jamie Iles <jamie@nuviainc.com>

Applied, thank you.
