Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60D67CB7
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfGNCiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:38:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfGNCix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:38:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DDA5140518DC;
        Sat, 13 Jul 2019 19:38:52 -0700 (PDT)
Date:   Sat, 13 Jul 2019 19:38:51 -0700 (PDT)
Message-Id: <20190713.193851.299869556588012582.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     nhorman@tuxdriver.com, netdev@vger.kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data
 paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190711123909.GA10978@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
        <20190707.124541.451040901050013496.davem@davemloft.net>
        <20190711123909.GA10978@splinter>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jul 2019 19:38:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 11 Jul 2019 15:39:09 +0300

> Before I start working on v2, I would like to get your feedback on the
> high level plan. Also adding Neil who is the maintainer of drop_monitor
> (and counterpart DropWatch tool [1]).
> 
> IIUC, the problem you point out is that users need to use different
> tools to monitor packet drops based on where these drops occur
> (SW/HW/XDP).
> 
> Therefore, my plan is to extend the existing drop_monitor netlink
> channel to also cover HW drops. I will add a new message type and a new
> multicast group for HW drops and encode in the message what is currently
> encoded in the devlink events.

Consolidating the reporting to merge with the drop monitor facilities
is definitely a step in the right direction.
