Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D4197790
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 11:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgC3JOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 05:14:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51758 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC3JOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 05:14:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jIqUU-005V0y-5v; Mon, 30 Mar 2020 11:13:54 +0200
Message-ID: <af52dddb54817ddd2f7f2ff61e2fe8481112c572.camel@sipsolutions.net>
Subject: Re: Linux 5.6.0 regression: wlan0: authentication with
 64:66:b3:xx:xx:xx timed out
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sander Eikelenboom <linux@eikelenboom.it>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Date:   Mon, 30 Mar 2020 11:13:52 +0200
In-Reply-To: <56dfeca2-71cc-c601-06fc-4ebe9627ba74@eikelenboom.it>
References: <56dfeca2-71cc-c601-06fc-4ebe9627ba74@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-30 at 10:52 +0200, Sander Eikelenboom wrote:
> L.S.,
> 
> Linux 5.6.0 has a regression compared to my previous build of Linus his
> tree 5.6-rc7-ish (pulled and build on 2020-03-26), so it must be
> introduced in one of the last 2 netdev pulls.
> 
> Both my laptops don't connect to Wifi any more, wifi hardware is intel:
>     03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 83)
> 
> Logging shows a repeat of:
>     [  512.085509] wlan0: authentication with 64:66:b3:xx:xx:xx timed out
>     [  521.048959] wlan0: authenticate with 64:66:b3:be:b6:cc
>     [  521.052416] wlan0: send auth to 64:66:b3:xx:xx:xx (try 1/3)
>     [  521.053199] wlan0: send auth to 64:66:b3:xx:xx:xx (try 2/3)
>     [  521.053209] wlan0: send auth to 64:66:b3:xx:xx:xx (try 3/3)
> 
> Any ideas ?
> (will probably have some time to bisect later today)

Yeah, sorry, my bad.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240

johannes

