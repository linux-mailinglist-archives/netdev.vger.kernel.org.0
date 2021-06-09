Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675483A0F13
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhFII5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 04:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhFII5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 04:57:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3202EC061574;
        Wed,  9 Jun 2021 01:55:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lqtzw-0049sz-5l; Wed, 09 Jun 2021 10:55:40 +0200
Message-ID: <d32bec575d204a17531f61c8d2f67443ffdaee6c.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: fix a mistake in grammar
From:   Johannes Berg <johannes@sipsolutions.net>
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Date:   Wed, 09 Jun 2021 10:55:38 +0200
In-Reply-To: <20210609081556.19641-1-13145886936@163.com>
References: <20210609081556.19641-1-13145886936@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-09 at 01:15 -0700, 13145886936@163.com wrote:
> 
> -	/* don't allow or configure an mcast address */
> +	/* don't allow or configure a mcast address */

Arguable? I'd say "an M-cast" address, and I guess that's why it's
written that way. Not sure how else you'd say it, unless you always
expand it to "multicast" when reading.

johannes

