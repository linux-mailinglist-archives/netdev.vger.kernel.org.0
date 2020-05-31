Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C7D1E94CE
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgEaAye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaAye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 20:54:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DB2C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 17:54:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C157A128DAB35;
        Sat, 30 May 2020 17:54:32 -0700 (PDT)
Date:   Sat, 30 May 2020 17:54:31 -0700 (PDT)
Message-Id: <20200530.175431.1917858442603324965.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] mlx5 cleanup 2020-05-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 17:54:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 29 May 2020 21:26:11 -0700

> While the TLS RX series is being discussed, If it is ok with you,
> i would like to get this cleanup series merged into net-next.

This is fine with me, pulled, thanks Saeed.
