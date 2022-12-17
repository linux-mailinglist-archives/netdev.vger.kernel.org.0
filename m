Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AF864F7D1
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 06:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiLQF3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 00:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiLQF3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 00:29:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7F62A965;
        Fri, 16 Dec 2022 21:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 659AD60A09;
        Sat, 17 Dec 2022 05:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E1BC433EF;
        Sat, 17 Dec 2022 05:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671254984;
        bh=4xg48u76THmM/MI/b0HcJp3H2GWMCgy1h7bWhtb3oCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bbz/VJ3+s8CXVh/Mo6b7TxsuO2sPO0Jh/70GpNVfLSmHHvTTL7Z9B2MAAaiz9crn7
         96paFl85wNo+bj4irgW7eWOxIMYO1rK7MS+a2KnxFUiu0M5lhHAD83aaUueiIMTjUE
         jRM3MCfD5TiMUG3uxeNRatNZZE3IQdBY1LpLIR2KkEtkmK7rCEJo9HyJDAmoZezMAR
         tATQInm1O6isbM8fo8ClPtwh3IVAGlRoF2paij90hdPue1g/MBZeE7rPfCnKlX9sgU
         iGdgTazjN/tLOKvmBtMPWaiRhDhalebEGFt4bj9vPrR7d32mYkiBVJZOPy+FIbCE6K
         XWz8f9+bNziEg==
Date:   Fri, 16 Dec 2022 21:29:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Gazzillo <paul@pgazz.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zheng Bin <zhengbin13@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Suman Ghosh <sumang@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2_pf: Select NET_DEVLINK when enabling
 OCTEONTX2_PF
Message-ID: <20221216212943.05813d44@kernel.org>
In-Reply-To: <20221216215509.821591-1-paul@pgazz.com>
References: <20221216215509.821591-1-paul@pgazz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Dec 2022 16:54:48 -0500 Paul Gazzillo wrote:
> This fix adds "select NET_DEVLINK" link to OCTEONTX2_PF's Kconfig
> specification to match OCTEONTX2_AF.

Where was the use of devlink introduced in OCTEONTX2_PF?
Could you provide a Fixes tag?
