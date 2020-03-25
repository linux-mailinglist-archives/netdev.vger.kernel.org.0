Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0ABE1930C9
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCYTBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:01:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgCYTBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:01:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 836C415A069BF;
        Wed, 25 Mar 2020 12:01:43 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:01:40 -0700 (PDT)
Message-Id: <20200325.120140.1033549482785105994.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, vadym.kochan@plvision.eu, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net] selftests/net/forwarding: define libs as
 TEST_PROGS_EXTENDED
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325084101.9156-1-liuhangbin@gmail.com>
References: <20200325084101.9156-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 12:01:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed, 25 Mar 2020 16:41:01 +0800

> The lib files should not be defined as TEST_PROGS, or we will run them
> in run_kselftest.sh.
> 
> Also remove ethtool_lib.sh exec permission.
> 
> Fixes: 81573b18f26d ("selftests/net/forwarding: add Makefile to install tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thanks.
