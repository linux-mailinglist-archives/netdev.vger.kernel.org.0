Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4862808BF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 22:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732988AbgJAUtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732836AbgJAUtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 16:49:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA356C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 13:49:01 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO5Vb-00EoRg-UR; Thu, 01 Oct 2020 22:49:00 +0200
Message-ID: <a11f68716146d9e1b9d29bda4640bc7a57350244.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 7/9] taskstats: move specifying netlink policy
 back to ops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        bsingharora@gmail.com
Date:   Thu, 01 Oct 2020 22:48:58 +0200
In-Reply-To: <20201001183016.1259870-8-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
         <20201001183016.1259870-8-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> @@ -44,7 +44,7 @@ static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1
>   * We have to use TASKSTATS_CMD_ATTR_MAX here, it is the maxattr in the family.
>   * Make sure they are always aligned.
> 

Probably worth also removing/updating the comments?

But otherwise,

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

and I think that is much better than the hacks I put there at the time,
and also of course better than what it had originally without a per-op
maxattr. :)

johannes

