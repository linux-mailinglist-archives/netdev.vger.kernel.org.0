Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2D228C91
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgGUXPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:15:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959DC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:15:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FE2D11E45904;
        Tue, 21 Jul 2020 15:58:29 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:15:13 -0700 (PDT)
Message-Id: <20200721.161513.1845204518930431738.davem@davemloft.net>
To:     parav@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net-next 0/4] devlink small improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721165354.5244-1-parav@mellanox.com>
References: <20200721165354.5244-1-parav@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:58:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>
Date: Tue, 21 Jul 2020 19:53:50 +0300

> This short series improves the devlink code for lock commment,
> simplifying checks and keeping the scope of mutex lock for necessary
> fields.
> 
> Patch summary:
> Patch-1 Keep the devlink_mutex for only for necessary changes.
> Patch-2 Avoids duplicate check for reload flag
> Patch-3 Adds missing comment for the scope of devlink instance lock
> Patch-4 Constify devlink instance pointer

Series applied, thank you.
