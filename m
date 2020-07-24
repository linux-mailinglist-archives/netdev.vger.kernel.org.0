Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A89E22C2D6
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgGXKM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:12:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38930 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgGXKM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 06:12:26 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyuge-0000qn-9g; Fri, 24 Jul 2020 20:12:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jul 2020 20:12:20 +1000
Date:   Fri, 24 Jul 2020 20:12:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
Subject: [v2 PATCH 0/2] rhashtable: Fix unprotected RCU dereference in
 __rht_ptr
Message-ID: <20200724101220.GA15913@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2

Added another missing __rcu marker causing warnings.

--

This patch series fixes an unprotected dereference in __rht_ptr.
The first patch is a minimal fix that does not use the correct
RCU markings but is suitable for backport, and the second patch
cleans up the RCU markings.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
