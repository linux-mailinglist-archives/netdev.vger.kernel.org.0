Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2E2767EB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgIXEim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:38:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48926 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIXEim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 00:38:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLJ1g-00027S-8K; Thu, 24 Sep 2020 14:38:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 14:38:35 +1000
Date:   Thu, 24 Sep 2020 14:38:35 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+537fc2e3dff863640cc1@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: possible deadlock in xfrm_user_rcv_msg
Message-ID: <20200924043835.GA9494@gondor.apana.org.au>
References: <0000000000007f44e005afc790bf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000007f44e005afc790bf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz dup: inconsistent lock state in xfrm_policy_lookup_inexact_addr
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
