Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD8E2767D0
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIXEZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:25:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48892 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgIXEZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 00:25:37 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLIos-0001zE-9N; Thu, 24 Sep 2020 14:25:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 14:25:22 +1000
Date:   Thu, 24 Sep 2020 14:25:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+4cbd5e3669aee5ac5149@syzkaller.appspotmail.com>
Cc:     a.darwish@linutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        will@kernel.org
Subject: Re: possible deadlock in xfrm_policy_lookup_bytype
Message-ID: <20200924042522.GD9255@gondor.apana.org.au>
References: <00000000000025fe5805afbc876c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000025fe5805afbc876c@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz dup: inconsistent lock state in xfrm_policy_lookup_inexact_addr
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
