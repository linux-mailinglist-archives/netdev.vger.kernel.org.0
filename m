Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731584E7DB0
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiCYWCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCYWCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:02:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B134EF44
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7D83B829F3
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 22:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72193C2BBE4;
        Fri, 25 Mar 2022 22:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648245675;
        bh=Qcx+7zRlv8nrwUzwnDZKF5gqBv9kUo50DB8FHwTGkdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJMIOk0IQCOccOGwMy7UNdz5Vu41ZBCFiAxXhEpCfP2kLdL5m0026I5azt5JIIXdH
         lI4m9kHxYLXdk5fWOu97d+3WvgeWwE+7ZTR5UHCMU4a+BKVvb2b544UhPt0IeIXrAF
         7PfIFg/iEmjjgn0XS3wm8tPQUkJOfGs/iiyDkwZYyfS5XjfOkgYu/WjdhBVUVjmERh
         o0HjP3E9lmWK4Xe8/Q0aaNtiQkRHj26B04bVPtBQIA2oD7AdvP7a6B1dnxzoeED03t
         pGSr8U4ecqdmSccSsnYQ/HtATcsfnhnj2ZaqrrFuZBONHRlVBUSMkCEJdg9rssPAKT
         AsU3o52IwiNNA==
Date:   Fri, 25 Mar 2022 15:01:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: ensure net_todo_list is processed quickly
Message-ID: <20220325150114.08660eae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <05fc9b4d27dfc6ff9eb96062016e2ead5ea1d1c1.camel@sipsolutions.net>
References: <20220325225055.37e89a72f814.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
        <20220325145845.642c2082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <05fc9b4d27dfc6ff9eb96062016e2ead5ea1d1c1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 22:59:25 +0100 Johannes Berg wrote:
> On Fri, 2022-03-25 at 14:58 -0700, Jakub Kicinski wrote:
> > On Fri, 25 Mar 2022 22:50:55 +0100 Johannes Berg wrote:  
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > In [1], Will raised a potential issue that the cfg80211 code,
> > > which does (from a locking perspective)  
> > 
> > LGTM, but I think we should defer this one a week and take it 
> > to net-next when it re-opens, after the merge window.  
> 
> Yeah that makes sense. Do you want me to resend it then?

Yes, please!
