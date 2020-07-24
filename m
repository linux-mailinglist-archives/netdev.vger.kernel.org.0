Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCB922BB3B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 03:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgGXBI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 21:08:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37670 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgGXBI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 21:08:26 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jymCF-0001oe-9s; Fri, 24 Jul 2020 11:08:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jul 2020 11:08:23 +1000
Date:   Fri, 24 Jul 2020 11:08:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
Subject: [PATCH 0/2] rhashtable: Fix unprotected RCU dereference in __rht_ptr
Message-ID: <20200724010823.GA8549@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes an unprotected dereference in __rht_ptr.
The first patch is a minimal fix that does not use the correct
RCU markings but is suitable for backport, and the second patch
cleans up the RCU markings.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
