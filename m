Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C432B24EE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgKMTwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMTwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:52:30 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A85C0613D1;
        Fri, 13 Nov 2020 11:52:30 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kdf7K-0078t9-PC; Fri, 13 Nov 2020 20:52:19 +0100
Message-ID: <b8bacbe3488c99b83f335a21c9d2f06fc30ca4a7.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX
 stats
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Lev Stipakov <lstipakov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lev Stipakov <lev@openvpn.net>
Date:   Fri, 13 Nov 2020 20:52:17 +0100
In-Reply-To: <20201113115118.618f57de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
         <20201113085804.115806-1-lev@openvpn.net>
         <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
         <CAGyAFMUrNRAiDZuNa2QCJQ-JuQAUdDq3nOB17+M=wc2xNknqmQ@mail.gmail.com>
         <20201113115118.618f57de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-13 at 11:51 -0800, Jakub Kicinski wrote:
> On Fri, 13 Nov 2020 14:25:25 +0200 Lev Stipakov wrote:
> > > Seems I should take this through my tree, any objections?
> 
> Go for it, you may need to pull net-next first but that should happen
> soonish anyway, when I get to your pr.

Yeah, I'll fast forward once you have pulled that, and generally I don't
apply anything while I have open pull requests (in case I have to
rejigger or whatnot), so all should be well. :)

Thanks!

johannes

