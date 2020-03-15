Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F5F185AD9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCOHFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:05:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgCOHFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:05:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17AA513CAE4E6;
        Sun, 15 Mar 2020 00:05:20 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:05:17 -0700 (PDT)
Message-Id: <20200315.000517.641109897419327751.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     shuah@kernel.org, keescook@chromium.org, luto@amacapital.net,
        wad@chromium.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 0/4] kselftest: add fixture parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200314005501.2446494-1-kuba@kernel.org>
References: <20200314005501.2446494-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:05:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 13 Mar 2020 17:54:57 -0700

> This set is an attempt to make running tests for different
> sets of data easier. The direct motivation is the tls
> test which we'd like to run for TLS 1.2 and TLS 1.3,
> but currently there is no easy way to invoke the same
> tests with different parameters.
> 
> Tested all users of kselftest_harness.h.
> 
> v2:
>  - don't run tests by fixture
>  - don't pass params as an explicit argument
> 
> Note that we loose a little bit of type safety
> without passing parameters as an explicit argument.
> If user puts the name of the wrong fixture as argument
> to CURRENT_FIXTURE() it will happily cast the type.

Hmmm, what tree should integrate this patch series?
