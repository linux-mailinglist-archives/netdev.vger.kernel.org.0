Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7F5D928
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfGCAfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:35:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfGCAff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:35:35 -0400
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9167140F894D;
        Tue,  2 Jul 2019 17:18:08 -0700 (PDT)
Date:   Tue, 02 Jul 2019 20:18:05 -0400 (EDT)
Message-Id: <20190702.201805.1617924578071148532.davem@davemloft.net>
To:     po-hsu.lin@canonical.com
Cc:     shuah@kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] selftests/net: skip psock_tpacket test if KALLSYMS
 was not enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701044031.19451-1-po-hsu.lin@canonical.com>
References: <20190701044031.19451-1-po-hsu.lin@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 17:18:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Mon,  1 Jul 2019 12:40:31 +0800

> The psock_tpacket test will need to access /proc/kallsyms, this would
> require the kernel config CONFIG_KALLSYMS to be enabled first.
> 
> Apart from adding CONFIG_KALLSYMS to the net/config file here, check the
> file existence to determine if we can run this test will be helpful to
> avoid a false-positive test result when testing it directly with the
> following commad against a kernel that have CONFIG_KALLSYMS disabled:
>     make -C tools/testing/selftests TARGETS=net run_tests
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Applied, thank you.
