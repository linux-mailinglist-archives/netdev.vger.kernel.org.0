Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128AB27951F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgIYXui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIYXui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:50:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A879C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:50:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 751D613BA0E61;
        Fri, 25 Sep 2020 16:33:50 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:50:37 -0700 (PDT)
Message-Id: <20200925.165037.78422409470029269.davem@davemloft.net>
To:     razor@blackwall.org
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Subject: Re: [PATCH net-next] net: bridge: mcast: remove only S,G port
 groups from sg_port hash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925102549.1704905-1-razor@blackwall.org>
References: <20200925102549.1704905-1-razor@blackwall.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:33:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>
Date: Fri, 25 Sep 2020 13:25:49 +0300

> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We should remove a group from the sg_port hash only if it's an S,G
> entry. This makes it correct and more symmetric with group add. Also
> since *,G groups are not added to that hash we can hide a bug.
> 
> Fixes: 085b53c8beab ("net: bridge: mcast: add sg_port rhashtable")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Applied, thanks.
