Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9820204B78
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbgFWHoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:44:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:45212 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731311AbgFWHoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:44:20 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jndag-0005Hb-9c; Tue, 23 Jun 2020 17:43:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 23 Jun 2020 17:43:34 +1000
Date:   Tue, 23 Jun 2020 17:43:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: missing retval check of call_netdevice_notifiers in
 dev_change_net_namespace
Message-ID: <20200623074334.GA8574@gondor.apana.org.au>
References: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
 <87imfjt2qu.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imfjt2qu.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 12:43:53PM -0500, Eric W. Biederman wrote:
> 
> Adding Herbert Xu who added support for failing notifications in
> fcc5a03ac425 ("[NET]: Allow netdev REGISTER/CHANGENAME events to fail").
> 
> He might have some insight but 2007 was a long time ago.

https://lists.openwall.net/netdev/2007/07/26/61

AFAICS this is still needed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
