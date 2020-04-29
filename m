Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571D61BE6B7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgD2S4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2S4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:56:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388EAC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:56:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64F631210A3E3;
        Wed, 29 Apr 2020 11:56:03 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:56:02 -0700 (PDT)
Message-Id: <20200429.115602.466970698181251524.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix uninitialized value access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c2b96b3751ccf64357d2c6f0e7d23908dda8a601.1588157274.git.pabeni@redhat.com>
References: <c2b96b3751ccf64357d2c6f0e7d23908dda8a601.1588157274.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 11:56:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 29 Apr 2020 12:50:37 +0200

> Fixes: 20882e2cb904 ("mptcp: avoid flipping mp_capable field in syn_recv_sock()")

[davem@localhost net]$ git describe 20882e2cb904
fatal: Not a valid object name 20882e2cb904
[davem@localhost net]$ 

Please fix this.
