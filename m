Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D822AAD7F
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgKHVCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 16:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHVCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:02:06 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA25C0613CF;
        Sun,  8 Nov 2020 13:02:06 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kbrou-003nOH-OW; Sun, 08 Nov 2020 22:01:52 +0100
Message-ID: <61cee15bf9f317c0ad2761c7f08a6bca1d2f2531.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix regression where EAPOL frames were sent
 in plaintext
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Deutschmann <whissi@gentoo.org>,
        Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Christian Hesse <list@eworm.de>
Date:   Sun, 08 Nov 2020 22:01:51 +0100
In-Reply-To: <259a6efa-da48-c946-3008-3c2edaf1a3d0@gentoo.org>
References: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>
         <259a6efa-da48-c946-3008-3c2edaf1a3d0@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-08 at 20:34 +0100, Thomas Deutschmann wrote:
> 
> 
> Can we please get this applied to linux-5.10 and linux-5.9?

It's tagged for that, so once it enters mainline will get picked up.
Should be soon now, I assume.

johannes

