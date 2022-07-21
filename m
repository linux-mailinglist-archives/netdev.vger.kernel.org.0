Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82BB57D770
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 01:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiGUXxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 19:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGUXxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 19:53:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C77A7755D;
        Thu, 21 Jul 2022 16:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F38B6B826C8;
        Thu, 21 Jul 2022 23:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190D3C341C0;
        Thu, 21 Jul 2022 23:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658447577;
        bh=yK/2aQwcTmWjKegD+naXKwpgN28c2N1Wm1Ikhzqp8T0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a6ar49SmtZ+Qeblvh9vslHjtBhAxbfKiw+TqxcyzG8PgVwW26AjXOrZ2XqyZUKGRR
         4rbeEk5nmqWSiikSqCu/CLmf37QWXMLVBJCjBrpi+zQeYvQVWF1hEiDOCx9cJho4mS
         X/Ax02+tUpj5o2R7/p57KDmIRr3rFT0gpOqtBDdSPTxkl2QuqGjX1YW19utgQUARuV
         ejfMzr4YNovBmx9figGcqP0zx+DEMk6OZYowmFA4wnkHP5JJba3wAL2O93o5J5R5TW
         umXAqAk6kAih+uwefwoKnqwcgmSZifwEHgtZS1OQAF1kqPQC5kSs/NmO2JxjNP0FSx
         QYHLqH2MNP0mg==
Date:   Thu, 21 Jul 2022 16:52:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [net-next v2 0/2] devlink: implement dry run support for flash
 update
Message-ID: <20220721165256.02f83fe8@kernel.org>
In-Reply-To: <20220721211451.2475600-1-jacob.e.keller@intel.com>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 14:14:45 -0700 Jacob Keller wrote:
> This is a re-send of the dry run support I submitted nearly a year ago at
> https://lore.kernel.org/netdev/CO1PR11MB50898047B9C0FAA520505AFDD6B59@CO1PR11MB5089.namprd11.prod.outlook.com/

You confused patchwork, please post user space in separate thread:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#how-do-i-post-corresponding-changes-to-user-space-components

Tomorrow:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches
