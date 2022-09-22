Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073705E574B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiIVAZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiIVAZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:25:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE539DFAC
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F15A1B8332C
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398D1C43470;
        Thu, 22 Sep 2022 00:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663806336;
        bh=/POMlrmloz4gquNvr0wy7JHfya09zU2qdvOC3QVFcx8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QBqN6o51WDTgiY1Wt1bZ/KPRneW4zvq1ibrngQIyBCrn+P36187HfSg5J7K1e9sLP
         Vz0mr4jzZtXxZJM6NLbfkhrNRn5Xg/KWnuYx1QeU0rohl8s23U3OiewoSm0zOqQlfE
         wzHS0sox0tFSo+FzA/94A4qnuVZX45o2EvGn2TVc8FYIOVJW0GRSsEOsaNZEClRVgO
         GNGSEaRDRTV1k+NUvPqoqTYS4nSHHfuos0AZN2380ceS3CNIsx4sNT5AWXxRX4umEU
         i+5+M8ZO+yWBJpdsYgsNoLu1kfFym5RdJPAgdbTBdZJOBIJgwk39SpNYz/k/f0n1pG
         7kduJs6e63EJQ==
Date:   Wed, 21 Sep 2022 17:25:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
        jasowang@redhat.com, loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com, gavi@nvidia.com,
        parav@nvidia.com
Subject: Re: [virtio-dev] [PATCH v5 0/2] Improve virtio performance for 9k
 mtu
Message-ID: <20220921172535.6b289108@kernel.org>
In-Reply-To: <0a97bab1-2d5e-073b-e439-4e6e745dad52@nvidia.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
        <76fca691-aff5-ad9e-6228-0377e2890a05@nvidia.com>
        <20220919083552.60449589@kernel.org>
        <0a97bab1-2d5e-073b-e439-4e6e745dad52@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Sep 2022 21:45:55 +0800 Gavin Li wrote:
> Sorry for the non-text format issue of last mail.
> 
> v6 is posted at link 
> https://lore.kernel.org/netdev/20220914144911.56422-1-gavinl@nvidia.com/
> Would you please review it?

I presume you put me on To: "just because", but FWIW the patches LGTM.
Maybe repost them, perhaps they fell off Michael's and Jason's radar
due to LPC?
