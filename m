Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA95A69A826
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBQJbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjBQJbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:31:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67E160A63;
        Fri, 17 Feb 2023 01:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6269061746;
        Fri, 17 Feb 2023 09:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735A3C433D2;
        Fri, 17 Feb 2023 09:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676626272;
        bh=7NWXCNwsLxcuRiVrzjqdGDzGIP4d5/chcgdIlQ5lZfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R7qlaFpmL80N8iFkeSubWDxctpTjznTDEYrqL1A+GN71SkTPq5WqO4SgL7NYslso5
         EkG18snEPUqoTbEVVVhQ6oU5kg2lvGAueXLWfDOrWvNlUoxdTrTHESEbl3DNxYZ/Dp
         uhmCwn/Z5wvwxH2yAvEgL/zP5IDRLXAZNX1CXP9U=
Date:   Fri, 17 Feb 2023 10:31:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jaewan Kim <jaewan@google.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
Message-ID: <Y+9JXU+5QEU1TMdi@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
 <20230207085400.2232544-2-jaewan@google.com>
 <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
 <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
 <Y+8wHsznYorBS95n@kroah.com>
 <e98a38890bb680c21a6d51c8a03589d1481b4e29.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98a38890bb680c21a6d51c8a03589d1481b4e29.camel@sipsolutions.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 10:13:08AM +0100, Johannes Berg wrote:
> On Fri, 2023-02-17 at 08:43 +0100, Greg KH wrote:
> > On Fri, Feb 17, 2023 at 02:11:38PM +0900, Jaewan Kim wrote:
> > > BTW,  can I expect you to review my changes for further patchsets?
> > > I sometimes get conflicting opinions (e.g. line limits)
> > 
> > Sorry, I was the one that said "you can use 100 columns", if that's not
> > ok in the networking subsystem yet, that was my fault as it's been that
> > way in other parts of the kernel tree for a while.
> > 
> 
> Hah. Maybe that's my mistake then, I was still at "use 80 columns where
> it's simple, and more if it would look worse" ...

It was changed back in 2020:
 bdc48fa11e46 ("checkpatch/coding-style: deprecate 80-column warning")

seems to take a while to propagate out to all the subsystems :)

