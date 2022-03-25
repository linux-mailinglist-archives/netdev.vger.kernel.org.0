Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0BD4E6BB3
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349348AbiCYBFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241524AbiCYBFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:05:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F5FB6E40
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 18:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7F9761800
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916E4C340EC;
        Fri, 25 Mar 2022 01:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648170213;
        bh=Ty7qsHHKck+/xIVjAUDI4PjpvF25RMOp3Cmj5fDwh5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gZmFenW9hcTLMZqkakuHOVCasirF31tFbCSkQznwunbF556tvq9eLbEDNFAwEaVJ+
         m3i8tO1O5EGqJJKYVoVyhq7XSV8SmZKR1en5GQzLI2++xDkPxX2fbBPT+PsLddrtQv
         fyOvr+aptyuFDUAixcGLcvdZyOt5g0BnflLvaWq94wgIA8gAmnifiVWI76u0KYyf7S
         q+dVVxT93TmfqT2FwkbXZ2z5Ehe5toVJ2uPIkWRBym3Y2kblIcfLLR/XREtQTAPqat
         ko7lvKjkeUpMBav8CFBJzPkM+GvY5FbO368nZtaHL67z2DqD00eGVPQKkBW1vYaoYL
         eWH0njD5+TUag==
Date:   Thu, 24 Mar 2022 18:03:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
Subject: Re: [RFCv5 PATCH net-next 01/20] net: rename net_device->features
 to net_device->active_features
Message-ID: <20220324180331.77a818c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-2-shenjian15@huawei.com>
        <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 17:58:32 -0700 Jakub Kicinski wrote:
> On Thu, 24 Mar 2022 23:49:13 +0800 Jian Shen wrote:
> > The net_device->features indicates the active features of the
> > net device, rename it to active_features, make it esaier to
> > define feature helpers.  
> 
> This breaks the build.

I see you mention that the work is not complete in the cover letter.
Either way this patch seems unnecessary, you can call the helpers
for "active" features like you do, but don't start by renaming the
existing field. The patch will be enormous.
