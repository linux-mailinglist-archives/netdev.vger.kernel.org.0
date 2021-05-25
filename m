Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9907538FFCD
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhEYLOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhEYLOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 07:14:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3577AC061574;
        Tue, 25 May 2021 04:13:00 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1llUzO-00EMeA-63; Tue, 25 May 2021 13:12:46 +0200
Message-ID: <8d0cc8941fdefa19e59651202443f1d50f2542a2.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix inconsistent indenting
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 13:12:45 +0200
In-Reply-To: <1621940233-70879-1-git-send-email-jiapeng.chong@linux.alibaba.com> (sfid-20210525_125729_917249_DCBAF50D)
References: <1621940233-70879-1-git-send-email-jiapeng.chong@linux.alibaba.com>
         (sfid-20210525_125729_917249_DCBAF50D)
Content-Type: text/plain
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrong subject - this isn't related to cfg80211, it's ath6kl.

johannes

