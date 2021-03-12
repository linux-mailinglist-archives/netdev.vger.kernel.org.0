Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5274333981A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhCLURA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbhCLUQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:16:45 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EC5C061574;
        Fri, 12 Mar 2021 12:16:45 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9906E4CFCCBE9;
        Fri, 12 Mar 2021 12:16:43 -0800 (PST)
Date:   Fri, 12 Mar 2021 12:16:42 -0800 (PST)
Message-Id: <20210312.121642.657598616674920805.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     roid@nvidia.com, baijiaju1990@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saeedm@nvidia.com
Subject: Re: [PATCH] net: bonding: fix error return code of
 bond_neigh_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5d4cbafa-dbad-9b66-c5be-bca6ecc8e6f3@gmail.com>
References: <20210308031102.26730-1-baijiaju1990@gmail.com>
        <e15f36f7-6421-69a3-f10a-45b83621b96f@nvidia.com>
        <5d4cbafa-dbad-9b66-c5be-bca6ecc8e6f3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 12 Mar 2021 12:16:44 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 10 Mar 2021 17:55:04 +0100

> 
> Agreed, this commit made no sense, please revert.

Done.
