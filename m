Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3711307566
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhA1MAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhA1MAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:00:02 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460B3C061573;
        Thu, 28 Jan 2021 03:59:22 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l55x8-00CqR7-CW; Thu, 28 Jan 2021 12:59:10 +0100
Message-ID: <ec0c33a056d288cf7bb807cd059936e81470cd43.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: ignore the length of hide ssid is zero in scan
From:   Johannes Berg <johannes@sipsolutions.net>
To:     samirweng1979 <samirweng1979@163.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Date:   Thu, 28 Jan 2021 12:59:09 +0100
In-Reply-To: <20210128115652.8564-1-samirweng1979@163.com>
References: <20210128115652.8564-1-samirweng1979@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-28 at 19:56 +0800, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> If the length of hide ssid is zero in scan, don't pass
> it to driver, which doesn't make any sense.

Err, please check again how scanning works. This is quite obviously
intentional.

johannes

