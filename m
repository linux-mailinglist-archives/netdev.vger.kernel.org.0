Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41230651101
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiLSRKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiLSRJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:09:28 -0500
Received: from box.opentheblackbox.net (box.opentheblackbox.net [172.105.151.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673AF13F1C
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:08:57 -0800 (PST)
Received: from authenticated-user (box.opentheblackbox.net [172.105.151.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.opentheblackbox.net (Postfix) with ESMTPSA id BBE813F589;
        Mon, 19 Dec 2022 12:08:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pgazz.com; s=mail;
        t=1671469731; bh=2z/RdLC67skNWPnka/S+ZiN5XyR2+M85/rUK4V27W9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DURfx8p576SdWv8ZiqxsBqaDdkz5cHEwIvpskizKwKeVzql57/Ip2WZEuvmy8gkwV
         3CwXBCsyqULzi0nDxttP5W+Cgc4jbdCzeYrUIXubK2v5/DT0HLLyvhLWowheHO60bV
         YlhDFVKWtzPbVRikRU/QFfIDFbX1tgALHipQS5+g8Jk2JXuSyZTZob/axLWge96OTS
         bl+DcKgG1B4ln86ljULvjCswIArYNgMkgXrA8zLRPrOZBGurV9tuRYWcuow6/BN4GL
         sVtIixLPAAhnHmBuRc3FVqp6beofw47aBLpAc8H7Oyyz33uJxcb97btgCG3UpXj7A5
         VLJsyB1Ije1vA==
Date:   Mon, 19 Dec 2022 12:08:48 -0500
From:   Paul Gazzillo <paul@pgazz.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <20221219170848.ia7houw2u4ajgxbn@device>
References: <20221216215509.821591-1-paul@pgazz.com>
 <20221216212943.05813d44@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216212943.05813d44@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/2022, Jakub Kicinski wrote:
> On Fri, 16 Dec 2022 16:54:48 -0500 Paul Gazzillo wrote:
> > This fix adds "select NET_DEVLINK" link to OCTEONTX2_PF's Kconfig
> > specification to match OCTEONTX2_AF.
> 
> Where was the use of devlink introduced in OCTEONTX2_PF?
> Could you provide a Fixes tag?

It looks like it was introduced in

  2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")

I will send a new version of the patch with a "Fixes:" tag now.
