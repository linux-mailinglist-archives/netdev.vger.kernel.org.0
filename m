Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA61255EB21
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiF1RhO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 13:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiF1RhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:37:13 -0400
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD3A2EA31
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:37:12 -0700 (PDT)
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id D663E35E7B;
        Tue, 28 Jun 2022 17:37:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 58E282001A;
        Tue, 28 Jun 2022 17:37:08 +0000 (UTC)
Message-ID: <59f9c1674f2cd55b8182333ccb75536c365879ea.camel@perches.com>
Subject: Re: [PATCH net-next] MAINTAINERS: Add an additional maintainer to
 the AMD XGBE driver
From:   Joe Perches <joe@perches.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Date:   Tue, 28 Jun 2022 10:37:07 -0700
In-Reply-To: <324a31644b29f7211edb13f26b5ad9ab69a7f0e9.1656422252.git.thomas.lendacky@amd.com>
References: <324a31644b29f7211edb13f26b5ad9ab69a7f0e9.1656422252.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: 3rsjg4t3yibxcw5za9g7crge8xdrgnw7
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 58E282001A
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/IRLs7mUKarWI7LRvBAjsy/Z+27Yuw1lw=
X-HE-Tag: 1656437828-789444
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-06-28 at 08:17 -0500, Tom Lendacky wrote:
> Add Shyam Sundar S K as an additional maintainer to support the AMD XGBE
> network device driver.
> 
> Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -1037,6 +1037,7 @@ F:	arch/arm64/boot/dts/amd/
>  
>  AMD XGBE DRIVER
>  M:	Tom Lendacky <thomas.lendacky@amd.com>
> +M:	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

While this is a valid email address, get_maintainer assumes
name formats use "first middle last" when parsing a name
before an email address. (look around line 2460 in get_maintainer)

Perhaps this should use quotes around the name like:

M:	"Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>


