Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC3284C3A
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJFNHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgJFNHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:07:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C82C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:07:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23606127C6C11;
        Tue,  6 Oct 2020 05:50:57 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:07:44 -0700 (PDT)
Message-Id: <20201006.060744.1614882032086190689.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: more DATA FIN fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <359280012491ffc587afdfb55aaaec60953c7218.1601891999.git.pabeni@redhat.com>
References: <359280012491ffc587afdfb55aaaec60953c7218.1601891999.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:50:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon,  5 Oct 2020 12:01:06 +0200

> Currently data fin on data packet are not handled properly:
> the 'rcv_data_fin_seq' field is interpreted as the last
> sequence number carrying a valid data, but for data fin
> packet with valid maps we currently store map_seq + map_len,
> that is, the next value.
> 
> The 'write_seq' fields carries instead the value subseguent
> to the last valid byte, so in mptcp_write_data_fin() we
> never detect correctly the last DSS map.
> 
> Fixes: 7279da6145bb ("mptcp: Use MPTCP-level flag for sending DATA_FIN")
> Fixes: 1a49b2c2a501 ("mptcp: Handle incoming 32-bit DATA_FIN values")
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied.
