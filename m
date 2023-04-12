Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26B56DF8DE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjDLOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjDLOph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA44510B
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63328635E1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEF4C433EF;
        Wed, 12 Apr 2023 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681310735;
        bh=XzKq+gZuh0shB18Y+Sxm7im2B8sAERrQjvvWl5EUzUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CgNqjWOmgTZJia0scz4Uc0EVZa60tG8z9cURXSJ8iFCCFlOmC/pmFf8j60dTTsLUL
         VxQon4g7snUWg+AUnksNm6vw4wpOiMbw52Hu33Hnp14gJfgcvQ4/KtW5GSNr/MzMlj
         WfTRfgysokmezSK61+B4rc+2a5ZJtFjgeIhSILn2tUv1uhOKUxw+QGxj+rN1/eCI8T
         V0+Gd7FDZMF/WKyGCB48wkSMazeAu1HL5dbPlpvbZ81egdRct1ACiMnb0OIJOz8jId
         XEy4ypbb2fGHD/x43I2bE7AdMBx474Fa3SnMSF/I2W/fzeagsnHRdffXd2XvvDdcFX
         S8xjQ3BrD39bA==
Date:   Wed, 12 Apr 2023 07:45:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <20230412074534.15e2c82b@kernel.org>
In-Reply-To: <ZDauEGjbcT6uPfCp@calimero.vinschen.de>
References: <20230411130028.136250-1-vinschen@redhat.com>
        <ZDauEGjbcT6uPfCp@calimero.vinschen.de>
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

On Wed, 12 Apr 2023 15:11:44 +0200 Corinna Vinschen wrote:
> On Apr 11 15:00, Corinna Vinschen wrote:
> > stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> > like TX offloading don't correspond with the general features and it's
> > not possible to manipulate features via ethtool -K to affect VLANs.  
> 
> On second thought, I wonder if this shouldn't go into net, rather then
> net-next?  Does that make sense? And, do I have to re-submit, if so?

If it's not a regression it should go into net-next.
"never worked, doesn't crash" category.
