Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8191169B42
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 01:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBXAlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 19:41:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXAlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 19:41:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6BC5158DEB12;
        Sun, 23 Feb 2020 16:41:22 -0800 (PST)
Date:   Sun, 23 Feb 2020 16:41:22 -0800 (PST)
Message-Id: <20200223.164122.1107978085897388571.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        jasowang@redhat.com
Subject: Re: [PATCH] tun: Remove unnecessary BUG_ON check in tun_net_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221195309.72955-1-dsahern@kernel.org>
References: <20200221195309.72955-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 16:41:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri, 21 Feb 2020 12:53:09 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> The BUG_ON for NULL tfile is now redundant due to a recently
> added null check after the rcu_dereference. Remove the BUG_ON.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied to net-next, thanks David.
