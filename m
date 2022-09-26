Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446075EB1C1
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiIZUBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIZUBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:01:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABF377EAB
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:01:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBD48B80D31
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 20:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662F7C433D6;
        Mon, 26 Sep 2022 20:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664222461;
        bh=xaJD4eFWjBh1sFl7raQG8V0Ph6uFM/zrXSMAswoljLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E0sQ40uoBsJInf2ZVs6H3F+cBMn/jttXr7JPrjKf7EmmhGc9joNcvk7PNRAHqeivg
         SDa+MUu2TJ8eoIR7aW2nnuIcd7RPfYOj3Yoh07wvrp+MeqiH9VVbYzaw5iLLH7PkZ1
         RT/H7ZdYdCEbD7joj0zv3lXX6CcRzva6N6SkvRDkCuG1h0gWswMovd3TtlCU++pdcq
         ag2rGqt9QBYYOKcERhyq+1rmWLdoP0hDX0pZb/2p+vq4H95CSL56blWnolG5L4UkaO
         syaUiusQe3IClgZc1LWRCWBxlq/zI7esC10TgDW7niWxS5x71vqeYGDjtNnbmV1k1Y
         HqKUS1A/5OskA==
Date:   Mon, 26 Sep 2022 13:01:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <sgoutham@marvell.com>,
        <naveenm@marvell.com>
Subject: Re: [net-next PATCH 8/8] octeontx2-pf: mcs: Introduce MACSEC
 hardware offloading
Message-ID: <20220926130100.4f315759@kernel.org>
In-Reply-To: <1664199421-28858-9-git-send-email-sbhatta@marvell.com>
References: <1664199421-28858-1-git-send-email-sbhatta@marvell.com>
        <1664199421-28858-9-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 19:07:01 +0530 Subbaraya Sundeep wrote:
> This patch introduces the macsec offload feature to cn10k
> PF netdev driver. The macsec offload ops like adding, deleting
> and updating SecYs, SCs, SAs and stats are supported. XPN support
> will be added in later patches. Some stats use same counter in hardware
> which means based on the SecY mode the same counter represents different
> stat. Hence when SecY mode/policy is changed then snapshot of current
> stats are captured. Also there is no provision to specify the unique
> flow-id/SCI per packet to hardware hence different mac address needs to
> be set for macsec interfaces.

Does not build:

drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:1258:36: error: no member named 'macsec_cfg' in 'struct otx2_nic'
        struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
                                    ~~~~  ^

Please make sure you wait at least 24h before reposting.
