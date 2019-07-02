Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F188E5CF3B
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfGBMPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:15:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37530 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfGBMPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:15:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hiHgf-00079y-QJ; Tue, 02 Jul 2019 14:15:06 +0200
Message-ID: <b85553d9869611f6ff04bb3bc1ee575cc788f5b2.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 02/15] netlink: rename
 nl80211_validate_nested() to nla_validate_nested()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Tue, 02 Jul 2019 14:15:04 +0200
In-Reply-To: <d0c23ac629c4a0343acc9f09484e078962c55402.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
         <d0c23ac629c4a0343acc9f09484e078962c55402.1562067622.git.mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-02 at 13:49 +0200, Michal Kubecek wrote:
> Function nl80211_validate_nested() is not specific to nl80211, it's
> a counterpart to nla_validate_nested_deprecated() with strict validation.
> For consistency with other validation and parse functions, rename it to
> nla_validate_nested().

Umm, right, not sure how that happened. Sorry about that.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net?

johannes

