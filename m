Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93626279586
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgIZAVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729495AbgIZAVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:21:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606F4C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:21:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE8FD13BA5224;
        Fri, 25 Sep 2020 17:04:25 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:21:12 -0700 (PDT)
Message-Id: <20200925.172112.681809111177302365.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, snelson@pensando.io
Subject: Re: [net-next v9 0/5] devlink flash update overwrite mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925204609.1929800-1-jacob.e.keller@intel.com>
References: <20200925204609.1929800-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 17:04:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Fri, 25 Sep 2020 13:46:04 -0700

> This series introduces support for a new attribute to the flash update
> command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
 ...

Series applied, thanks.
