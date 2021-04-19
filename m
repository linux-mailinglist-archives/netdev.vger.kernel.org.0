Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D64363F3D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbhDSJz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbhDSJzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:55:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC9CC061760;
        Mon, 19 Apr 2021 02:55:25 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lYQce-00Dinb-Ip; Mon, 19 Apr 2021 11:55:16 +0200
Message-ID: <9b1305868349b8f61dae2a214084a7d2e80748f2.camel@sipsolutions.net>
Subject: Re: iwlwifi: Microcode SW error
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Gonsolo <gonsolo@gmail.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 19 Apr 2021 11:55:15 +0200
In-Reply-To: <CANL0fFTree1UQugYMHtO3S9ktPCP85J_wm-hMqwT3MQBZ-yHKg@mail.gmail.com> (sfid-20210419_115438_271689_7347BA40)
References: <20210419090800.GA52493@limone.gonsolo.de>
         <12e0173e43391fa70b9c199c31522b44a42ca03a.camel@sipsolutions.net>
         <CANL0fFTree1UQugYMHtO3S9ktPCP85J_wm-hMqwT3MQBZ-yHKg@mail.gmail.com>
         (sfid-20210419_115438_271689_7347BA40)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-19 at 11:54 +0200, Gonsolo wrote:
> > Do you use MFP?
> 
> I don't think so. I'm running unmodified kernels from Ubuntu PPA and
> don't meddle with WIFI configs.
> How can I find out?
> 
> > Could be related to
> > https://patchwork.kernel.org/project/linux-wireless/patch/20210416134702.ef8486a64293.If0a9025b39c71bb91b11dd6ac45547aba682df34@changeid/
> > I saw similar issues internally without that fix.
> 
> A quick "git grep" didn't show any of these two patches in the 5.12-
> rc7 kernel.
> 
Yeah, my bad, I only put the offending patch into -next, I
misremembered. Sorry for the noise.

johannes

