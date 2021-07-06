Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A263BD945
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhGFPAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhGFPAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:00:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57446C06178C;
        Tue,  6 Jul 2021 07:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=j8Y5c0H33Ia3JLD8S4h0ACVfAmyfFdJe7qBjkxt1vcE=;
        t=1625580555; x=1626790155; b=OCb18fdbY/uMjS4/Us1oyaU+Npg3O2wO2kSFWbCc2jkZiXa
        DuQ3g5QdbuM5Taktowuuysft+YS5Hv8z/IwwJUGUjTP851vjBJe+k1O+uczMwKflKrbhhsjWGKFyS
        LsntSypW/BuOViQAirTvDItnM5dUWPQ2GFR2QTgDhJxgHfMhBLwWlK3TBWgV/YqtGfDqrB1FYSjU9
        15VhGi/ZVRbelXq4GvzFKjnvAskya2n7UDwXkcvs+9702jaMc4wQwHYS4dM5vs+8YYVVPYXxa5v6B
        8FLj5O6lXuI7TkIQ9YMSCAUJNZwPBeHZpOkSsuvSQ0quMfQVn2r3tgLF8Oy2ayoA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m0ll8-00GFJQ-WD; Tue, 06 Jul 2021 16:09:11 +0200
Message-ID: <d1ee65748d6ee788c1f882b2f73dddaf7eb191e6.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 5.13 152/189] iwlwifi: mvm: support LONG_GROUP
 for WOWLAN_GET_STATUSES version
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 06 Jul 2021 16:09:10 +0200
In-Reply-To: <20210706111409.2058071-152-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
         <20210706111409.2058071-152-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-06 at 07:13 -0400, Sasha Levin wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> [ Upstream commit d65ab7c0e0b92056754185d3f6925d7318730e94 ]
> 
> It's been a while that the firmware uses LONG_GROUP by default
> and not LEGACY_GROUP.
> Until now the firmware wrongly advertise the WOWLAN_GET_STATUS
> command's version with LEGACY_GROUP, but it is now being fixed.

"Being fixed" here is the key - this will affect only firmware versions
that the older drivers in stable won't load. No need to backport this.

johannes

