Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB25EE362
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiI1Roc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiI1Rob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:44:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F7AE5F9B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FB49B821B1
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 17:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8378BC433C1;
        Wed, 28 Sep 2022 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664387067;
        bh=hgEsF07KMMKCovzQGbqcPM4Tt+xAF7M/wYj1gd48RD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RM/osJOup6J55L/lRAcYqRG/OqReQoJvkQ2K6b/KnptyqlznYTLjQ/B8SiFpQ39+1
         ee/0h99EsUWaN6UKgb+foTrGMb7N3RSNvabNkyC51ZNmRTm5cpBOAgW9yQF2GigKAt
         yNtKJokUrZfAsRauSfbyPd3lQ+YgXhH+MOyp2uPeD2/mn59dHREIx32sg3Pqr0FwYP
         eUny8lrM3HcJSIPRj/ZtA71c+Lj4/wcgTRX8eWbNl5GThkfXUl4WxNUgy+VHWaHd+K
         Y4ThZH7H72hIT6k9I7R5TClG2H58pACfWFZEB6oCwjThJhgz2od2ljBAvrCD0UeBDK
         Gin8ptkhMbcBQ==
Date:   Wed, 28 Sep 2022 10:44:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ecree@xilinx.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
Message-ID: <20220928104426.1edd2fa2@kernel.org>
In-Reply-To: <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
        <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
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

On Mon, 26 Sep 2022 19:57:33 +0100 ecree@xilinx.com wrote:
> TC offload support will involve complex limitations on what matches and
>  actions a rule can do, in some cases potentially depending on rules
>  already offloaded.  So add an ethtool private flag "log-tc-errors" which
>  controls reporting the reasons for un-offloadable TC rules at NETIF_INFO.

Because extack does not work somehow?

Somehow you limitations are harder to debug that everyone else's so you
need a private flag? :/
