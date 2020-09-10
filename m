Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC71E265069
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgIJURP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgIJUP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:15:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E93C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:15:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5A341344051C;
        Thu, 10 Sep 2020 12:59:08 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:15:54 -0700 (PDT)
Message-Id: <20200910.131554.1989059529943936827.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net-next 0/3] tcp: add tos reflection feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910005048.4146399-1-weiwan@google.com>
References: <20200910005048.4146399-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:59:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Wed,  9 Sep 2020 17:50:45 -0700

> This patch series adds a new tcp feature to reflect TOS value received in
> SYN, and send it out in SYN-ACK, and eventually set the TOS value of the
> established socket with this reflected TOS value. This provides a way to
> set the traffic class/QoS level for all traffic in the same connection
> to be the same as the incoming SYN. It could be useful for datacenters
> to provide equivalent QoS according to the incoming request.
> This feature is guarded by /proc/sys/net/ipv4/tcp_reflect_tos, and is by
> default turned off.
> 
> Wei Wang (3):
>   tcp: record received TOS value in the request socket
>   ip: pass tos into ip_build_and_send_pkt()
>   tcp: reflect tos value received in SYN to the socket

This looks good, series applied, thanks.
