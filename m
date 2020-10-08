Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974B328714A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgJHJPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgJHJP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:15:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3B2C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 02:15:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQS1E-001VYQ-A0; Thu, 08 Oct 2020 11:15:24 +0200
Message-ID: <b81f33293406f7d0bcb45ab502c528442125997b.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 3/7] ethtool: trim policy tables
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz
Date:   Thu, 08 Oct 2020 11:15:23 +0200
In-Reply-To: <11e6b06a5d58fd1a9d108bc9c40b348311b024ba.camel@sipsolutions.net>
References: <20201005220739.2581920-1-kuba@kernel.org>
         <20201005220739.2581920-4-kuba@kernel.org>
         <7d89d3a5-884c-5aba-1248-55f9cbecbd89@gmail.com>
         (sfid-20201008_111205_538911_A87CA2B2) <11e6b06a5d58fd1a9d108bc9c40b348311b024ba.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-08 at 11:13 +0200, Johannes Berg wrote:

> > This implies that all policy tables must be 'complete'.

Also, yes they had to be complete already, perhaps *except* for NLA_FLAG
like this below use ...

> > So when later strset_parse_request() does :
> > 
> > req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
> > 
> Here was the fix
> https://lore.kernel.org/netdev/20201007125348.a74389e18168.Ieab7a871e27b9698826e75dc9e825e4ddbc852b1@changeid/

Sorry, wrong link

https://lore.kernel.org/netdev/20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid/

johannes

