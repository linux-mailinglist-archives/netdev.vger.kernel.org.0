Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DCB17B2DB
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgCFA0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:26:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:45690 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCFA0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 19:26:15 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA0oT-0004UE-Tz; Fri, 06 Mar 2020 11:26:03 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 11:26:01 +1100
Date:   Fri, 6 Mar 2020 11:26:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable: Document the right function parameters
Message-ID: <20200306002601.GA647@gondor.apana.org.au>
References: <20200305160516.10396-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200305160516.10396-1-j.neuschaefer@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 05:05:16PM +0100, Jonathan Neuschäfer wrote:
> rhashtable_lookup_get_insert_key doesn't have a parameter `data`. It
> does have a parameter `key`, however.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
