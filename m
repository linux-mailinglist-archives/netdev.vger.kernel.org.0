Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF7E58EA7B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiHJKep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiHJKen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:34:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3385F78239
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=IbBQXMyv3rqbWI16mL5F6sn9rYvBnAqSYMOL+bQ/UVs=;
        t=1660127682; x=1661337282; b=jjadl8LW26CojCV0vve3+znBhgDd764Uv+CNP+Vz5w0hU1K
        2t8Mk6GE13x5+GoIXIe2jlrIuPOHNQocYYDcZePBvZKzQlmcXgzBcz0jRrcKUGxnNngpV3LWUhuK5
        fO0zb2Buz13RG6N6YdsaR6DI1/q0cJnYUd7fD34yTBjI0xnaLFA4Gv6y1oD/U7LsbpwLQWd/7tZ14
        cDVERrXtpdqaNVN2xr4Sa4t/5yZl1+y5BgB0W2CVu16ewOpr+U8WVGZfXUbtP2SZoOwsvdUgdveqJ
        RQWt/IyIpL9t76NOv7VEdSVLOh9GrdEERf/CdpoJYwcEJ06khBmaeydZm0ZvBetg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oLj2p-0047ue-2O;
        Wed, 10 Aug 2022 12:34:35 +0200
Message-ID: <613dcf498fefaffa1db2fc2bfd71706a3b786b04.camel@sipsolutions.net>
Subject: Re: [PATCH net] genetlink: correct uAPI defines
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Date:   Wed, 10 Aug 2022 12:34:34 +0200
In-Reply-To: <20220809232740.405668-1-kuba@kernel.org>
References: <20220809232740.405668-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-09 at 16:27 -0700, Jakub Kicinski wrote:
> Commit 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
> seems to have copy'n'pasted things a little incorrectly.
>=20
> The #define CTRL_ATTR_MCAST_GRP_MAX should have stayed right
> after the previous enum. The new CTRL_ATTR_POLICY_* needs
> its own define for MAX and that max should not contain the
> superfluous _DUMP in the name.
>=20
> We probably can't do anything about the CTRL_ATTR_POLICY_DUMP_MAX
> any more, there's likely code which uses it. For consistency
> (*cough* codegen *cough*) let's add the correctly name define
> nonetheless.

Oops, yes, that all makes sense.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes


