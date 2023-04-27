Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D356EFFD0
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbjD0D3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbjD0D3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF8E3A9F
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3AF2618FE
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4B0C433D2;
        Thu, 27 Apr 2023 03:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682566149;
        bh=z+S56DhLOtmm3A8skW8fYaGY6+iLH8uKt0bdGWwqhbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VHbYbVC3hbdfC9VO1p+XL7NlnF60p4N50GntVuhvGsfLHmppdHBNy+QRNn593Bg8W
         u1ZxqwkQSrLV8a2IVlSJbcUA+Kp9/CdfxcKT8U2n2jWfeDvsuE3aujBAd7HiLa28v+
         /E1HRZH46mrbrRL+56tZ0PFkc7JF/rwSUpzctfaYUkz2I9FBPGvIWOlt2625YxMWOC
         Wku85elfj51xQSow2GxacZwltCmXhXBbtrZFRfEy6dNj5Lx0Q1j7GWzIiTlMauFmS7
         7+C+OJRp31+917/bkPh7kK0Zs9bHc8C4XYXrStXcNfWs8cHCeBAvpoVyXHnhk8DdtE
         oyUdEmbNtvjRQ==
Date:   Wed, 26 Apr 2023 20:29:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        <jesse.brandeburg@intel.com>
Cc:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <anthony.l.nguyen@intel.com>, <willemb@google.com>,
        <decot@google.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <davem@davemloft.net>, <alan.brady@intel.com>,
        <madhu.chittim@intel.com>, <phani.r.burra@intel.com>,
        <shailendra.bhatnagar@intel.com>, <pavan.kumar.linga@intel.com>,
        <shannon.nelson@amd.com>, <simon.horman@corigine.com>,
        <leon@kernel.org>
Subject: Re: [net-next v3 00/15] Introduce Intel IDPF driver
Message-ID: <20230426202907.2e07f031@kernel.org>
In-Reply-To: <97f635bf-a793-7d10-9a5e-2847816dda1d@intel.com>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
        <20230426194623.5b922067@kernel.org>
        <97f635bf-a793-7d10-9a5e-2847816dda1d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 19:55:06 -0700 Tantilov, Emil S wrote:
> The v3 series are primarily for review on IWL (to intel-wired-lan, 
> netdev cc-ed) as follow up for the feedback we received on v2.

Well, you put net-next in the subject.

> Was I not supposed to cc netdev in the quiet period?

That's what you got from my previous email? Did you read it?
The answer was there :|

The community volunteers can't be expected to help teach every team of
every vendor the process. That doesn't scale and leads to maintainer
frustration. You have a team at Intel which is strongly engaged
upstream (Jesse, Jake K, Maciej F, Alex L, Tony etc.) - I'd much rather
interface with them.

Jesse, does it sound workable to you? What do you have in mind in terms
of the process long term if/once this driver gets merged?
