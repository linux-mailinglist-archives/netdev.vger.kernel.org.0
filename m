Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71968319B51
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBLIhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhBLIhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 03:37:35 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52279C061574;
        Fri, 12 Feb 2021 00:36:55 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lATwT-001m1i-Us; Fri, 12 Feb 2021 09:36:46 +0100
Message-ID: <7349fbaf5121f6781ac38d5727355d2d8725badd.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] cfg80211: Add wiphy flag to trigger STA disconnect
 after hardware restart
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
Date:   Fri, 12 Feb 2021 09:36:28 +0100
In-Reply-To: <20201215173021.5884-1-youghand@codeaurora.org>
References: <20201215173021.5884-1-youghand@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-15 at 23:00 +0530, Youghandhar Chintala wrote:
> 
>   * @WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK: The device supports bigger kek and kck keys
> + * @WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART: The device needs a trigger to
> + *	disconnect STA after target hardware restart. This flag should be
> + *	exposed by drivers which support target recovery.

You're not doing anything with this information in cfg80211, so
consequently it doesn't belong there.

johannes

