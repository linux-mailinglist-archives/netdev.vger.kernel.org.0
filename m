Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7B3B158F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhFWISM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFWISL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:18:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5872C061574;
        Wed, 23 Jun 2021 01:15:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lvy32-00ATyc-LY; Wed, 23 Jun 2021 10:15:48 +0200
Message-ID: <4485b4d67e7d54702f7c35a0f6fe6ffd24b613be.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] cfg80211: Add wiphy_info_once()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dmitry Osipenko <digetx@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 23 Jun 2021 10:15:47 +0200
In-Reply-To: <46a3cb5a-2ce3-997b-154d-dd4e1b7333d1@gmail.com> (sfid-20210619_130247_991465_6815775A)
References: <20210511211549.30571-1-digetx@gmail.com>
         <e7495304-d62c-fd20-fab3-3930735f2076@gmail.com>
         <87r1gyid39.fsf@codeaurora.org>
         <46a3cb5a-2ce3-997b-154d-dd4e1b7333d1@gmail.com>
         (sfid-20210619_130247_991465_6815775A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-06-19 at 14:02 +0300, Dmitry Osipenko wrote:
> 
> Johannes, are these patches good to you?
> 
Yeah, that's fine. I was going to pick it up now but I guess it'll be
faster for Kalle to do that, so

Acked-by: Johannes Berg <johannes@sipsolutions.net>

and I'll assign it to Kalle in patchwork.

johannes

