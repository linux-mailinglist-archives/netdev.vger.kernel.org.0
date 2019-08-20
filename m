Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915B49530D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbfHTBQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:16:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfHTBQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:16:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 278E114B74FE3;
        Mon, 19 Aug 2019 18:16:56 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:16:55 -0700 (PDT)
Message-Id: <20190819.181655.2279854512112102228.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, jakub.kicinski@netronome.com, pablo@netfilter.org
Subject: Re: [PATCH net] nfp: flower: verify that block cb is not busy
 before binding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819073304.9419-1-vladbu@mellanox.com>
References: <20190819073304.9419-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:16:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Mon, 19 Aug 2019 10:33:04 +0300

> When processing FLOW_BLOCK_BIND command on indirect block, check that flow
> block cb is not busy.
> 
> Fixes: 0d4fd02e7199 ("net: flow_offload: add flow_block_cb_is_busy() and use it")
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied.
