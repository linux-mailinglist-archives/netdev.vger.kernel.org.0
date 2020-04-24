Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545871B70BF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgDXJX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbgDXJX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:23:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BFFC09B045;
        Fri, 24 Apr 2020 02:23:26 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRuYO-00FRIg-Ax; Fri, 24 Apr 2020 11:23:24 +0200
Message-ID: <47465ccc465917711876e08a87a58c2c61f439a2.camel@sipsolutions.net>
Subject: Re: [PATCH 3/4] net: mac80211: sta_info.c: Add lockdep condition
 for RCU list usage
From:   Johannes Berg <johannes@sipsolutions.net>
To:     madhuparnabhowmik10@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Date:   Fri, 24 Apr 2020 11:23:23 +0200
In-Reply-To: <20200409082906.27427-1-madhuparnabhowmik10@gmail.com> (sfid-20200409_102928_887141_A42D871F)
References: <20200409082906.27427-1-madhuparnabhowmik10@gmail.com>
         (sfid-20200409_102928_887141_A42D871F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-09 at 13:59 +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> The function sta_info_get_by_idx() uses RCU list primitive.
> It is called with  local->sta_mtx held from mac80211/cfg.c.
> Add lockdep expression to avoid any false positive RCU list warnings.
> 

Applied.

johannes

