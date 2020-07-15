Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94DE2211F5
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGOQIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGOQHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:07:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB58C08C5DD;
        Wed, 15 Jul 2020 09:07:02 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jvjvi-005F6w-Mh; Wed, 15 Jul 2020 18:06:46 +0200
Message-ID: <d2b68464a9a7dd18ea39d1f1d483c8d4bc12c540.camel@sipsolutions.net>
Subject: Re: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in
 comments
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 15 Jul 2020 18:06:30 +0200
In-Reply-To: <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200715025914.28091-1-rdunlap@infradead.org>
         <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 08:48 -0700, Jakub Kicinski wrote:
> On Tue, 14 Jul 2020 19:59:02 -0700 Randy Dunlap wrote:
> > Drop doubled words in several comments.
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> 
> Hi Randy, the WiFi stuff goes through Johannes's mac80211 tree.

It can go to you if you like, for this, I have no problem with that.
Though I saw only the subject right now :)

> Would you mind splitting those 5 patches out to a separate series and
> sending to him?

linux-wireless@vger.kernel.org would be most important in that case, so
patchwork there picks it up.

Thanks,
johannes

