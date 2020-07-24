Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6596422D1BE
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGXWVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGXWVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:21:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F27C0619D3;
        Fri, 24 Jul 2020 15:21:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A2871274C3A1;
        Fri, 24 Jul 2020 15:04:53 -0700 (PDT)
Date:   Fri, 24 Jul 2020 15:21:36 -0700 (PDT)
Message-Id: <20200724.152136.239820662240192829.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com, vinicius.gomes@intel.com
Subject: Re: [net-next v5 PATCH 0/7] Add PRP driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7133d5ca-e72b-b406-feb2-21429085c96a@ti.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
        <7133d5ca-e72b-b406-feb2-21429085c96a@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 15:04:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Fri, 24 Jul 2020 08:27:01 -0400

> If there are no more comments, can we consider merging this to
> net-next? I could re-base and repost if there is any conflict.

I can't apply them until I next merge net into net-next, and I don't
know exactly when that will happen yet.

It'd also be nice to get some review and ACK's on this series
meanwhile.
