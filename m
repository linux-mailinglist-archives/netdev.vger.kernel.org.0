Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB4B5C289
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGASCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:02:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGASCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:02:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7926D14C24B5F;
        Mon,  1 Jul 2019 11:02:38 -0700 (PDT)
Date:   Mon, 01 Jul 2019 11:02:38 -0700 (PDT)
Message-Id: <20190701.110238.1837049511879783171.davem@davemloft.net>
To:     danieltimlee@gmail.com
Cc:     brouer@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] samples: pktgen: allow to specify destination port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190629133358.8251-2-danieltimlee@gmail.com>
References: <20190629133358.8251-1-danieltimlee@gmail.com>
        <20190629133358.8251-2-danieltimlee@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 11:02:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>
Date: Sat, 29 Jun 2019 22:33:58 +0900

> Currently, kernel pktgen has the feature to specify udp destination port
> for sending packet. (e.g. pgset "udp_dst_min 9")
> 
> But on samples, each of the scripts doesn't have any option to achieve this.
> 
> This commit adds the DST_PORT option to specify the target port(s) in the script.
> 
>     -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Applied.
