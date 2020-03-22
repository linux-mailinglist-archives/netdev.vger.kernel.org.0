Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBE918E642
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgCVDXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:23:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgCVDXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:23:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DF1915AC42B0;
        Sat, 21 Mar 2020 20:23:33 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:23:32 -0700 (PDT)
Message-Id: <20200321.202332.1124475628215113570.davem@davemloft.net>
To:     alan.maguire@oracle.com
Cc:     kuba@kernel.org, shuah@kernel.org, netdev@vger.kernel.org,
        posk@google.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selftests/net: add definition for SOL_DCCP to fix
 compilation errors for old libc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584557601-25202-1-git-send-email-alan.maguire@oracle.com>
References: <1584557601-25202-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:23:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>
Date: Wed, 18 Mar 2020 18:53:21 +0000

> Many systems build/test up-to-date kernels with older libcs, and
> an older glibc (2.17) lacks the definition of SOL_DCCP in
> /usr/include/bits/socket.h (it was added in the 4.6 timeframe).
> 
> Adding the definition to the test program avoids a compilation
> failure that gets in the way of building tools/testing/selftests/net.
> The test itself will work once the definition is added; either
> skipping due to DCCP not being configured in the kernel under test
> or passing, so there are no other more up-to-date glibc dependencies
> here it seems beyond that missing definition.
> 
> Fixes: 11fb60d1089f ("selftests: net: reuseport_addr_any: add DCCP")
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>

Applied.
