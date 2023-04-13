Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF81D6E1195
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDMQAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDMQAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325879EC9
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA41662DD6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 16:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF94EC433EF;
        Thu, 13 Apr 2023 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681401642;
        bh=SXUiD5e7wO49oIrVIWw60ufXh9hKDb+1opB70/chLzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FuxaUH5iCOfbSPrZwO0Dz1ROjJYB65M50I480nQ1Eemns9L90ICVI9znFEgpF4jwr
         PV4elIFRtGAU1JISuE4IDRynCR/I7v3qRRYppv9FblHiAiooBYhN3BDjfMwhl/oOpX
         g0j1R7jJ0ngwV0GQ14GqiCxLVkquaxvolZCAxz3MYgPrRo2tKyN5TsED+V/F/SlX0C
         0QQPQVlAxI55WWgo3PnFf4au4MlmEswTzEKQvlRdJqN+gNEGFk1VAsFyjgVoi8UpPT
         8VDT7yqfsdcvSfvjRzN5BuLH3x3LRwMwdVZw84zeVcc/qPmKFspVyKETcUR1kWbUnb
         qIzrPxGqLXznA==
Date:   Thu, 13 Apr 2023 09:00:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <20230413090040.44aa0d55@kernel.org>
In-Reply-To: <ZDgfBEnxLWczPLQO@calimero.vinschen.de>
References: <20230411130028.136250-1-vinschen@redhat.com>
        <20230412211513.2d6fc1f7@kernel.org>
        <ZDgfBEnxLWczPLQO@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 17:25:56 +0200 Corinna Vinschen wrote:
> I tested that I can, for instance, set and reset the tx-checksumming
> flag with ethtool -K.  As for TSO, I checked the source code, and the
> function stmmac_tso_xmit handles VLANs just fine.  While different
> NICs supported by stmmac have different offload features, there's no
> indication in the driver source that VLANs have less offloading features
> than a non-VLAN connection on the same HW.  Admittedly, I never saw
> documentation explicitely claiming this.
> 
> If that's not sufficient, testing will take another day or two, because
> I have to ask for a remote test setup first.

Testing would be great, I think it's worth waiting for that.
