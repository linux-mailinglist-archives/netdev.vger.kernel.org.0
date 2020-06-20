Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CE9201FFF
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbgFTDBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732074AbgFTDBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:01:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605FAC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:01:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 080D412784D1C;
        Fri, 19 Jun 2020 20:01:05 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:01:04 -0700 (PDT)
Message-Id: <20200619.200104.1278955853906768485.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] enetc: Fix HW_VLAN_CTAG_TX|RX toggling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592471812-13035-1-git-send-email-claudiu.manoil@nxp.com>
References: <1592471812-13035-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:01:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Thu, 18 Jun 2020 12:16:52 +0300

> VLAN tag insertion/extraction offload is correctly
> activated at probe time but deactivation of this feature
> (i.e. via ethtool) is broken.  Toggling works only for
> Tx/Rx ring 0 of a PF, and is ignored for the other rings,
> including the VF rings.
> To fix this, the existing VLAN offload toggling code
> was extended to all the rings assigned to a netdevice,
> instead of the default ring 0 (likely a leftover from the
> early validation days of this feature).  And the code was
> moved to the common set_features() function to fix toggling
> for the VF driver too.
> 
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied and queued up for -stable, thanks.
