Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA865F3CE
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbjAESey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbjAESed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:34:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD345E66B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBE761BEC
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53164C433D2;
        Thu,  5 Jan 2023 18:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672943669;
        bh=BIq2CTRaJJ1CxonxvJsny9Cx9K+hFQhw49+T2thwCyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKPevcNCcC5t6eSoraD2cNy2DHpwUnJ2bVeI07g9b8rkkdSD5Jxr1NFjPGLwSD418
         8UCuLCiEROVcdCVmkQi6zFJSxO5P+f2JztaUYTvd7KmYrLixrFMPRriWx1/JDQJGhJ
         4Dql57iOFIqPvLokUNMbyQoKpJT6gmNpfqgQxz6IOHuoHzUS+Ntfc6zuFySKBmKfC2
         GUSCkREL03M0CFx5+CTCQBMoMtUKY3scthBjxk2PMT4O5vY2XcD892iqESJUrNeUwp
         ejeG2Or8oVCMQkQCGvwN783EYNAw2lqTcVaiCmBO+k64Faj3BiJP/9SRkDXLlXGvYH
         V9Q4sgOuVlSUA==
Date:   Thu, 5 Jan 2023 10:34:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 03/15] devlink: split out core code
Message-ID: <20230105103428.65a4e916@kernel.org>
In-Reply-To: <Y7aVeL0QlqiM8sOq@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
        <20230105040531.353563-4-kuba@kernel.org>
        <Y7aVeL0QlqiM8sOq@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 10:16:40 +0100 Jiri Pirko wrote:
> Btw, I don't think it is correct to carry Jacob's review tag around when
> the patches changed (not only this one).

There's no clear rule for that :(  I see more people screaming 
at submitters for dropping tags than for keeping them so I err 
on that side myself.

Here I think the case is relatively clear, since I'm only doing
renames and bike-shedding stuff, and Jake is not one to bike-shed 
in my experience.
