Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB0266A2E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgIKVlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgIKVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:41:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762E6C061573;
        Fri, 11 Sep 2020 14:41:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 904E41366733C;
        Fri, 11 Sep 2020 14:24:35 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:41:21 -0700 (PDT)
Message-Id: <20200911.144121.2042949892921941512.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        gustavoars@kernel.org, krzk@kernel.org
Subject: Re: [PATCH net-next] net/socket.c: Remove an unused header file
 <linux/if_frad.h>
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911060720.81033-1-xie.he.0141@gmail.com>
References: <20200911060720.81033-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:24:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Thu, 10 Sep 2020 23:07:20 -0700

> This header file is not actually used in this file. Let's remove it.

How did you test this assertion?  As Jakub showed, the
dlci_ioctl_set() function needs to be declared because socket.c
references it.

All of your visual scanning of the code is wasted if you don't
do something simple like an "allmodconfig" or "allyesconfig"
build to test whether your change is correct or not.

Don't leave that step for us, that's your responsibility.

