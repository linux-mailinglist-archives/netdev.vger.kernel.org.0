Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755CD698E6F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBPIQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBPIQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:16:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1E30C2;
        Thu, 16 Feb 2023 00:16:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50C0EB824F1;
        Thu, 16 Feb 2023 08:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76152C433D2;
        Thu, 16 Feb 2023 08:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676535373;
        bh=VyzmEsPoa/Y565Ji4nqFDLHYCje9rYD0PrA6meuz6yQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ad1O+QQV/rW9JaixcdpRKFUQz9al6FjHd3z3HPbEEI6hYl56YB4XkPPWZHoi/aY9b
         nubWjRWKnrIQZXSSstWRBjLWJhqneHNtqVm51BArm1SYV/B17VpWofCQVVI47Nkmi9
         CIVWLzw6k94dwsw1oaeqdby73f2okGp5FdthFbJQ=
Date:   Thu, 16 Feb 2023 09:16:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Taichi Nishimura <awkrail01@gmail.com>
Cc:     andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, iii@linux.ibm.com, ytcoode@gmail.com,
        deso@posteo.net, memxor@gmail.com, joannelkoong@gmail.com,
        rdunlap@infradead.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH bpf-next] Fix typos in selftest/bpf files
Message-ID: <Y+3mSp2j2Xqe1sT0@kroah.com>
References: <20230216080423.513746-1-awkrail01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216080423.513746-1-awkrail01@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 05:04:23PM +0900, Taichi Nishimura wrote:
> This patch is a re-submitting patch.
> I cloned bpf-next repo, run spell checker, and fixed typos.
> Included v1 and v2 patches to this one.
> 
> Could you review it again? 
> Let me know if I have any mistakes.

This text is not needed in the changelog for a patch, please read the
section entitled "The canonical patch format" in the kernel file,
Documentation/process/submitting-patches.rst for what is needed in order
to properly describe the change.

thanks,

greg k-h
