Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB06910CB3
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfEASav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 14:30:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEASau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 14:30:50 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24E441263F1F6;
        Wed,  1 May 2019 11:30:50 -0700 (PDT)
Date:   Wed, 01 May 2019 14:30:49 -0400 (EDT)
Message-Id: <20190501.143049.1940774414388274979.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dsahern@kernel.org
Subject: Re: [PATCH net] selftests: fib_rule_tests: print the result and
 return 1 if any tests failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430024610.26177-1-liuhangbin@gmail.com>
References: <20190430024610.26177-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 11:30:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 30 Apr 2019 10:46:10 +0800

> Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
