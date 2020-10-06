Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3E284640
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgJFGnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:43:40 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8A6C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:43:40 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPggw-000550-6K; Tue, 06 Oct 2020 08:43:20 +0200
Message-ID: <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz
Date:   Tue, 06 Oct 2020 08:43:17 +0200
In-Reply-To: <20201005220739.2581920-1-kuba@kernel.org>
References: <20201005220739.2581920-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 15:07 -0700, Jakub Kicinski wrote:
> Hi!
> 
> This series wires up ethtool policies to ops, so they can be
> dumped to user space for feature discovery.
> 
> First patch wires up GET commands, and second patch wires up SETs.
> 
> The policy tables are trimmed to save space and LoC.
> 
> Next - take care of linking up nested policies for the header
> (which is the policy what we actually care about). And once header
> policy is linked make sure that attribute range validation for flags
> is done by policy, not a conditions in the code. New type of policy
> is needed to validate masks (patch 6).
> 
> Netlink as always staying a step ahead of all the other kernel
> API interfaces :)
> 
> v2:
>  - merge patches 1 & 2 -> 1
>  - add patch 3 & 5
>  - remove .max_attr from struct ethnl_request_ops
> 

Looks good!

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

