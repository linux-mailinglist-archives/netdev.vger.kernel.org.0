Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAEE206AB0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388719AbgFXDg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388577AbgFXDg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:36:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443A1C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:36:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2E1312986EC3;
        Tue, 23 Jun 2020 20:36:58 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:36:58 -0700 (PDT)
Message-Id: <20200623.203658.1101064165283196227.davem@davemloft.net>
To:     tannerlove.kernel@gmail.com
Cc:     netdev@vger.kernel.org, tannerlove@google.com, willemb@google.com
Subject: Re: [PATCH net-next] selftests/net: plug rxtimestamp test into
 kselftest framework
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622174324.42142-1-tannerlove.kernel@gmail.com>
References: <20200622174324.42142-1-tannerlove.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:36:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove.kernel@gmail.com>
Date: Mon, 22 Jun 2020 13:43:24 -0400

> From: tannerlove <tannerlove@google.com>
> 
> Run rxtimestamp as part of TEST_PROGS. Analogous to other tests, add
> new rxtimestamp.sh wrapper script, so that the test runs isolated
> from background traffic in a private network namespace.
> 
> Also ignore failures of test case #6 by default. This case verifies
> that a receive timestamp is not reported if timestamp reporting is
> enabled for a socket, but generation is disabled. Receive timestamp
> generation has to be enabled globally, as no associated socket is
> known yet. A background process that enables rx timestamp generation
> therefore causes a false positive. Ntpd is one example that does.
> 
> Add a "--strict" option to cause failure in the event that any test
> case fails, including test #6. This is useful for environments that
> are known to not have such background processes.
> 
> Tested:
> make -C tools/testing/selftests TARGETS="net" run_tests
> 
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thanks.
