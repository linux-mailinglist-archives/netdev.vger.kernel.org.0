Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773B11FA560
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgFPBHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgFPBHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:07:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B3BC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:07:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2CAA6122A98E0;
        Mon, 15 Jun 2020 18:07:11 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:07:10 -0700 (PDT)
Message-Id: <20200615.180710.1879893853346546167.davem@davemloft.net>
To:     roid@mellanox.com
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, jiri@mellanox.com,
        paulb@mellanox.com, ozsh@mellanox.com, mleitner@redhat.com,
        alaa@mellanox.com
Subject: Re: [PATCH net 0/2] remove dependency between mlx5, act_ct,
 nf_flow_table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200614111249.6145-1-roid@mellanox.com>
References: <20200614111249.6145-1-roid@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:07:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>
Date: Sun, 14 Jun 2020 14:12:47 +0300

> Some exported functions from act_ct and nf_flow_table being used in mlx5_core.
> This leads that mlx5 module always require act_ct and nf_flow_table modules.
> Those small exported functions can be moved to the header files to
> avoid this module dependency.

Series applied, thanks.
