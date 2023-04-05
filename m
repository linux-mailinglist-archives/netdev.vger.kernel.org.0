Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D7E6D8B15
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjDEXZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjDEXZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:25:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7D859CD;
        Wed,  5 Apr 2023 16:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29BBF6418C;
        Wed,  5 Apr 2023 23:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05104C433D2;
        Wed,  5 Apr 2023 23:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680737115;
        bh=0iZdW6mWX4hwDGKgVhQgPbiMcrKMWX7sqyjps7Gj0Cw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YoB0Sj7jPXfsgzdEIK/25IWwhAJni+fewvcgAfeW842j0ajGqiHZb+TbxdmKExVCw
         b6tXg+f3Dffmeeys7uR415qgza+aksTOtGHyxlYU2Um5REVJ/J7NpA24JuAGd1VIcv
         90l5hsw0QLZuUyNVHQs6j4yEW44caSIMrU0p/vXjNbwB+8iqQo+dH1TvxdhWYXXkNp
         4ucLXPOFxWC7o1o3GuKhC/Uv6mdKexeqLVkF05d/Fk+YSNMJaYWiM4N+FHsdmlLGfm
         sGLf/JatPWIZp3yngZ9qXPdagdSBqQeW2ypD8rXJssSwYioainXBMRlkw6E9ixJuDU
         7XZJF9b/xH2vw==
Date:   Wed, 5 Apr 2023 16:25:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Simon Horman <horms@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
Message-ID: <20230405162514.3af0776f@kernel.org>
In-Reply-To: <ZC2/Pi+M4rWw89x2@casper.infradead.org>
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
        <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
        <ZC23vf6tNKU1FgRP@kernel.org>
        <ZC240XCeYCaSCu0X@casper.infradead.org>
        <dee4b415-0696-90f3-0e2f-2230ff941e1b@gmail.com>
        <ZC2/Pi+M4rWw89x2@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 19:34:38 +0100 Matthew Wilcox wrote:
> On Wed, Apr 05, 2023 at 02:09:55PM -0400, Sean Anderson wrote:
> > On 4/5/23 14:07, Matthew Wilcox wrote:  
> > > We always include linux/* headers before asm/*.  The "sorting" of
> > > headers in this way was inappropriate.  
> > 
> > Is this written down anywhere? I couldn't find it in Documentation/process...  
> 
> Feel free to send a patch.

Patch to documentation, checkpatch or both :)
