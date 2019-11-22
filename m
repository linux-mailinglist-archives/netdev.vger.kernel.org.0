Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6063310724D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 13:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfKVMjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 07:39:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44810 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 07:39:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY8Dp-0003I7-LC; Fri, 22 Nov 2019 13:39:37 +0100
Message-ID: <2e0b6e7c1e97d57f392d7a3da843d1357a9a33f7.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: 802.11: mesh: Handle Beacon/probe response IE
 length in cfg80211_notify_new_peer_candidate() for 80211ac/ax mode.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Shashidhara C <shashidharac333@gmail.com>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 22 Nov 2019 13:39:36 +0100
In-Reply-To: <CAHG=F9_0VsZ3hFnbD4_eFmr_4D_6Oraqcu+JPOUA=SJ3u9dL9g@mail.gmail.com> (sfid-20191116_112604_647586_6EF4ABD3)
References: <CAHG=F9_0VsZ3hFnbD4_eFmr_4D_6Oraqcu+JPOUA=SJ3u9dL9g@mail.gmail.com>
         (sfid-20191116_112604_647586_6EF4ABD3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-11-16 at 15:55 +0530, Shashidhara C wrote:
> In function cfg80211_notify_new_peer_candidate(), beacon IE length (i.e. u8 ie_len) is not
> handled for processing 80211AC/AX beacon/probe response. ie_len can hold maximum 
> integer value of 255. In case of 80211AC/AX, the mesh beacon/probe response IE length 
> is more than 255, making ie_len to wrap around and causing failure while parsing
> beacon/probe response IEs in wpa_supplicant.
> 
> ie_len type in cfg80211_notify_new_peer_candidate() is modified to u16 to handle this issue.
> 
> Issue is found in v4.4.60, issue exists in latest v5.4.0-rc6. Verified the fix in v4.4.60.

[snip]

You cannot send patches as html email :)

johannes

