Return-Path: <netdev+bounces-2935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9149B704A44
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4030D2815B3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C251950C;
	Tue, 16 May 2023 10:16:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66112156FB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:16:00 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9251A1A5;
	Tue, 16 May 2023 03:15:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pyrhy-009Z5W-Qv; Tue, 16 May 2023 18:15:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 May 2023 18:15:06 +0800
Date: Tue, 16 May 2023 18:15:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v6 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Message-ID: <ZGNXqrqoFfA5DUsr@gondor.apana.org.au>
References: <20230512202311.2845526-1-dima@arista.com>
 <20230512202311.2845526-2-dima@arista.com>
 <ZGG5rtuHB4lvLyKI@gondor.apana.org.au>
 <eb6d0724-92d6-3c3f-b698-9734adc7e1b9@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6d0724-92d6-3c3f-b698-9734adc7e1b9@arista.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 05:25:55PM +0100, Dmitry Safonov wrote:
>
> Hi Herbert, thanks for your patches. Could you point me to the repo that
> has ciphers clone-tfm support? I've looked in Torvald's/master, your
> cryptodev-2.6.git and in linux-next, but I can't see anywhere in
> cmac_create() something of inst->alg.base.clone_tfm = cmac_clone_tfm kind.
> 
> As I wrote two paragraphs above, it's required for TCP-AO to provide
> cmac(aes128) support. Let me know if you have cmac clone-tfm somewhere
> or if you're cooking it. On the cover-letter for this patch set, it's in
> TODO.

Good point.  I'll post something for cmac soon.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

