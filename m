Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C015721000
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfEPV24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:28:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfEPV2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:28:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A33912D6C929;
        Thu, 16 May 2019 14:28:55 -0700 (PDT)
Date:   Thu, 16 May 2019 14:28:55 -0700 (PDT)
Message-Id: <20190516.142855.2191010163394598687.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH net] selftests: pmtu.sh: Remove quotes around commands
 in setup_xfrm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516174131.19473-1-dsahern@kernel.org>
References: <20190516174131.19473-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 14:28:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu, 16 May 2019 10:41:31 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> The first command in setup_xfrm is failing resulting in the test getting
> skipped:
> 
> + ip netns exec ns-B ip -6 xfrm state add src fd00:1::a dst fd00:1::b spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
> + out=RTNETLINK answers: Function not implemented
> ...
>   xfrm6 not supported
> TEST: vti6: PMTU exceptions                                         [SKIP]
>   xfrm4 not supported
> TEST: vti4: PMTU exceptions                                         [SKIP]
> ...
> 
> The setup command started failing when the run_cmd option was added.
> Removing the quotes fixes the problem:
> ...
> TEST: vti6: PMTU exceptions                                         [ OK ]
> TEST: vti4: PMTU exceptions                                         [ OK ]
> ...
> 
> Fixes: 56490b623aa0 ("selftests: Add debugging options to pmtu.sh")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
