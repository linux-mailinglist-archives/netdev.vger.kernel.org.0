Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4201EAF6D
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgFATEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgFATEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:04:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A73C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:04:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9B87120477C4;
        Mon,  1 Jun 2020 12:04:47 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:04:47 -0700 (PDT)
Message-Id: <20200601.120447.854770569252858004.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next v4 0/7] dpaa2-eth: add PFC support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530210814.348-1-ioana.ciornei@nxp.com>
References: <20200530210814.348-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:04:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Sun, 31 May 2020 00:08:07 +0300

> This patch set adds support for Priority Flow Control in DPAA2 Ethernet
> devices.
> 
> The first patch make the necessary changes so that multiple
> traffic classes are configured. The dequeue priority
> of the maximum 8 traffic classes is configured to be equal.
> The second patch adds a static distribution to said traffic
> classes based on the VLAN PCP field. In the future, this could be
> extended through the .setapp() DCB callback for dynamic configuration.
> 
> Also, add support for the congestion group taildrop mechanism that
> allows us to control the number of frames that can accumulate on a group
> of Rx frame queues belonging to the same traffic class.
> 
> The basic subset of the DCB ops is implemented so that the user can
> query the number of PFC capable traffic classes, their state and
> reconfigure them if necessary.

Series applied, thank you.
