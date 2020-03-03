Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3506C1782AC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgCCS6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:58:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60800 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgCCS6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:58:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9Ckc-00DUJb-FQ; Tue, 03 Mar 2020 19:58:42 +0100
Message-ID: <62f6a04e5b1231e533572bfebcae791b1ad57bb7.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 0/3] nl80211: add missing attribute validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org
Date:   Tue, 03 Mar 2020 19:58:41 +0100
In-Reply-To: <20200303095332.138ce9b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200303051058.4089398-1-kuba@kernel.org>
         <e5d88e0dbca9cc445caa95cfe32edda52f6b193d.camel@sipsolutions.net>
         <20200303095332.138ce9b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-03 at 09:53 -0800, Jakub Kicinski wrote:
> On Tue, 03 Mar 2020 08:29:46 +0100 Johannes Berg wrote:
> > Hi Jakub,
> > 
> > > Wireless seems to be missing a handful of netlink policy entries.  
> > 
> > Yep, these look good to me.
> > 
> > Here's a
> > 
> > Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > if you want to apply them directly? 
> 
> Up to Dave, I only put a maintainer hat to cover for Dave when he's
> away :)

Ah, ok; I'll just take them then, that's easier.

johannes

