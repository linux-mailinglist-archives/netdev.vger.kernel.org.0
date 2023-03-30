Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E26D0CBA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjC3RZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjC3RZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A34EC4D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 363CF6212D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E187C433EF;
        Thu, 30 Mar 2023 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680197106;
        bh=YM0v4eaeKHQ1bnz6FwcmsrLI1BUtds5k0Ahl7g2zAnQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WsB8ItIbbwOflodLshtDZCnJen6ZRl9S2NZPgmRHez/jnfHH8Z5qwu9tgPLr2b0ie
         bzSLDHC8c8cSbPVTapJRyTXLewIEsLGJI+UmkyApwaKLOMkbNiZPKQeKkyTM+gStAF
         Z3NHsjF+iwpbKDcFsHer3HpLl7JxVGSTGt392YhjCK6KzuyokPKzkVgMzlWQ75BrU7
         +4D50Dx7viNTpADeevNyrGxbqOhtEZs3Hg6TLA2F5p/b7WxYjtFTYh6kuMMyuWEWQS
         a0PWgk8MPUZKqG3cZw9Z7q47wiDOrhq+nney5oIAXleUKUI/FTBkukTRnkLMiEdFQ4
         OJFzg95Sib4bw==
Date:   Thu, 30 Mar 2023 10:25:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Message-ID: <20230330102505.6d3b88da@kernel.org>
In-Reply-To: <ZCV6fZfuX5O8sRtA@nvidia.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
        <ZCV6fZfuX5O8sRtA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 09:03:09 -0300 Jason Gunthorpe wrote:
> On Wed, Mar 29, 2023 at 07:03:49AM -0700, Pavan Kumar Linga wrote:
> > This patch series introduces the Infrastructure Data Path Function (IDPF)
> > driver. It is used for both physical and virtual functions. Except for
> > some of the device operations the rest of the functionality is the same
> > for both PF and VF. IDPF uses virtchnl version2 opcodes and structures
> > defined in the virtchnl2 header file which helps the driver to learn
> > the capabilities and register offsets from the device Control Plane (CP)
> > instead of assuming the default values.  
> 
> Isn't IDPF currently being "standardized" at OASIS?
> 
> Has a standard been ratified? Isn't it rather premature to merge a
> driver for a standard that doesn't exist?
> 
> Publicly posting pre-ratification work is often against the IP
> policies of standards orgs, are you even legally OK to post this?
> 
> Confused,

And you called me politically motivated in the discussion about RDMA :|
Vendor posts a driver, nothing special as far as netdev is concerned.
