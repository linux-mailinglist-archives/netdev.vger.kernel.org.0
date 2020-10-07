Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71433285DAB
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgJGK43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgJGK43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:56:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEA3C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:56:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQ76o-000qyW-Cq; Wed, 07 Oct 2020 12:55:46 +0200
Message-ID: <33ee6ec537894a614bcb8fa5ee3e5bf3128f4809.camel@sipsolutions.net>
Subject: Re: [net-next v2 3/8] net: mac80211: convert tasklets to use new
 tasklet_setup() API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Date:   Wed, 07 Oct 2020 12:55:44 +0200
In-Reply-To: <20201007101219.356499-4-allen.lkml@gmail.com> (sfid-20201007_121255_800516_4A8A4DF0)
References: <20201007101219.356499-1-allen.lkml@gmail.com>
         <20201007101219.356499-4-allen.lkml@gmail.com>
         (sfid-20201007_121255_800516_4A8A4DF0)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 15:42 +0530, Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

I'm going to assume for now that the whole series goes through the net-
next tree, holler if not.

Thanks,
johannes


