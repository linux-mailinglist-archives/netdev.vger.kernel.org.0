Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8061220012
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEPHTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:19:14 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:44054 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfEPHTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 03:19:13 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hRAfU-0004Ne-IH; Thu, 16 May 2019 15:19:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hRAfL-0004Ez-V0; Thu, 16 May 2019 15:18:59 +0800
Date:   Thu, 16 May 2019 15:18:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, tgraf@suug.ch, netdev@vger.kernel.org,
        oss-drivers@netronome.com, neilb@suse.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH 0/2] rhashtable: Fix sparse warnings
Message-ID: <20190516071859.uijycusyfqcs7tc7@gondor.apana.org.au>
References: <20190515205501.17810-1-jakub.kicinski@netronome.com>
 <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes all the sparse warnings.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
