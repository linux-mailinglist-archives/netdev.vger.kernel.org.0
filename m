Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E1C7D195
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfGaWyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:54:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730360AbfGaWyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:54:08 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E914C1264DFCF;
        Wed, 31 Jul 2019 15:54:07 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:54:07 -0400 (EDT)
Message-Id: <20190731.185407.1888128333842132124.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        rong.a.chen@intel.com
Subject: Re: [PATCH net] selftests/tls: fix TLS tests with CONFIG_TLS=n
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729230803.10781-1-jakub.kicinski@netronome.com>
References: <20190729230803.10781-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 15:54:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 29 Jul 2019 16:08:03 -0700

> Build bot reports some recent TLS tests are failing
> with CONFIG_TLS=n. Correct the expected return code
> and skip TLS installation if not supported.
> 
> Tested with CONFIG_TLS=n and CONFIG_TLS=m.
> 
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Fixes: cf32526c8842 ("selftests/tls: add a test for ULP but no keys")
> Fixes: 65d41fb317c6 ("selftests/tls: add a bidirectional test")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks Jakub.
