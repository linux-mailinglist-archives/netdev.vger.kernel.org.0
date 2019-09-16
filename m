Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCECB413F
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbfIPTks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:40:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfIPTks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:40:48 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 13734153F343F;
        Mon, 16 Sep 2019 12:40:45 -0700 (PDT)
Date:   Mon, 16 Sep 2019 21:40:44 +0200 (CEST)
Message-Id: <20190916.214044.322531867002002116.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, nhorman@tuxdriver.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] drop_monitor: Better sanitize notified
 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190915064636.6884-1-idosch@idosch.org>
References: <20190915064636.6884-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 12:40:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 15 Sep 2019 09:46:34 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> When working in 'packet' mode, drop monitor generates a notification
> with a potentially truncated payload of the dropped packet. The payload
> is copied from the MAC header, but I forgot to check that the MAC header
> was set, so do it now.
> 
> Patch #1 sets the offsets to the various protocol layers in netdevsim,
> so that it will continue to work after the MAC header check is added to
> drop monitor in patch #2.

Series applied.
