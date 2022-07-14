Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD835752BB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiGNQ15 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Jul 2022 12:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238719AbiGNQ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:27:56 -0400
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1612362A6E
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:27:56 -0700 (PDT)
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay13.hostedemail.com (Postfix) with ESMTP id 8A3AB60126;
        Thu, 14 Jul 2022 16:27:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 1BC6220027;
        Thu, 14 Jul 2022 16:27:52 +0000 (UTC)
Message-ID: <3bd7e3d14c63a50d869ab10fcba4fd93d17745c0.camel@perches.com>
Subject: Re: [PATCH net-next] net: prestera: acl: fix code formatting
From:   Joe Perches <joe@perches.com>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 09:27:52 -0700
In-Reply-To: <20220714161704.2370010-1-maksym.glubokiy@plvision.eu>
References: <20220714161704.2370010-1-maksym.glubokiy@plvision.eu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: ri8f6md636nzmezryufjhr5qz9mb498k
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 1BC6220027
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/x9wSdw6fs9vKhTg30/+ToOlxtc4sa3yg=
X-HE-Tag: 1657816072-806075
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-14 at 19:17 +0300, Maksym Glubokiy wrote:
> Make the code look better.
> 
> Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> ---
>  .../net/ethernet/marvell/prestera/prestera_flower.c    | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
[]
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> -/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
> +/* Copyright (c) 2020-2022 Marvell International Ltd. All rights reserved */

What gives you the right to extend Marvell's copyright?

In general, don't change copyright for whitespace changes
and unless you are the copyright owner.

