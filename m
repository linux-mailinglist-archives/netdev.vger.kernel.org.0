Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61962EC65B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbhAFWrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbhAFWrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:47:41 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52486C061575;
        Wed,  6 Jan 2021 14:47:00 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kxHZE-002h5q-OV; Wed, 06 Jan 2021 23:46:51 +0100
Message-ID: <5d8482756d40df615f908d7f24decdbb9ccb0ac3.camel@sipsolutions.net>
Subject: Re: linux-next: build warning after merge of the origin tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-wireless@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Wed, 06 Jan 2021 23:46:45 +0100
In-Reply-To: <20210107094414.607e884e@canb.auug.org.au>
References: <20210107090550.725f9dc9@canb.auug.org.au>
         <220ccdfe5f7fad6483816cf470a506d250277a1a.camel@sipsolutions.net>
         <20210107094414.607e884e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

> > Right, thanks. I believe I also fixed it in the patch I sent a few days
> > ago that fixed the other documentation warning related to SAR that you
> > reported.
> 
> I don't think so :-(  I did a htmldocs build with your patch ([PATCH
> v2] cfg80211/mac80211: fix kernel-doc for SAR APIs) on top of Linus'
> tree and still got this warning.  That patch did not touch
> include/net/mac80211.h ...

Umm, I don't know what to say. I even added "cfg80211/mac80211" to the
subject, but somehow lost the change to mac80211.h. Sorry about that :(

I'll get a v3 out.

johannes

