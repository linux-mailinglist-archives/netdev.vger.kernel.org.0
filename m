Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BC6375A16
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhEFSVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 14:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhEFSVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 14:21:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6DFC061574;
        Thu,  6 May 2021 11:20:08 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1leibN-0056UK-Uy; Thu, 06 May 2021 20:19:58 +0200
Message-ID: <cc2f068d6c82d12de920b19270c6f42dfcabfd11.camel@sipsolutions.net>
Subject: Re: [PATCH v1] mac80211_hwsim: add concurrent channels scanning
 support over virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Weilun Du <wdu@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@android.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 06 May 2021 20:19:57 +0200
In-Reply-To: <20210506180530.3418576-1-wdu@google.com> (sfid-20210506_200535_215916_3E2492D1)
References: <20210506180530.3418576-1-wdu@google.com>
         (sfid-20210506_200535_215916_3E2492D1)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-06 at 11:05 -0700, Weilun Du wrote:
> This fixed the crash when setting channels to 2 or more when
> communicating over virtio.

Interesting, I thought I was probably the only user of virtio? :)

johannes

