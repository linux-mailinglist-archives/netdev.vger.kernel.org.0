Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC4284C3D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgJFNI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFNI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:08:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AF4C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:08:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1520A127C6C16;
        Tue,  6 Oct 2020 05:51:39 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:08:25 -0700 (PDT)
Message-Id: <20201006.060825.725318051868237498.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next] mptcp: don't skip needed ack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <515e80a174ee9bad5e2c6a8338d9362eb43d39b7.1601894086.git.pabeni@redhat.com>
References: <515e80a174ee9bad5e2c6a8338d9362eb43d39b7.1601894086.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:51:39 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon,  5 Oct 2020 12:36:44 +0200

> Currently we skip calling tcp_cleanup_rbuf() when packets
> are moved into the OoO queue or simply dropped. In both
> cases we still increment tp->copied_seq, and we should
> ask the TCP stack to check for ack.
> 
> Fixes: c76c6956566f ("mptcp: call tcp_cleanup_rbuf on subflows")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied.
