Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB157302370
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 11:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbhAYKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 05:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbhAYJ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:59:08 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DDDC061797;
        Mon, 25 Jan 2021 01:56:30 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l3ybe-00BNBH-GM; Mon, 25 Jan 2021 10:56:22 +0100
Message-ID: <0ef59ce1cfd6cb967ef9a6e38656e4535e900be1.camel@sipsolutions.net>
Subject: Re: linux-next boot error: WARNING in cfg80211_register_netdevice
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+2c4a63c6480a7457eca5@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Date:   Mon, 25 Jan 2021 10:56:20 +0100
In-Reply-To: <0000000000001ac5af05b9b67e2d@google.com> (sfid-20210125_105215_796443_0B5ABC83)
References: <0000000000001ac5af05b9b67e2d@google.com>
         (sfid-20210125_105215_796443_0B5ABC83)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-25 at 01:52 -0800, syzbot wrote:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at net/wireless/core.c:1336 cfg80211_register_netdevice+0x235/0x330 net/wireless/core.c:1336
> 


Yes, umm. I accidentally *copied* that line a few lines further down
rather than *moving* it down. Ilan told me about it yesterday but I
didn't have time to check and fix it up. It's fixed in mac80211-next
now.

johannes

