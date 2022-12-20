Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE93A65274F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiLTTtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLTTtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:49:22 -0500
Received: from box.opentheblackbox.net (box.opentheblackbox.net [IPv6:2600:3c02::f03c:92ff:fee2:82bc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A8B12AA0;
        Tue, 20 Dec 2022 11:49:21 -0800 (PST)
Received: from authenticated-user (box.opentheblackbox.net [172.105.151.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.opentheblackbox.net (Postfix) with ESMTPSA id B2B4A3EA1C;
        Tue, 20 Dec 2022 14:49:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pgazz.com; s=mail;
        t=1671565759; bh=YEdn9UuxbnZzT/vU7uDcMPxRwt0PF2O8LWosbzEhqXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OS6jFAqnIbW0xBjVDVUHJQEEYLsHbsDvbl/m/Ro4x7ER/fqV8BFSHO7hkSIZ1aRAt
         UBNpLD0yIt72vPGjT5g/BjW+pYNIbeZ0C22ceNPokq/1pmKVdIAvQmmg3HpOaOvWsc
         2r1NP1XWLJ4f3Bx2M8XhqblFNB7OzPMNkE79+yO9isYtWgM7fwlnT7VmwNqTC5ONqR
         Ywrnevo+JkoKLp0n3VfP4Jti3QtQFJtn3I13IkpgMYAX3Ns0w7jyaz5zRou9PnHCb8
         gQOskTXUSE7jvXBJD53hAFb/kLWasz0UFuqmkSfARJzAmusnNlPRFVkXOUHVT89/kQ
         nCqJj8SCTMfxw==
Date:   Tue, 20 Dec 2022 14:49:18 -0500
From:   Paul Gazzillo <paul@pgazz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Suman Ghosh <sumang@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] octeontx2_pf: Select NET_DEVLINK when enabling
 OCTEONTX2_PF
Message-ID: <20221220194918.4mrrbbjcpj5dvps3@device>
References: <20221219171918.834772-1-paul@pgazz.com>
 <20221220113822.4efe142e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220113822.4efe142e@kernel.org>
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,RCVD_IN_XBL,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/2022, Jakub Kicinski wrote:
> On Mon, 19 Dec 2022 12:19:11 -0500 Paul Gazzillo wrote:
> > When using COMPILE_TEST, the driver controlled by OCTEONTX2_PF does
> > not select NET_DEVLINK while the related OCTEONTX2_AF driver does.
> > This means that when OCTEONTX2_PF is enabled from a default
> > configuration, linker errors will occur due to undefined references to
> > code controlled by NET_DEVLINK.
> 
> This has been fixed a long time ago by 9cbc3367968d ("octeontx2-pf:
> select CONFIG_NET_DEVLINK") no?

You are right.  My apologies.  I was looking at an older kernel.
