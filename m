Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D68327116D
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgISXu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:50:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52305C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 16:50:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85C2C12117698;
        Sat, 19 Sep 2020 16:33:41 -0700 (PDT)
Date:   Sat, 19 Sep 2020 16:50:27 -0700 (PDT)
Message-Id: <20200919.165027.155707282988829868.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net 00/15] mlx5 Fixes 2020-09-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 16:33:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Fri, 18 Sep 2020 10:28:24 -0700

>  ('net/mlx5e: Protect encap route dev from concurrent release')

I'm being asked to queue this up for -stable, but this change does not
exist in this pull request.

Please sort this out and resubmit.

Thank you.
