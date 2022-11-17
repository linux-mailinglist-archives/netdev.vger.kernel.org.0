Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E64462DAFC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240245AbiKQMeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbiKQMdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:33:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AEDE17
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7FE8B81FE9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6612C43470;
        Thu, 17 Nov 2022 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668688402;
        bh=afKBreaLze6quqlPuHlTS+8T3zAztg/zJe0KgC3tCgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lrhHTpBgY7aobakQ3uoqLuxo7ITt1eK/ze65cXoryRoHJd/kFjzddTk8IUmeoz56n
         4RIVTMoDGSXHs2KqLK/K+XL6vecfPLNLr0Q8teGLyOnxnn1p2Ex7gGdPOZCRkVo1oy
         D86lOBwf9tYRTlPZIeSO4Olm9sFxd27v+PmdLsy4hSEj3I7DPVpomnF6yN7auR6RLn
         FLm9S/phHiebbnnVvOPWv1ssmzQIaW6TQfbR4hEJAGrmt5Za1v6HfEQ3PCE3Mqz6r4
         0V7TZtHbupmGaiHMmoNOtzSqCTIhmKXiwqJGem8LlwixJcdcrmlHgzEKzBH/2v3mfV
         ElCD87foY0Kxg==
Date:   Thu, 17 Nov 2022 14:33:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 8/8] xfrm: document IPsec packet offload mode
Message-ID: <Y3YqDgaEOG9fuM2x@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <582d8f57e2faa56ba06ff24701413aa8c397be06.1667997522.git.leonro@nvidia.com>
 <20221117121544.GL704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117121544.GL704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:15:44PM +0100, Steffen Klassert wrote:
> On Wed, Nov 09, 2022 at 02:54:36PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> >  
> > +and for packetoffload
> 
> Maybe better 'packet offload'
> 
> >  
> > +Full offload mode:
> 
> This is now 'Packet offload mode'


I'll fix.

Thanks
