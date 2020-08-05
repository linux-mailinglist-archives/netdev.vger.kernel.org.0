Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2BD23CFB2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgHETX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbgHETXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:23:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88943C061575;
        Wed,  5 Aug 2020 12:23:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E90E3152F10C7;
        Wed,  5 Aug 2020 12:06:57 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:23:42 -0700 (PDT)
Message-Id: <20200805.122342.187021203440253984.davem@davemloft.net>
To:     po-hsu.lin@canonical.com
Cc:     kuba@kernel.org, skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] selftests: rtnetlink: Fix for false-negative
 return values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804101803.23062-1-po-hsu.lin@canonical.com>
References: <20200804101803.23062-1-po-hsu.lin@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 12:06:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Tue,  4 Aug 2020 18:18:01 +0800

> This patchset will address the false-negative return value issue
> caused by the following:
>   1. The return value "ret" in this script will be reset to 0 from
>      the beginning of each sub-test in rtnetlink.sh, therefore this
>      rtnetlink test will always pass if the last sub-test has passed.
>   2. The test result from two sub-tests in kci_test_encap() were not
>      being processed, thus they will not affect the final test result
>      of this test.

Series applied, thank you.
