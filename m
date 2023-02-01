Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D12C686E9F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjBATFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBATFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:05:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA461D40
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 11:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E9BAB8227A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 19:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835A1C433EF;
        Wed,  1 Feb 2023 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675278343;
        bh=3IZ235BCKpZ3eA7Ye1OKKS1ziteKwwsUCNGmhvg7flU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezLGze41LUBuGO9l/QeKajgCXijknNiRLQxewaMr4TDL4Pw0HK2ZQcILZ+WHA3DM5
         kVjrNeScD0nHKN3oPI95xnw8EugIbPOKobKBbfmeN5KZbS1eJ5i3Hj1PtBEiJ4d1BK
         5PKNFYmxipsyeCh965C1emB6q6lkR36gTLd2KVNNknYpGAcYx+lQUkdpRD7dc4mwYa
         mpGAszCwk6w9YR26x16g86ZXaToXkVWV0Jjj5FA+tjCHJRmbuNnlV5TtyMRys/atRr
         VG77+Wu+ijs9b1PY9LOQ59XHCP6ltm6qUYOZ1z+fZwYX/hPLP+2v57pLb9oJ6qOcel
         kDn5Bo1+2Xl0g==
Date:   Wed, 1 Feb 2023 11:05:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v2 0/4] sfc: support unicast PTP
Message-ID: <20230201110541.1cf6ba7f@kernel.org>
In-Reply-To: <20230201080849.10482-1-ihuguet@redhat.com>
References: <20230131160506.47552-1-ihuguet@redhat.com>
        <20230201080849.10482-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Feb 2023 09:08:45 +0100 =C3=8D=C3=B1igo Huguet wrote:
> v2: fixed missing IS_ERR
>     added doc of missing fields in efx_ptp_rxfilter

1. don't repost within 24h, *especially* if you're reposting
because of compilation problems

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

2. please don't repost in a thread, it makes it harder for me=20
to maintain a review queue

3. drop the pointless inline in the source file in patch 4

+static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
+					     struct efx_ptp_rxfilter *rxfilter)

