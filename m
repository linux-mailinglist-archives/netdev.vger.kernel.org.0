Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8121EAD31
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbgFASml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgFASmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:42:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5647AC008631;
        Mon,  1 Jun 2020 11:42:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75E3711D53F8B;
        Mon,  1 Jun 2020 11:42:31 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:42:30 -0700 (PDT)
Message-Id: <20200601.114230.492434884378198241.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        paulb@mellanox.com, ozsh@mellanox.com, vladbu@mellanox.com,
        jiri@resnulli.us, kuba@kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, sriharsha.basavapatna@broadcom.com
Subject: Re: [PATCH net-next 0/8] the indirect flow_block infrastructure,
 revisited
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:42:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 29 May 2020 02:25:33 +0200

> This series fixes b5140a36da78 ("netfilter: flowtable: add indr block
> setup support") that adds support for the indirect block for the
> flowtable.
 ...

Series applied, thanks Pablo.
