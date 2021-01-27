Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB14830656E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhA0UyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhA0UyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:54:24 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9ACC061573;
        Wed, 27 Jan 2021 12:53:43 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l4ror-00CZSV-94; Wed, 27 Jan 2021 21:53:41 +0100
Message-ID: <5a73667f16a626da36d0f74a93b4dc30050996eb.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2021-01-26
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 27 Jan 2021 21:53:35 +0100
In-Reply-To: <20210126211614.76456-1-johannes@sipsolutions.net> (sfid-20210127_140406_014704_1A58B94F)
References: <20210126211614.76456-1-johannes@sipsolutions.net>
         (sfid-20210127_140406_014704_1A58B94F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-26 at 22:16 +0100, Johannes Berg wrote:
> Hi,
> 
> So here's a pretty big and invasive mac80211-next pull. It has now been
> in linux-next for some time, and all the issues that had been reported by
> people running that are fixed. I've also thrown hwsim and Intel-internal
> tests at it. However, changing the locking is somewhat dangerous, so if I
> consider it, I sort of expect some more fallout from that. I did sprinkle
> lockdep assertions fairly liberally, so we'll see.

I guess I'll withdraw this (and send a new one soon), there was a
virt_wifi regression - forgot to update it with the new approach.

johannes

