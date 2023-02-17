Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED15F69A635
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjBQHnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBQHnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:43:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B295A3BF;
        Thu, 16 Feb 2023 23:43:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89A2BB82AF0;
        Fri, 17 Feb 2023 07:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53FEC433D2;
        Fri, 17 Feb 2023 07:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676619809;
        bh=KrmesaHuI/4v3qEojFrOZL/yVjcLPffyUcOw0vBj9xI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cDRFD4jMDcBxTrsbHgKTRJWQdNioO50Ft/QVIWZG+nipuSmPryC3bpwjv9/H6ZVPB
         02Niav3WYqK2oeGjlzv8xSRV+/nZiSyLwdTokXY+PBN0G5AT7ETRd/6SuTN5yaYLxn
         3J7hDtGPPBHasbPBpcG39LoooFm4GHvTcoUptL+0=
Date:   Fri, 17 Feb 2023 08:43:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
Message-ID: <Y+8wHsznYorBS95n@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
 <20230207085400.2232544-2-jaewan@google.com>
 <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
 <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 02:11:38PM +0900, Jaewan Kim wrote:
> BTW,  can I expect you to review my changes for further patchsets?
> I sometimes get conflicting opinions (e.g. line limits)

Sorry, I was the one that said "you can use 100 columns", if that's not
ok in the networking subsystem yet, that was my fault as it's been that
way in other parts of the kernel tree for a while.

> so it would be a great help if you take a look at my changes.

Why not help out and start reviewing other people's changes?  To only
ask for others to do work for you isn't the easiest way to get that work
done :)

thanks,

greg k-h
