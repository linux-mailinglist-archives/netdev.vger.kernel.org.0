Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB8B22D290
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGXX7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGXX7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:59:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA6AC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 16:59:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A739F12756FD3;
        Fri, 24 Jul 2020 16:42:45 -0700 (PDT)
Date:   Fri, 24 Jul 2020 16:59:29 -0700 (PDT)
Message-Id: <20200724.165929.973861664107084279.davem@davemloft.net>
To:     echaudro@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next] net: openvswitch: fixes potential deadlock in
 dp cleanup code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159557885902.884526.12945945970267356485.stgit@ebuild>
References: <159557885902.884526.12945945970267356485.stgit@ebuild>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:42:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>
Date: Fri, 24 Jul 2020 10:20:59 +0200

> The previous patch introduced a deadlock, this patch fixes it by making
> sure the work is canceled without holding the global ovs lock. This is
> done by moving the reorder processing one layer up to the netns level.
> 
> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
> Reported-by: syzbot+2c4ff3614695f75ce26c@syzkaller.appspotmail.com
> Reported-by: syzbot+bad6507e5db05017b008@syzkaller.appspotmail.com
> Reviewed-by: Paolo <pabeni@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied, thank you.
