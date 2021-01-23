Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7F23018A4
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 23:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbhAWWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 17:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAWWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 17:16:36 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77641C0613D6;
        Sat, 23 Jan 2021 14:15:56 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l3RCB-00Aicf-K9; Sat, 23 Jan 2021 23:15:51 +0100
Message-ID: <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-01-18.2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Hans de Goede <hdegoede@redhat.com>, netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, ilan.peer@intel.com,
        luciano.coelho@intel.com
Date:   Sat, 23 Jan 2021 23:15:50 +0100
In-Reply-To: <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
         <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-23 at 22:31 +0100, Hans de Goede wrote:
> 
> So I'm afraid that I have some bad news about this patch, it fixes
> the RCU warning which I reported:
> 
> https://lore.kernel.org/linux-wireless/20210104170713.66956-1-hdegoede@redhat.com/
> 
> But it introduces a deadlock. See:
> 
> https://lore.kernel.org/linux-wireless/d839ab62-e4bc-56f0-d861-f172bf19c4b3@redhat.com/
> 
> for details. Note we really should fix this new deadlock before 5.11
> is released. This is worse then the RCU warning which this patch fixes.

Ouch. Thanks for the heads-up. I guess I'll revert both patches for now,
unless we can quickly figure out a way to get all these paths in order.

Thanks,
johannes

