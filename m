Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3226C13DACD
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgAPM73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:59:29 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgAPM71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:59:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1is4jz-00C8Ha-5U; Thu, 16 Jan 2020 13:59:15 +0100
Message-ID: <d9e0af66e2d8cb26ef595e1a2133f55567f4b5e0.camel@sipsolutions.net>
Subject: Re: [PATCH -next] mac80111: fix build error without
 CONFIG_ATH11K_DEBUGFS
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Chen Zhou <chenzhou10@huawei.com>, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 16 Jan 2020 13:59:13 +0100
In-Reply-To: <20200116125155.166749-1-chenzhou10@huawei.com>
References: <20200116125155.166749-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-01-16 at 20:51 +0800, Chen Zhou wrote:
> If CONFIG_ATH11K_DEBUGFS is n, build fails:
> 
> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
> drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: struct ath11k has no member named debug
>   ar->debug.htt_stats.stats_req = stats_req;
>       ^~
> and many more similar messages.
> 
> Select ATH11K_DEBUGFS under config MAC80211_DEBUGFS to fix this.

Heh, no. You need to find a way in ath11 to fix this.

johannes

