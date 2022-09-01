Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3805A9C37
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 17:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiIAPvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 11:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiIAPuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 11:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395297FF9B
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 08:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD9DCB82830
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 15:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D7AC433D6;
        Thu,  1 Sep 2022 15:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662047449;
        bh=7PfDV5ggk6DK/srli0S5QjvvMCrUM8EQYY+z+EtOYTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u5MvGiJHWsKVCJRwd/578mEeDzbLgVsPnDALX37y5I2dHJx7rVnNDmGN3BmJaGdDD
         2jquKZySbF4Ee7nOq7RFczhwdPoj1wywFz+3oEVR0/LbVpSMBuQVc69hcGP+PpZ5Hi
         yngpjXWa0pHJeMJ8ENfjlCrKSf2ceBnDd/6sI/k32Rz1VCQfp/FRCiKAQU6nbo/sQg
         jUIWWdsW3kimEePcnV+u5uvKKDwmtaFrcQVSsTDMFzuiwYf1V6IEN0yDuprzYYizK8
         dVxwBGs+6K9e63EMJK5JbJcxN44tAYz7xUaYF22VU9uLeSOoBigcDeb+27FOWg1q1r
         JRsafv4M1Q36Q==
Date:   Thu, 1 Sep 2022 08:50:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cai.huoqing@linux.dev" <cai.huoqing@linux.dev>,
        "brgl@bgdev.pl" <brgl@bgdev.pl>, Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
Message-ID: <20220901085047.37a71af4@kernel.org>
In-Reply-To: <DM6PR12MB553413FEE0C3C357010CDBB3C77B9@DM6PR12MB5534.namprd12.prod.outlook.com>
References: <20220826155916.12491-1-davthompson@nvidia.com>
        <20220826184922.030fccb3@kernel.org>
        <DM6PR12MB553413FEE0C3C357010CDBB3C77B9@DM6PR12MB5534.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Sep 2022 15:32:13 +0000 David Thompson wrote:
> > Hm, why did you repost this?  
> 
> I reposted because the first post failed the "netdev/cc_maintainers" test:
> 
> 	netdev/cc_maintainers	fail	1 blamed authors not CCed: limings@nvidia.com; 1 maintainers not CCed: limings@nvidia.com
> 
> In the second post I included "limings@nvidia.com" .

I see.. FWIW the checks are not 100% accurate, I would have ignored that
one. We're a little more lax about CCing people from the same company.
Next time please put the reason in the changelog under the ---
separator, to avoid any confusion and delays. Thanks!
