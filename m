Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3F674CA8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjATFi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjATFip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:38:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3E65FC1;
        Thu, 19 Jan 2023 21:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6481661E23;
        Fri, 20 Jan 2023 05:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61686C433D2;
        Fri, 20 Jan 2023 05:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674192958;
        bh=8fStNEoSsGqotQjU+mQkrtNKHP0mDcCwZkH9P+/tZzk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nia8b2pq9XxzIMd3lyGpEAN0Pu2CG6R/GrdcTOZCV4rgawIEe5u3WFJu2zMwOjyZG
         8eEBY+03XA+j95KK5CCOiiWA9sXNPWwz2vFhJzWV3mNQotav9sq+K0i/IZJ/Cr6itK
         q1pRC7CcHDb23n3UfaPPtScqf9+o5Y9UBXKndLHQRiR7KKYi4BfKO6EIjltz9VBnHe
         ORM8i89pvcJDHieagLHpp1wDMAZCl8BnxhP/qDOrPJfe+bxGoUK/FpTrjLrFUv5JmJ
         qpfaAS6LoYjQeyVqWaQEbykyPEh8BPopyy8Jop/IBYEorFcFoXeAlfgN6kfHfE8lsX
         n5v0uF+zOoXUQ==
Date:   Thu, 19 Jan 2023 21:35:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/9] e1000e: Remove redundant
 pci_enable_pcie_error_reporting()
Message-ID: <20230119213557.57598e8f@kernel.org>
In-Reply-To: <2c722338-c113-14a1-040b-70326e2e2451@intel.com>
References: <20230119184045.GA482553@bhelgaas>
        <2c722338-c113-14a1-040b-70326e2e2451@intel.com>
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

On Thu, 19 Jan 2023 13:31:39 -0800 Tony Nguyen wrote:
> > Thanks a million for taking a look at these, Tony!
> > 
> > These driver patches are all independent and have no dependency on the
> > 1/9 PCI/AER patch.  What's your opinion on merging these?  Should they
> > go via netdev?  Should they be squashed into a single patch that does
> > all the Intel drivers at once?
> > 
> > I'm happy to squash them and/or merge them via the PCI tree, whatever
> > is easiest.  
> 
> Since there's no dependency, IMO, it'd make sense to go through 
> Intel-wired-lan/netdev. Keeping them per driver is fine.

Ah, damn, I spammed Bjorn with the same question because email was
pooped most of the day :/ Reportedly not vger, email in general but 
fool me once...

Tony, if you could take these via your tree that'd be best.
