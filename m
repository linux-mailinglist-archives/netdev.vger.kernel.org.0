Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877B9450140
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbhKOJ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhKOJ1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 04:27:18 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378AAC061767;
        Mon, 15 Nov 2021 01:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=mNgU5pUYaHtlF59ucnQsQussw2U6EkDAA888QTxBoI4=;
        t=1636968256; x=1638177856; b=Z6dCNfBoKkzUfEQ0kqM7scWj1Jw9zMPFSyx5qnGHSnS1KDT
        rN56fGllAP/pkJ34H5g9aT1+t4r5J64zUHyGWEUJ1MPr25xr2O6V+VVLV9xoRiZojmQuEsZ9kE0NK
        NkQeZpLLyEuOkHEk5IbTAvKepd+rgcP478cUV/Qe8PCkJaOWi9P1uDpnOqmn30egmUCmdM9w8T2l+
        mIyYhqKj0hMPmW34T3NipT3d4UgXSksIF6ZqtsA4chaWTx2VEfnOrzMe5VnWXACWHdzPud9go2/U8
        OrXzShslLNOxxk7z6pD6iVMqJqTd8mj/WiQTj1lyX7O1Oi8XUB7bJBgWPve4NwvQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mmYDb-00FWpe-60;
        Mon, 15 Nov 2021 10:24:03 +0100
Message-ID: <ed1c17fad8c824d8e0be6fa55babbbe2c92caaad.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: delete redundant free code
From:   Johannes Berg <johannes@sipsolutions.net>
To:     liuguoqiang <liuguoqiang@uniontech.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 15 Nov 2021 10:24:02 +0100
In-Reply-To: <20211115092139.24407-1-liuguoqiang@uniontech.com>
References: <20211115092139.24407-1-liuguoqiang@uniontech.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-15 at 17:21 +0800, liuguoqiang wrote:
> When kzalloc failed and rdev->sacn_req or rdev->scan_msg is null, pass a
> null pointer to kfree is redundant, delete it and return directly.
> 

Arguably then we should not set creq=NULL at the beginning?

johannes
