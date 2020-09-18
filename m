Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D897270797
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIRUyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIRUyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:54:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CCCC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:54:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B848159111C2;
        Fri, 18 Sep 2020 13:37:54 -0700 (PDT)
Date:   Fri, 18 Sep 2020 13:54:40 -0700 (PDT)
Message-Id: <20200918.135440.1763764251615101439.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 0/5] ionic: add devlink dev flash support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918011327.31577-1-snelson@pensando.io>
References: <20200918011327.31577-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:37:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 17 Sep 2020 18:13:22 -0700

> Add support for using devlink's dev flash facility to update the
> firmware on an ionic device, and add a new timeout parameter to the
> devlink flash netlink message.
> 
> For long-running flash commands, we add a timeout element to the dev
> flash notify message in order for a userland utility to display a timeout
> deadline to the user.  This allows the userland utility to display a
> count down to the user when a firmware update action is otherwise going
> to go for ahile without any updates.  An example use is added to the
> netdevsim module.
> 
> The ionic driver uses this timeout element in its new flash function.
> The driver uses a simple model of pushing the firmware file to the NIC,
> asking the NIC to unpack and install the file into the device, and then
> selecting it for the next boot.  If any of these steps fail, the whole
> transaction is failed.  A couple of the steps can take a long time,
> so we use the timeout status message rather than faking it with bogus
> done/total messages.
> 
> The driver doesn't currently support doing these steps individually.
> In the future we want to be able to list the FW that is installed and
> selectable but we don't yet have the API to fully support that.
 ...

Series applied to net-next.
