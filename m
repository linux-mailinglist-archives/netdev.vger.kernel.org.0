Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19B660504C
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJSTWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJSTWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:22:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5A516A4DB
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C477B825C9
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68E6C433C1;
        Wed, 19 Oct 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666207347;
        bh=T6fqAolzjELZuxyOyMrezv4o5JcGbW2wPVWNHzEQrLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GOq1an49vU4mqBNa57YvHJCl722WayC6lPQO7IeUc6UDQKV+0oDINE9PSgXw6mxYQ
         qUaD4LM0MdpucyDQPP0BKHteHxt5mRoY1DMX6m2O3leVWDfJYB9u2Qk8VyfMvufzPD
         LXCtzI8a1g2YTezUfZncSxLkykOsdPP0wRT25NRVbSlJosxwVfOlbqCeFzcEzXMqg+
         zed5mRhfmMDJuet3S6xFwotuL873jbwucw1tj+jjumlmoTY6lOY07YEmWe+r9RQlcs
         CKNextxt0/akpxMd4QE/RxAPesieAWtnRiDnt7m8zLaijxRVjW56U4ANETL7NLIbDo
         WOuau8lZ5MDCA==
Date:   Wed, 19 Oct 2022 12:22:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 06/13] genetlink: add policies for both doit
 and dumpit in ctrl_dumppolicy_start()
Message-ID: <20221019122225.30c1a188@kernel.org>
In-Reply-To: <f608f1dc2d522a32a6cedbd44a6213c4d231464b.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-7-kuba@kernel.org>
        <f608f1dc2d522a32a6cedbd44a6213c4d231464b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 10:08:01 +0200 Johannes Berg wrote:
> > +		}
> > +		if (dump.policy) {  
> 
> nit: to me a blank line in places like that would be nicer, but ymmv

mmmm, if you don't mind i'll keep as is... :)
