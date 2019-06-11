Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3513D5E8
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391311AbfFKSyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:54:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389664AbfFKSyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:54:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E42C71525A425;
        Tue, 11 Jun 2019 11:54:40 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:54:40 -0700 (PDT)
Message-Id: <20190611.115440.853101091654871086.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: do not free vport if
 register_netdevice() is failed.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190609142621.30674-1-ap420073@gmail.com>
References: <20190609142621.30674-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 11:54:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sun,  9 Jun 2019 23:26:21 +0900

> In order to create an internal vport, internal_dev_create() is used and
> that calls register_netdevice() internally.
> If register_netdevice() fails, it calls dev->priv_destructor() to free
> private data of netdev. actually, a private data of this is a vport.
> 
> Hence internal_dev_create() should not free and use a vport after failure
> of register_netdevice().
> 
> Test command
>     ovs-dpctl add-dp bonding_masters
 ...
> Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thank you.
