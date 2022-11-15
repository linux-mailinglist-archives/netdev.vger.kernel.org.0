Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2A62939A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiKOIvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiKOIuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:50:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266081F600
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9031E61576
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39939C433C1;
        Tue, 15 Nov 2022 08:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668502252;
        bh=618IkfKbGEsdcN5CYG9QETG2lCqj8xuKrQjqoqV+y7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tQFALKqIuBLg9IpVZjNsZBnWnJwrR5DtN1ijsuePYMshZy3jjlh/ugAsfUaIeFv1e
         S8FhnL5Hvhx31syVaSNLxdyzoLcwEbhK8YrEo/IQcPRyQE2nhQALDQ0neQmfJbA8Vm
         Vq1MfCUK/2Tc83QlXM3jYZQABPkpM6QzkTXWI9OITMw8oAdzinzqckjfSMalRjVJbw
         zi+S6Owo2IiJ6vxwzR2MsWh67WPTin50jBtjNMwSyVb2caOb5XeLfNzh1TA7v5nFg6
         OhF329HFnkj4JCFeRVNCdmAvNiK99jnTWIrfmgLPZJqfV9pd8knwDtJbGdj3uL/Ds/
         5peqOl0MXO1gQ==
Date:   Tue, 15 Nov 2022 10:50:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Walter Heymans <walter.heymans@corigine.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next v2] Documentation: nfp: update documentation
Message-ID: <Y3NS5x8VcIUWd2qZ@unreal>
References: <20221114150129.25843-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114150129.25843-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:01:29PM +0100, Simon Horman wrote:
> From: Walter Heymans <walter.heymans@corigine.com>
> 
> The NFP documentation is updated to include information about Corigine,
> and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
> with new information about where to find firmware.
> 
> Two new sections are added to expand the coverage of the documentation.
> The new sections include:
> - Devlink Info
> - Configure Device
> 
> v2
> * Add missing include of isonum.txt for unicode macro |copy|

Please put changelog after --- trailers. It doesn't belong to commit
message.

Thanks
