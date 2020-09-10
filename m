Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9595326505D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgIJUOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgIJUN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:13:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670CC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:13:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B161D13402CF2;
        Thu, 10 Sep 2020 12:57:09 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:13:55 -0700 (PDT)
Message-Id: <20200910.131355.396733870871815643.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com
Subject: Re: [net-next v4 0/5] devlink flash update overwrite mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909222653.32994-1-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:57:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Wed,  9 Sep 2020 15:26:48 -0700

> This series introduces support for a new attribute to the flash update
> command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.

I think you really need to get rid of BIT() usage in the UAPI
header as Jakub mentioned.
