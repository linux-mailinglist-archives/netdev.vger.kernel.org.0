Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE4328D406
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgJMSsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 14:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgJMSsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 14:48:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF92C0613D0;
        Tue, 13 Oct 2020 11:48:09 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kSPKz-005BE0-9J; Tue, 13 Oct 2020 20:47:53 +0200
Message-ID: <5ad3c2c6cd096b6fb5c9bedd340b927adb899213.camel@sipsolutions.net>
Subject: Re: [PATCH v6 68/80] nl80211: docs: add a description for s1g_cap
 parameter
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 13 Oct 2020 20:47:47 +0200
In-Reply-To: <9633ea7d9b0cb2f997d784df86ba92e67659f29b.1602589096.git.mchehab+huawei@kernel.org>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
         <9633ea7d9b0cb2f997d784df86ba92e67659f29b.1602589096.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Mauro.


On Tue, 2020-10-13 at 13:54 +0200, Mauro Carvalho Chehab wrote:
> Changeset df78a0c0b67d ("nl80211: S1G band and channel definitions")
> added a new parameter, but didn't add the corresponding kernel-doc
> markup, as repoted when doing "make htmldocs":
> 
> 	./include/net/cfg80211.h:471: warning: Function parameter or member 's1g_cap' not described in 'ieee80211_supported_band'
> 
> Add a documentation for it.

Should I take this through my tree, or is that part of a larger set
that'll go somewhere else?

johannes


