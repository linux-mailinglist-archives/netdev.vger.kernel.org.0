Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6326D9D47
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbjDFQM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbjDFQMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:12:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CA54C39;
        Thu,  6 Apr 2023 09:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FEBF60F2D;
        Thu,  6 Apr 2023 16:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B63EC433EF;
        Thu,  6 Apr 2023 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680797574;
        bh=f0G5GtMX0Vww/OBGVTVkEPr8cy3Z6qlQlEOKio6hNl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cSVvcg3zFbmG5sAGzQ/ByO5aATJV9Jy3CgKyWjtejL0e0hiHVolxQUjvfrKNbI788
         58wCx9Mpgl0C1GI/r7cJznw69HenWorG+KLMRmlKkb/2s857HcIPYsucgf9k9cvskb
         w453mC+m6QV/47w4xpKDw/bunrg11fc7K2Xrg/wFFpSnqKOyalGDl97nR5Lx3lPA0X
         aAk2iN0TXv8s1aJ0AtfJ5NEEptKr+/m3yru6Fee4i6Chl5evcANy2mJnwoa7RP3Vbj
         O58JOUv8IVELYUF4WthY5mXEUSbkvlVY6R97TTRNQa1Y4/ttYqGKSXEtKA92v4PL4D
         ngbfD1b//l7Bg==
Date:   Thu, 6 Apr 2023 18:12:49 +0200
From:   Simon Horman <horms@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH net-next 2/3] ksz884x: remove unused #defines
Message-ID: <ZC7vgRFmqAjGQyss@kernel.org>
References: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
 <20230405-ksz884x-unused-code-v1-2-a3349811d5ef@kernel.org>
 <454a61709e442f717fbde4b0ebb8b4c3fdfb515e.camel@redhat.com>
 <20230406090017.0fc0ae34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406090017.0fc0ae34@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 09:00:17AM -0700, Jakub Kicinski wrote:
> On Thu, 06 Apr 2023 15:37:36 +0200 Paolo Abeni wrote:
> > On Wed, 2023-04-05 at 10:39 +0200, Simon Horman wrote:
> > > Remove unused #defines from ksz884x driver.
> > > 
> > > These #defines may have some value in documenting the hardware.
> > > But that information may be accessed via scm history.  
> > 
> > I personally have a slight preference for keeping these definitions in
> > the sources (for doc purposes), but it's not a big deal. 
> > 
> > Any 3rd opinion more then welcome!
> 
> I had the same reaction, FWIW.
> 
> Cleaning up unused "code" macros, pure software stuff makes perfect
> sense. But I feel a bit ambivalent about removing definitions of HW
> registers and bits.

I guess that it two down-votes for removing the #defines.

Would it be acceptable if I reworked the series to only remove
the dead code - which would leave only subset of patch 3/3 ?

