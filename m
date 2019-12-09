Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75FC117B66
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfLIXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:21:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47048 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 18:21:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ieSLO-00GuTC-19; Tue, 10 Dec 2019 00:21:34 +0100
Message-ID: <c64e986c976b6b647b86c1243d356a8b78483c36.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/5] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 00:21:33 +0100
In-Reply-To: <54d6f040b283ad19e739d3b5a05d249285231c54.camel@sipsolutions.net>
References: <cover.1575920565.git.mkubecek@suse.cz>
         <0f4b780d5dd38109768d863781b0ce6de9ef4fbb.1575920565.git.mkubecek@suse.cz>
         <54d6f040b283ad19e739d3b5a05d249285231c54.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-12-10 at 00:20 +0100, Johannes Berg wrote:
> On Mon, 2019-12-09 at 20:55 +0100, Michal Kubecek wrote:
> > +	if (memchr_inv(dev->perm_addr, '\0', dev->addr_len) &&
> 
> Why not simply !is_zero_ether_addr()?

Ugh, sorry, ignore me. I need to go sleep instead of looking at patches.

johannes

