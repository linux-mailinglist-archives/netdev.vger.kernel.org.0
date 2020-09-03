Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD61F25CCFE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgICV72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgICV71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:59:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CC2C061244;
        Thu,  3 Sep 2020 14:59:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E888127787EA;
        Thu,  3 Sep 2020 14:42:38 -0700 (PDT)
Date:   Thu, 03 Sep 2020 14:59:24 -0700 (PDT)
Message-Id: <20200903.145924.1689910712019485778.davem@davemloft.net>
To:     po-hsu.lin@canonical.com
Cc:     kuba@kernel.org, skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/net: improve descriptions for XFAIL cases in
 psock_snd.sh
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901150923.36083-1-po-hsu.lin@canonical.com>
References: <20200901150923.36083-1-po-hsu.lin@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 14:42:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Tue,  1 Sep 2020 23:09:23 +0800

> Before changing this it's a bit confusing to read test output:
>   raw csum_off with bad offset (fails)
>   ./psock_snd: write: Invalid argument
> 
> Change "fails" in the test case description to "expected to fail", so
> that the test output can be more understandable.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Applied to net-next, thank you.
