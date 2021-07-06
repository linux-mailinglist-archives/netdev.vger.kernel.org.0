Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846753BD93F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhGFPAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhGFPAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:00:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C674C06178A;
        Tue,  6 Jul 2021 07:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zLbk1KMb94lN4WyagF60TMTpGhrVyXuBLOF6dlhWQwg=;
        t=1625580497; x=1626790097; b=NKzseJ8x9J/EW61FBGWbh3pXeCd1+ORwVX7m+1RGVXkCbGq
        abp5DRvhRZNTacfoa9GBMLta+RieQEohelWqb2Euid/F4oiHgSMfSPHEtzt7Cbsw7ayQtTtuQvxX9
        q2ZgFAdeG/spAMcZlTFUJnXKTrPPCAj7FF6o234rVKbNDQrBZ95q6mNeliiMCQe7wJGJHgANZLcEi
        TQ+S/V8OZ2ot/uuApAodmiFtTYnrQxAHpdBrsEW5rVDT2qVIbtdOAOv1h9e20qEes4hfVkGquYXSH
        NpYDC0m4Z5cUNgfsJEXLxpq7hm2C/D4eGQX4y7FOnMq0UgOHu6HcH9ogkE1uqN4A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m0lkA-00GFGi-ID; Tue, 06 Jul 2021 16:08:10 +0200
Message-ID: <5da1f4fbdac533be3b753e54b43e2058ba270bc8.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 5.10 113/137] wireless: wext-spy: Fix
 out-of-bounds warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 06 Jul 2021 16:08:09 +0200
In-Reply-To: <20210706112203.2062605-113-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
         <20210706112203.2062605-113-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-06 at 07:21 -0400, Sasha Levin wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> [ Upstream commit e93bdd78406da9ed01554c51e38b2a02c8ef8025 ]
> 
> Fix the following out-of-bounds warning:
> 
> net/wireless/wext-spy.c:178:2: warning: 'memcpy' offset [25, 28] from the object at 'threshold' is out of the bounds of referenced subobject 'low' with type 'struct iw_quality' at offset 20 [-Warray-bounds]

For the record: while this clearly isn't harmful, there's almost
basically no chance that the stable kernel will ever compile warning-
free with -Warray-bounds, so there's not much point in backporting this
patch.

johannes

