Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8333113678
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfLDUcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:32:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbfLDUcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:32:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BFDF14D6B5BC;
        Wed,  4 Dec 2019 12:32:19 -0800 (PST)
Date:   Wed, 04 Dec 2019 12:32:18 -0800 (PST)
Message-Id: <20191204.123218.1796332582453267563.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH net] Fixed updating of ethertype in function
 skb_mpls_push
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575474239-4721-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1575474239-4721-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 12:32:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The proper format for a patch Subject line is:

[PATCH $TARGET_GIT_TREE $VERSION] $subsystem_prefix: Description.

So for your updated submission of this patch you could say:

[PATCH net v2] mpls: Fix updating of ethertype in skb_mpls_push()

or:

[PATCH net v2] net: Fix updating of ethertype in skb_mpls_push()

Either would be fine.
