Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F25698C73
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBPF5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBPF5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:57:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830F843934;
        Wed, 15 Feb 2023 21:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D02BCB825DC;
        Thu, 16 Feb 2023 05:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19033C433D2;
        Thu, 16 Feb 2023 05:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527043;
        bh=lM/BJQ/UEKRymjvI60SIXWQIiu/eK3GL9FiNEoGW6vM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJhQn5P1pnIzCMiiiSWvVHS30N0Caggd75tRj4xVb3cFOY0o6zV4sbTlvcLVXnzp0
         jj2EepxGQgsd/B0HOzQtrOxQ8frjMOBhkpqGvsmY1ZRTav4O1vuzgCpnn+sKRhNAlx
         DrGGVkrTGwoHI93c5nKid3F+39EpXHIQilQzE+sJ+CzppnmepN4hcFhCWcGZxYTTv0
         bgrnlkjk6GETAIF720Ibt3n3dLPufvwHu1ClN7XwIqIg0YbcKVHWwpmh6+AUXQIjOE
         gPC4F2JySPMfMeC23U9hSVYXr7UPAeMpEsiJXMPAYq5EEzgGq2OtZJRKDNJ73NA/AW
         8nPefSEuOyYxg==
Date:   Wed, 15 Feb 2023 21:57:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alejandro.lucero-palau@amd.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <linux-doc@vger.kernel.org>, <corbet@lwn.net>, <jiri@nvidia.com>
Subject: Re: [PATCH v8 net-next 0/8] sfc: devlink support for ef100
Message-ID: <20230215215722.120540fe@kernel.org>
In-Reply-To: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
References: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
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

On Wed, 15 Feb 2023 09:08:20 +0000 alejandro.lucero-palau@amd.com wrote:
> This patchset adds devlink port support for ef100 allowing setting VFs
> mac addresses through the VF representor devlink ports.
> 
> Basic devlink infrastructure is first introduced, then support for info
> command. Next changes for enumerating MAE ports which will be used for
> devlink port creation when netdevs are registered.
> 
> Adding support for devlink port_function_hw_addr_get requires changes in
> the ef100 driver for getting the mac address based on a client handle.
> This allows to obtain VFs mac addresses during netdev initialization as
> well what is included in patch 6.
> 
> Such client handle is used in patches 7 and 8 for getting and setting
> devlink port addresses.

LGTM
