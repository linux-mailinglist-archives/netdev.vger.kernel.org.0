Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3E280D84
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 08:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgJBGeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBGeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 02:34:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DA7C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 23:34:24 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOEe6-00F5Xx-BT; Fri, 02 Oct 2020 08:34:22 +0200
Message-ID: <206c1e231253f06190bc02bd60c6a98b4aebe789.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 10/10] genetlink: allow dumping
 command-specific policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Fri, 02 Oct 2020 08:34:21 +0200
In-Reply-To: <20201001225933.1373426-11-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001225933.1373426-11-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 15:59 -0700, Jakub Kicinski wrote:
> Right now CTRL_CMD_GETPOLICY can only dump the family-wide
> policy. Support dumping policy of a specific op.
> 
> v2:
>  - make cmd U32, just in case.
> v1:
>  - don't echo op in the output in a naive way, this should
>    make it cleaner to extend the output format for dumping
>    policies for all the commands at once in the future.

Great, thanks :)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

