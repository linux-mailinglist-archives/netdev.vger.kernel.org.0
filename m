Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B5545800B
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 19:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbhKTSjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 13:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhKTSjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 13:39:36 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C6FC061574;
        Sat, 20 Nov 2021 10:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=YvwJssbaAyTslCx3DhKGNQjtnLdAiUgVayMdjTkNBt8=;
        t=1637433392; x=1638642992; b=EGDP4M3P7Tj2LNvV/6pcZVnoq9Wrn58oxwbvGPMsO3KCc1A
        sZoar+gmXLoSD3V/5eSbCrmXF4IFwzlmU9JQXy079iW9tEKy66R5hNoCEp8lZ+X7R4PJCu4+8jBjU
        hrMz8BDxDcYt2/wcXCr0xUL85VFavBZ+KwfZ9gr9ue4VXUD17MqhHoaJEaqlkXW0q9aFe4UlvedHp
        u1uKG0ovcCg61kVsZDW/jLH7SgX2XgDPKU7kXbk4G6dn0ljAbkkYhAJY38BPMOk5qBkhI1DKLN5ys
        WiM2tO+z+l+F0dZJNIujqE7dD0JTuGP6YsduDDHq8fS/VAOFq7K4z1hm42G3Uiaw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1moVDr-000PtP-O6;
        Sat, 20 Nov 2021 19:36:23 +0100
Message-ID: <5e53fc5d2dc65c1d151d0adad1b1d6d1534c48ce.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Use memset_after() to clear tx status
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Christian Lamparter <chunkeey@gmail.com>,
        Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Sat, 20 Nov 2021 19:36:22 +0100
In-Reply-To: <75be2d3b-99c4-f84b-4da5-da0f4c220359@gmail.com>
References: <20211118203839.1289276-1-keescook@chromium.org>
         <75be2d3b-99c4-f84b-4da5-da0f4c220359@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-11-20 at 16:17 +0100, Christian Lamparter wrote:
> 
> Tested-by: Christian Lamparter <chunkeey@gmail.com> [both CARL9170+P54USB on real HW]
> 
Thanks!

johannes
