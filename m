Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4258A233C30
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgG3Xe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730643AbgG3Xe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:34:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1AEC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:34:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81B86126BEDF2;
        Thu, 30 Jul 2020 16:17:43 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:34:28 -0700 (PDT)
Message-Id: <20200730.163428.1872837971114329220.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org
Subject: Re: [PATCH net] selftests/bpf: fix netdevsim
 trap_flow_action_cookie read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727110455.2969281-1-liuhangbin@gmail.com>
References: <20200727110455.2969281-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:17:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon, 27 Jul 2020 19:04:55 +0800

> When read netdevsim trap_flow_action_cookie, we need to init it first,
> or we will get "Invalid argument" error.
> 
> Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
