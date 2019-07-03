Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C574D5E5A5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfGCNkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:40:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38420 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfGCNkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:40:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hifUJ-0000ZL-GZ; Wed, 03 Jul 2019 15:39:55 +0200
Message-ID: <ea84d738346b96b81550e0fd0a6c715faa323061.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 07/15] ethtool: support for netlink
 notifications
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Wed, 03 Jul 2019 15:39:54 +0200
In-Reply-To: <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
         <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-02 at 13:50 +0200, Michal Kubecek wrote:
> 
> +static bool ethnl_ok __read_mostly;

Not sure it makes a big difference, but it could probably be
__ro_after_init instead?

johannes

