Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D553D5F2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404699AbfFKS4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:56:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404245AbfFKS4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:56:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99C801525A42C;
        Tue, 11 Jun 2019 11:56:53 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:56:53 -0700 (PDT)
Message-Id: <20190611.115653.1395207124332653270.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next] net: openvswitch: remove unnecessary
 ASSERT_OVSL in ovs_vport_del()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190609171906.30314-1-ap420073@gmail.com>
References: <20190609171906.30314-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 11:56:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 10 Jun 2019 02:19:06 +0900

> ASSERT_OVSL() in ovs_vport_del() is unnecessary because
> ovs_vport_del() is only called by ovs_dp_detach_port() and
> ovs_dp_detach_port() calls ASSERT_OVSL() too.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied.
