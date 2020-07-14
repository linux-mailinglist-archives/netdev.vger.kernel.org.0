Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D019221FE8A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGNU1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgGNU1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:27:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836E0C061794
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:27:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC2CE15E21EE4;
        Tue, 14 Jul 2020 13:27:37 -0700 (PDT)
Date:   Tue, 14 Jul 2020 13:27:37 -0700 (PDT)
Message-Id: <20200714.132737.1268980298021700002.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/13] Mellanox, mlx5 CT updates
 2020-07-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <31e978781676414b91c44fc02b9f200bae9bc863.camel@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
        <20200710.141204.1000719994162068882.davem@davemloft.net>
        <31e978781676414b91c44fc02b9f200bae9bc863.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 13:27:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 14 Jul 2020 05:11:31 +0000

> But at the time of this submission there wasn't any conflict, and I
> couldn't determine ahead of time if you are going to merge net or this
> pull request first.

I understand that sometimes you cannot foresee this kind of situation,
sure.
