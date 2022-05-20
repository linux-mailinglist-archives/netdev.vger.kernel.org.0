Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC21952E266
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbiETCSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiETCSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFA112E31D;
        Thu, 19 May 2022 19:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83CC861ACC;
        Fri, 20 May 2022 02:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C431DC385AA;
        Fri, 20 May 2022 02:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653013084;
        bh=rCZNmJ2ylnRRed8mdSoVU3DvNe0665kVCH8jrn81CmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKlYUb/GYEENdFD53r3OcLMvj9GCqu1roXIcgfzLz9Y/tcr99lHXqyF+ilpcOccr9
         YSA4jC9a4cHGrJdTikCbsp/XTmUO4LdMeLfhFTDyfsGkj/e0E/f18akV9bh1SCyVAD
         KcAYxgAGuPhhY1ZEQrzWNo9a9ImEjhhssPyX+l5OfWYN0kawiaciNEn4aWTuf0SftQ
         6zOsu3H34asfbbpvKhJayeh98tpSAUNt+BR1zWfX9rjgGDw7t8Tyd4tE2lafbhjAQn
         yEB7JHv1fBSgJ+rkb+IzrHDv3n+K0eNyWdOmxtUIOenR0jANZ7wIwNn2xfOK328moL
         gfNoFc2CkPqgg==
Date:   Thu, 19 May 2022 19:18:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/4] net: tcp: reset 'drop_reason' to
 NOT_SPCIFIED in tcp_v{4,6}_rcv()
Message-ID: <20220519191803.627d5708@kernel.org>
In-Reply-To: <20220519190915.086d4c89@kernel.org>
References: <20220513030339.336580-1-imagedong@tencent.com>
        <20220513030339.336580-5-imagedong@tencent.com>
        <20220519084851.4bce4bdd@kernel.org>
        <CADxym3Y7MkGWmu+8y8Kpcf39QJ5207-VaEnCsYKRDqnpre1O0Q@mail.gmail.com>
        <20220519190915.086d4c89@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 19:09:15 -0700 Jakub Kicinski wrote:
> On Fri, 20 May 2022 09:46:49 +0800 Menglong Dong wrote:
> > > This patch is in net, should this fix have been targeting net / 5.18?    
> > 
> > Yeah, I think it should have. What do I need to do? CC someone?  
> 
> Too late now, I was just double checking. It can make its way to the
> current release via stable in a week or two.

Ah, FWIW my initial question was missing "-next" - I meant to say that
the patch is in net-next rather than net. I think you got what I meant..
