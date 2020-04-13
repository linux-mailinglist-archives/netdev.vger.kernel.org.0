Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4861A61E5
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 06:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgDMET1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 00:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgDMET1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 00:19:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF2AC0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 21:19:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 504B0127AFC04;
        Sun, 12 Apr 2020 21:19:26 -0700 (PDT)
Date:   Sun, 12 Apr 2020 21:19:25 -0700 (PDT)
Message-Id: <20200412.211925.400624643622219681.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, arjan@linux.intel.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200412060854.334895-1-leon@kernel.org>
References: <20200412060854.334895-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Apr 2020 21:19:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is cause by a device"overwhelmed with traffic"?  Sounds like
normal operation to me.

That's a bug, and the driver handling the device with this problem
should adjust how it implements TX timeouts to accomodate this.
