Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF422BAC7
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgGXAJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:09:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37516 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgGXAJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:09:32 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jylHD-00019b-Qg; Fri, 24 Jul 2020 10:09:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jul 2020 10:09:27 +1000
Date:   Fri, 24 Jul 2020 10:09:27 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
Subject: Re: PROBLEM: potential concurrency bug in rhashtable.h
Message-ID: <20200724000927.GA27290@gondor.apana.org.au>
References: <5964B1AB-3A3D-482C-A13B-4528C015E1ED@purdue.edu>
 <22d7b981-c105-ebee-46e9-241797769e06@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d7b981-c105-ebee-46e9-241797769e06@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:32:05PM -0700, Eric Dumazet wrote:
>
> Thanks for the report/analysis. 

Thanks indeed.

> READ_ONCE() should help here, can you test/submit an official patch ?

This is basically a hand-rolled RCU access.  So we should instead
use proper RCU operators if possible.  Let me see what I can do.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
