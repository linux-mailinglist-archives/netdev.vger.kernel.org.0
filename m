Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D12241DD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGQRel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQRel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:34:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF1C0619D2;
        Fri, 17 Jul 2020 10:34:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84A6F135E9FFA;
        Fri, 17 Jul 2020 10:34:40 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:34:39 -0700 (PDT)
Message-Id: <20200717.103439.774880145467935567.davem@davemloft.net>
To:     daniel.lezcano@linaro.org
Cc:     kuba@kernel.org, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        johannes.berg@intel.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: genetlink: Move initialization to core_initcall
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3ab741d2-2d44-fbcb-709d-c89d2b0c3649@linaro.org>
References: <20200715074120.8768-1-daniel.lezcano@linaro.org>
        <3ab741d2-2d44-fbcb-709d-c89d2b0c3649@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 10:34:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>
Date: Wed, 15 Jul 2020 09:43:00 +0200

> if you agree with this change, is it possible I merge it through the
> thermal tree in order to fix the issue ?

No problem:

Acked-by: David S. Miller <davem@davemloft.net>
