Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AD762E1F
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfGICa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:30:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGICa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:30:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 711F6133E9760;
        Mon,  8 Jul 2019 19:30:27 -0700 (PDT)
Date:   Mon, 08 Jul 2019 19:30:26 -0700 (PDT)
Message-Id: <20190708.193026.1179918332212505792.davem@davemloft.net>
To:     vincent@bernat.ch
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [net-next] bonding: fix value exported by Netlink for
 peer_notif_delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190706210108.15293-1-vincent@bernat.ch>
References: <20190706210108.15293-1-vincent@bernat.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 19:30:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>
Date: Sat,  6 Jul 2019 23:01:08 +0200

> IFLA_BOND_PEER_NOTIF_DELAY was set to the value of downdelay instead
> of peer_notif_delay. After this change, the correct value is exported.
> 
> Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>

Applied.
