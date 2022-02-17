Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA74B97C9
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiBQEc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:32:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbiBQEc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:32:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029568AE50;
        Wed, 16 Feb 2022 20:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1526B820EF;
        Thu, 17 Feb 2022 04:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F7AC340E9;
        Thu, 17 Feb 2022 04:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645072332;
        bh=155GPnj8CBOJE5VM7kewsYdjo4L4L3wpK3dZVVaicWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fINo2r5MrvgaVp9SWnqzT42mOoWIpjhhsehAbHTMGxllB0quwKt0dEQyVfN/VkXI8
         ImzvFqiT5PezpBKMRu7H5li747aqxJHBQZTs5Qz5ghsN34UhjIAFkEBPE6AgwuIvhK
         mnyI7RFRu21EEo0Z2J+IcjNwjb5ttP0CBGo11/OXfl2HKaYaLac9MlVkhCwVULPodN
         YtpW5O5WOMo1WgZiNVTZtmIKWoNWP5aooDT6bRjAbWgwWjEAtBAS7vw40pgqXnNQ0n
         tdWtkGBMFvtq1C8B5hRmj8l2PDYuqWbtA3umhgoFqKcVDQJiewCm0zqI6VRKva/Rkf
         Pe2SrHUQkJuuA==
Date:   Wed, 16 Feb 2022 20:32:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: return ETIMEDOUT when
 smc_connect_clc() timeout
Message-ID: <20220216203210.7107b51d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <27b00eba-40a5-19e8-5af6-64d0d8f034fd@linux.ibm.com>
References: <1644913490-21594-1-git-send-email-alibuda@linux.alibaba.com>
        <c85310ed-fd9c-fa8c-88d2-862b5d99dbbe@linux.ibm.com>
        <20220216031307.GA2243@e02h04389.eu6sqa>
        <27b00eba-40a5-19e8-5af6-64d0d8f034fd@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 11:23:12 +0100 Karsten Graul wrote:
> On 16/02/2022 04:13, D. Wythe wrote:
> > Because other code that uses smc_clc_wait_msg() handles EAGAIN allready, 
> > and the only exception is smc_listen_work(), but it doesn't really matter for it. 
> > 
> > The most important thing is that this conversion needs to be determined according to 
> > the calling scene, convert in smc_clc_wait_msg() is not very suitable.  
> 
> Okay I understand, thank you.
> 
> Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>

Applied, thanks!
