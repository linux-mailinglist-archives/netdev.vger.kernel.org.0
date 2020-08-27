Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA3B254F98
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 22:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgH0UAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgH0UAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 16:00:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB8AC061264;
        Thu, 27 Aug 2020 13:00:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E74A5126C36AC;
        Thu, 27 Aug 2020 12:43:19 -0700 (PDT)
Date:   Thu, 27 Aug 2020 13:00:05 -0700 (PDT)
Message-Id: <20200827.130005.1183262344042579840.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, dinghao.liu@zju.edu.cn
Subject: Re: [PATCH net] rxrpc: Fix memory leak in rxkad_verify_response()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159854374644.1432629.4927711289531557914.stgit@warthog.procyon.org.uk>
References: <159854374644.1432629.4927711289531557914.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 12:43:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 27 Aug 2020 16:55:46 +0100

> From: Dinghao Liu <dinghao.liu@zju.edu.cn>
> 
> Fix a memory leak in rxkad_verify_response() whereby the response buffer
> doesn't get freed if we fail to allocate a ticket buffer.
> 
> Fixes: ef68622da9cc ("rxrpc: Handle temporary errors better in rxkad security")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thank you.
