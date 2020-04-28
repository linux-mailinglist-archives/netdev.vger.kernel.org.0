Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43C61BCD7A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgD1UbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726284AbgD1UbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:31:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDADC03C1AB;
        Tue, 28 Apr 2020 13:31:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3D5A120ED578;
        Tue, 28 Apr 2020 13:31:04 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:31:04 -0700 (PDT)
Message-Id: <20200428.133104.2167354110776431026.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     keescook@chromium.org, shuah@kernel.org, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH net-next v6 0/5] kselftest: add fixture parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428010351.331260-1-kuba@kernel.org>
References: <20200428010351.331260-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 13:31:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 27 Apr 2020 18:03:46 -0700

> This set is an attempt to make running tests for different
> sets of data easier. The direct motivation is the tls
> test which we'd like to run for TLS 1.2 and TLS 1.3,
> but currently there is no easy way to invoke the same
> tests with different parameters.
> 
> Tested all users of kselftest_harness.h.
> 
> Dave, would it be possible to take these via net-next?
> It seems we're failing to get Shuah's attention.

Sure, series applied, thanks Jakub.
