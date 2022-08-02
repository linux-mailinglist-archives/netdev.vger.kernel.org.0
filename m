Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF65587F83
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiHBPxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbiHBPwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:52:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8019A3CBDE;
        Tue,  2 Aug 2022 08:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72FF5B81F40;
        Tue,  2 Aug 2022 15:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C91C433D6;
        Tue,  2 Aug 2022 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659455527;
        bh=lQ/X9bP7iO/1coT/3Xnw/EgnIZigs/Kfo/D1jrW3jFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XhgpnDIjuTWWEEKdx994z7kiUhYI1HRCtjZnWClqzEJIiJ9lsgDQMhhGujm9Rc3If
         87hmKpOwYjdxn71YEVgtQJBmLjA4/n/6wkgfYmIsfC/jR2n9e63H2uDRIFHu+V3wJ+
         LBlzJ5GUHHSfrs35HCxor6H0+8zl9I5K3ehUa5DAxr/40rdwjLfT3Lt6qnx7XDrreT
         UUX53CdVPn+SlMbDWrSDwOH3ODCqHsKEmYqBh13ICwCHpBoLpoaof4c6YYPJflHmI3
         eXoxsNUq0VSGayLBUfJoWaTUIMuk0rhf5xXZC+3MpbMuzSN1Y0hqyTggmpzUam8E2X
         aVbt7jKImWizw==
Date:   Tue, 2 Aug 2022 08:52:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/3] dpll: add netlink events
Message-ID: <20220802085205.5c371f02@kernel.org>
In-Reply-To: <DM6PR11MB4657FADDDA75A5F35CF8FE3F9B9D9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
        <20220626192444.29321-3-vfedorenko@novek.ru>
        <DM6PR11MB46573FA8D51D40DAD2AC060B9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
        <715d8f47-d246-6b4a-b22d-82672e8f11d8@novek.ru>
        <DM6PR11MB465732355816F30254FCFA9E9B8B9@DM6PR11MB4657.namprd11.prod.outlook.com>
        <DM6PR11MB4657FADDDA75A5F35CF8FE3F9B9D9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 14:02:31 +0000 Kubalewski, Arkadiusz wrote:
> I just wanted to make sure I didn't miss anything through the spam filters or
> something? We are still waiting for that github repo, or you were on
> vacation/busy, right?

Great timing, I was just asking Vadim for the code as well.
I should be able to share the auto-generated user space library 
for the netlink interface soon after Vadim shares the code.
Still very much WIP but, well, likely better than parsing by hand.
