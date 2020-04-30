Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB421C0690
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgD3Tet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3Tes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:34:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE58CC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:34:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5E6F1289789E;
        Thu, 30 Apr 2020 12:34:47 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:34:47 -0700 (PDT)
Message-Id: <20200430.123447.1558476832887483140.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net v2] mptcp: fix uninitialized value access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a94e83fdb29c9c3cdd971e3f57c434efa757c750.1588243772.git.pabeni@redhat.com>
References: <a94e83fdb29c9c3cdd971e3f57c434efa757c750.1588243772.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:34:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 30 Apr 2020 15:03:22 +0200

> tcp_v{4,6}_syn_recv_sock() set 'own_req' only when returning
> a not NULL 'child', let's check 'own_req' only if child is
> available to avoid an - unharmful - UBSAN splat.
> 
> v1 -> v2:
>  - reference the correct hash
> 
> Fixes: 4c8941de781c ("mptcp: avoid flipping mp_capable field in syn_recv_sock()")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied.
