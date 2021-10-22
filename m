Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE5D437EB8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhJVTjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhJVTjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 15:39:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192EEC061227;
        Fri, 22 Oct 2021 12:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=JPIspCDfexT9JrVL4oywe0eeOUfqUKYAbsQowSBKIMs=;
        t=1634931409; x=1636141009; b=fyWhWdQLPMAY5MnuBgK7yrNWHRF3cuNV2GtaBS4OQ00WiiF
        /B3AEvAbWvJ5snzrowrHCPIx2MuEMllTafRMLUUORmra0gmNNNrF4pv2uj2orhQIkMiAi3sq4r4KE
        7emdtvTAmtwZNRTp2Y66wljx6+FoYyRghSepjC4PUFWUETB0v2rfIj87LtPocOH3qY/cmjX8gq2dQ
        r4ml7rT72LVaGkr7LjAJjt9taixRMAhSe/tjg6SkwXM9LE2TJ2C8Th9NBb/Ggi7HY9+t8dxaPkiuG
        Gui1l7V4aPLq1celt7XTVXxgV1AKxs+1/2s3/J6xcIIYNio5OqhB4o5bMK8bMtog==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1me0LN-005ll2-7o;
        Fri, 22 Oct 2021 21:36:45 +0200
Message-ID: <5e093d1aa26f0b442dd37c293ae57fcc837e448a.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-10-21
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Fri, 22 Oct 2021 21:36:44 +0200
In-Reply-To: <163493100739.20489.10617693347363757800.git-patchwork-notify@kernel.org>
References: <20211021154351.134297-1-johannes@sipsolutions.net>
         <163493100739.20489.10617693347363757800.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-10-22 at 19:30 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> This pull request was applied to netdev/net.git (master)
> by Jakub Kicinski <kuba@kernel.org>:

Thanks.

I have a patch or two that are for -next but depend on this, any chance
of pulling net into net-next some time, perhaps after it goes to Linus?

johannes

