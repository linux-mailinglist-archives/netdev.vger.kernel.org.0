Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E900957D1B6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiGUQlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiGUQlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:41:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF1A2655E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25990B825C1
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 16:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D34C3411E;
        Thu, 21 Jul 2022 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658421668;
        bh=9RHH7Ak+r0GmXS3YxFq1ADReS6qNLHKSk6Vfad8q7mc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jCMja3jNQ2FDkmdfz8gb+OQGKwDuzEcPPcehvQwdi9QgkQTh3DFC4o4+Z2m7nG/y9
         G4N+nhTnJv3+ZG1IFSqK1BN9XQwGB9MxgELrJY3zrm2lOL6b/rRjtkteKlcbCABPzL
         Wa3DtrUOjnWYENVlv6q8Z9Rt/awJBNwAVQWbKh/eFzSYLyONhppmy8Vv2+tAO26yF+
         VOyBDUqtWNTVRXQRgh4xxyT25uH1knrMlp06RA6F25BRIRliIEw/5zbx+2tAcF/qZJ
         2nL7jSAyMIYCgtK21f0gwn87KeQpXfriNUaRjS2hRhsxHXYBdFjstaARNJ6GsOgUjB
         Jdzi3XgXuO5Og==
Date:   Thu, 21 Jul 2022 09:41:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alex Elder <elder@ieee.org>, netdev@vger.kernel.org,
        Alex Elder <elder@kernel.org>
Subject: Re: [PATCH net-next] net: ipa: fix build
Message-ID: <20220721094107.5766c21b@kernel.org>
In-Reply-To: <16b633abfdcdcb624054187a5fc342bfeb9831f9.camel@redhat.com>
References: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
        <5a1c541c-3b61-a838-1502-5224d4b8d0a4@ieee.org>
        <16b633abfdcdcb624054187a5fc342bfeb9831f9.camel@redhat.com>
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

On Thu, 21 Jul 2022 16:50:20 +0200 Paolo Abeni wrote:
> > Interesting...  This didn't happen for me.
> >
> > 
> > Can you tell me more about your particular build environment
> > so I can try to reproduce it?  I haven't tested your fix yet
> > in my environment.  
> 
> Possibly ENOCOFFEE here, but on net-next@bf2200e8491b,
> 
> make clean; make allmodconfig; make
> 
> fails reproducibly here, with gcc 11.3.1, make 4.3.
> 
> Do you have by chance uncommited local changes?

Oh, poops. You're right. I think all - the build bots, Alex and I
build with O=builddir, in which case the build works. I'll let the 
build bot catch up to your fix and apply it. Sorry about that!
