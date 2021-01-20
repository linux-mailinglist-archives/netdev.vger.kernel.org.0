Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999A82FD7A8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbhATSAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390641AbhATSAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:00:04 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD06EC0613D3;
        Wed, 20 Jan 2021 09:59:23 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l2HlK-009EYH-5o; Wed, 20 Jan 2021 18:59:22 +0100
Message-ID: <c066813abc5830eb094ae0c343a71e88b775b441.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-01-18.2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Wed, 20 Jan 2021 18:59:21 +0100
In-Reply-To: <161101020906.2232.13826999223880000897.git-patchwork-notify@kernel.org> (sfid-20210118_235212_406535_B618B30A)
References: <20210118204750.7243-1-johannes@sipsolutions.net>
         <161101020906.2232.13826999223880000897.git-patchwork-notify@kernel.org>
         (sfid-20210118_235212_406535_B618B30A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> This pull request was applied to netdev/net.git (refs/heads/master):

Since you pulled this now, question:

I have some pending content for mac80211-next/net-next that either
conflicts with or requires a fix from here, or such.

Could you pull net into net-next, so I can get it into mac80211-next? Or
do you prefer another approach here? I could also double-apply the
single patch, or pull myself but then we'd get a lot of net content into
net-next only via mac80211-next which seems odd.

Thanks,
johannes

