Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC8C71734D6
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgB1KCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:02:21 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54818 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgB1KCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 05:02:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 240F22057A;
        Fri, 28 Feb 2020 11:02:19 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tq6qlF73MTYo; Fri, 28 Feb 2020 11:02:18 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BC85E204EF;
        Fri, 28 Feb 2020 11:02:18 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 28 Feb 2020
 11:02:18 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 685DF3180277;
 Fri, 28 Feb 2020 11:02:18 +0100 (CET)
Date:   Fri, 28 Feb 2020 11:02:18 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <madhuparnabhowmik10@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joel@joelfernandes.org>, <frextrite@gmail.com>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <paulmck@kernel.org>
Subject: Re: [PATCH] ipv6: xfrm6_tunnel.c: Use built-in RCU list checking
Message-ID: <20200228100218.GH19286@gauss3.secunet.de>
References: <20200221162447.23998-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200221162447.23998-1-madhuparnabhowmik10@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 09:54:47PM +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> hlist_for_each_entry_rcu() has built-in RCU and lock checking.
> 
> Pass cond argument to list_for_each_entry_rcu() to silence
> false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> by default.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Applied, thanks!
