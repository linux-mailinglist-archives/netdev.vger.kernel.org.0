Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD23D27FAA3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgJAHx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgJAHx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:53:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2345C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:53:26 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtP3-00ESRZ-6s; Thu, 01 Oct 2020 09:53:25 +0200
Message-ID: <6eff3aff2667adc8477eb1404df216562c067315.camel@sipsolutions.net>
Subject: Re: [RFC net-next 7/9] genetlink: bring back per op policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:53:24 +0200
In-Reply-To: <20201001000518.685243-8-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-8-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> Add policy to the struct genl_ops structure, this time
> with maxattr, so it can be used properly.
> 
> Propagate .policy and .maxattr from the family
> in genl_get_cmd() if needed, this say the rest of the

typo: "this way"

> code does not have to worry if the policy is per op
> or global.

Maybe make 'taskstats', which I munged a bit in commit 3b0f31f2b8c9
("genetlink: make policy common to family") go back to using per-command 
policy - properly this time with maxattr?


But the code here looks good to me.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

