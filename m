Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5356281A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732869AbfGHSND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:13:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46688 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbfGHSND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 14:13:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hkY8D-0004Kj-3a; Mon, 08 Jul 2019 20:12:53 +0200
Message-ID: <533462cfc4cf42be9886078a1d8b450d07cbbf6e.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Jul 2019 20:12:50 +0200
In-Reply-To: <20190708172729.GC24474@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
         <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
         <20190702122521.GN2250@nanopsycho> <20190702145241.GD20101@unicorn.suse.cz>
         <20190703084151.GR2250@nanopsycho> <20190708172729.GC24474@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-08 at 19:27 +0200, Michal Kubecek wrote:
> 
> Second reason is that with 8-bit genetlink command/message id, the space
> is not as infinite as it might seem.

FWIW, there isn't really any good reason for this, we have like 16
reserved bits in the genl header.

OTOH, having a LOT of ops will certainly cost space in the kernel
image...

johannes

