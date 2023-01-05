Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A511465E4C4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjAEEn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjAEEnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:43:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7684730D;
        Wed,  4 Jan 2023 20:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5966136C;
        Thu,  5 Jan 2023 04:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CBBC433D2;
        Thu,  5 Jan 2023 04:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893791;
        bh=bblkc9qPIFWPnA1Y12sBEophTNV/RjoMDzvHAy300wg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pVXUTSpClsLPKy592WqPKx4OAP6cv15bF+fCeSoWEUgN2qGBpMLTOPf91ecCJligo
         mUpIPDXUaQfXcg95kfsBH6dMm9Nv1sbhTt/7KfbF2PWCiWz2pvhASdNs17zeE1LEHk
         6e23zPQcHSvQtmU1rShh/R1m5/oWBrY6QmRTwpKbs4Vu0h454lT1lQQUZ36/gpFYRc
         elAQJuQwiGdAIgxj5D4z9qBNvY5Mh+MYlLXR+mK4604QuhynxtPvha+s1XsMuKQG8U
         JbOzRrZ6/j+781qu28ifF+Lnp5ZzlIMPD81lhs1EWJtf9qUI05Br0IgNmutRZ0oTd8
         6ldN9qteFcw7Q==
Date:   Wed, 4 Jan 2023 20:43:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net v2 3/3] ice: Fix broken link in ice NAPI doc
Message-ID: <20230104204310.3d56e5d7@kernel.org>
In-Reply-To: <c94fd896-75f5-6a7b-1253-b1377405fef6@gmail.com>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
        <20230103230738.1102585-4-anthony.l.nguyen@intel.com>
        <c94fd896-75f5-6a7b-1253-b1377405fef6@gmail.com>
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

On Wed, 4 Jan 2023 09:02:50 +0700 Bagas Sanjaya wrote:
> On 1/4/23 06:07, Tony Nguyen wrote:
> >  This driver supports NAPI (Rx polling mode).
> >  For more information on NAPI, see
> > -https://www.linuxfoundation.org/collaborate/workgroups/networking/napi
> > +https://wiki.linuxfoundation.org/networking/napi
> >    
> 
> Replace with LF wiki?

TBH I, for one, do not know what you mean.
