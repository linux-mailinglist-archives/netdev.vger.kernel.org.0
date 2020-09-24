Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC0276790
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgIXEOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:14:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48842 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgIXEOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 00:14:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLIeE-0001pP-TX; Thu, 24 Sep 2020 14:14:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 14:14:22 +1000
Date:   Thu, 24 Sep 2020 14:14:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+0c9fc3836c6c057a975a@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: possible deadlock in xfrm_policy_lookup_inexact_addr
Message-ID: <20200924041422.GA9255@gondor.apana.org.au>
References: <000000000000ca028b05af6a5e4c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000ca028b05af6a5e4c@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz dup: inconsistent lock state in xfrm_policy_lookup_inexact_addr
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
