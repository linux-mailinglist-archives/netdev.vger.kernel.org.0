Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB14C302
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfFSVeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:34:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSVeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:34:11 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 292FB147B18FA;
        Wed, 19 Jun 2019 14:34:10 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:34:09 -0400 (EDT)
Message-Id: <20190619.173409.2275727822439450636.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        naresh.kamboju@linaro.org, linux-kselftest@vger.kernel.org,
        willemb@google.com
Subject: Re: [PATCH net-next] selftests/net: make udpgso_bench skip
 unsupported testcases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618200304.63068-1-willemdebruijn.kernel@gmail.com>
References: <20190618200304.63068-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:34:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 18 Jun 2019 16:03:04 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Kselftest can be run against older kernels. Instead of failing hard
> when a feature is unsupported, return the KSFT_SKIP exit code.
> 
> Specifically, do not fail hard on missing udp zerocopy.
> 
> The udp gso bench test runs multiple test cases from a single script.
> Fail if any case fails, else return skip if any test is skipped.
> 
> Link: https://lore.kernel.org/lkml/20190618171516.GA17547@kroah.com/
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thanks.
