Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E962B2EC633
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbhAFWYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbhAFWYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:24:39 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42138C061757;
        Wed,  6 Jan 2021 14:23:59 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kxHCq-002gWk-KK; Wed, 06 Jan 2021 23:23:43 +0100
Message-ID: <220ccdfe5f7fad6483816cf470a506d250277a1a.camel@sipsolutions.net>
Subject: Re: linux-next: build warning after merge of the origin tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Wed, 06 Jan 2021 23:23:42 +0100
In-Reply-To: <20210107090550.725f9dc9@canb.auug.org.au> (sfid-20210106_230900_992127_37DD3A83)
References: <20210107090550.725f9dc9@canb.auug.org.au>
         (sfid-20210106_230900_992127_37DD3A83)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Thu, 2021-01-07 at 09:05 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Building Linus' tree, today's linux-next build (htmldocs) produced
> this warning:
> 
> include/net/mac80211.h:4200: warning: Function parameter or member 'set_sar_specs' not described in 'ieee80211_ops'
> 
> Introduced by commit
> 
>   c534e093d865 ("mac80211: add ieee80211_set_sar_specs")
> 
> Sorry, I missed this earlier.

Right, thanks. I believe I also fixed it in the patch I sent a few days
ago that fixed the other documentation warning related to SAR that you
reported.

Thanks,
johannes

