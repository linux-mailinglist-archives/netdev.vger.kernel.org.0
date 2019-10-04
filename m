Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4DCC47C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 22:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfJDU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 16:58:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDU6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 16:58:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EBF714EC308F;
        Fri,  4 Oct 2019 13:58:08 -0700 (PDT)
Date:   Fri, 04 Oct 2019 13:58:08 -0700 (PDT)
Message-Id: <20191004.135808.1163821632992434445.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix rxrpc_recvmsg tracepoint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157012108434.20904.8998254800982940866.stgit@warthog.procyon.org.uk>
References: <157012108434.20904.8998254800982940866.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 13:58:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 03 Oct 2019 17:44:44 +0100

> Fix the rxrpc_recvmsg tracepoint to handle being called with a NULL call
> parameter.
> 
> Fixes: a25e21f0bcd2 ("rxrpc, afs: Use debug_ids rather than pointers in traces")
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied and queued up for -stable, thanks David.
