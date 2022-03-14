Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554534D8512
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiCNMez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245342AbiCNMcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:32:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD19A5882A;
        Mon, 14 Mar 2022 05:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C2A161025;
        Mon, 14 Mar 2022 12:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3E8C340E9;
        Mon, 14 Mar 2022 12:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260849;
        bh=pclfUA10g0N+EEIicov6TyYMnO+hEsvYfFRTwAkQkG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qIwFylDtPLwMRARaNrOIc3TTcwenaR3vXS5+p1wV8Z7nBd6B+TZcNT6KGu8br6uhu
         bKBY1rVo0I1cpjmdBRHL3pxzjF3DGxyj5O+gGfKqwQjVbO6LGJq5/zSZ8FQs2jQw03
         5PA4GAvyF6Pb502IIK1kHLZPAbvbJG/Ou9e6fYNs=
Date:   Mon, 14 Mar 2022 13:27:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kai Lueke <kailueke@linux.microsoft.com>
Cc:     stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH] Revert "xfrm: state and policy should fail if
 XFRMA_IF_ID 0"
Message-ID: <Yi80rV9a88NmXPPb@kroah.com>
References: <20220303145510.324-1-kailueke@linux.microsoft.com>
 <20220307082245.GA1791239@gauss3.secunet.de>
 <076e8c72-b842-64a8-7a4b-9a3b30715b5d@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <076e8c72-b842-64a8-7a4b-9a3b30715b5d@linux.microsoft.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 01:19:19PM +0100, Kai Lueke wrote:
> I forgot to CC stable@ when submitting, doing it now:
> Can this be picked for the next round of stable kernels (down to 5.10)?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a3d9001b4e287fc043e5539d03d71a32ab114bcb
> 
> Thanks,
> Kai
> 
> On 07.03.2022 09:22, Steffen Klassert wrote:
> > On Thu, Mar 03, 2022 at 03:55:10PM +0100, kailueke@linux.microsoft.com wrote:
> >> From: Kai Lueke <kailueke@linux.microsoft.com>
> >>
> >> This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because ID
> >> 0 was meant to be used for configuring the policy/state without
> >> matching for a specific interface (e.g., Cilium is affected, see
> >> https://github.com/cilium/cilium/pull/18789 and
> >> https://github.com/cilium/cilium/pull/19019).
> >>
> >> Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>
> > Applied, thanks Kai!

I will pick it up for the next round of releases after these go out.

thanks,

greg k-h
