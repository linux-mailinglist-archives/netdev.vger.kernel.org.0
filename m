Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEBF23C20C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHDXGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHDXGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:06:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8F5C06174A;
        Tue,  4 Aug 2020 16:06:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C070712896976;
        Tue,  4 Aug 2020 15:49:55 -0700 (PDT)
Date:   Tue, 04 Aug 2020 16:06:40 -0700 (PDT)
Message-Id: <20200804.160640.1136854489642887881.davem@davemloft.net>
To:     colin.king@canonical.com, willemb@google.com
Cc:     shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/net: skip msg_zerocopy test if we have less
 than 4 CPUs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804123012.378750-1-colin.king@canonical.com>
References: <20200804123012.378750-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:49:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue,  4 Aug 2020 13:30:12 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The current test will exit with a failure if it cannot set affinity on
> specific CPUs which is problematic when running this on single CPU
> systems. Add a check for the number of CPUs and skip the test if
> the CPU requirement is not met.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Willem, please review.
