Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B29361FA90
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiKGQwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiKGQwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:52:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD293193DE
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46673611C8
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 16:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D959C433C1;
        Mon,  7 Nov 2022 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667839939;
        bh=j2ajYyJZNlWHjtWHg2+EdPLRTdyyWgLVr1tXfnPSCAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HpMNIQTiatehR4wGVYiWohtTCj/tPwiUSauvxFkaG5djF27BTlqe0SGipJ04NJSl5
         XcQLqf7H30VpbNU0RXTuBKGyfAIajw/ELSIU4XnGPiNsH4yDc/JNZO4Ow5NFr4eSm8
         aBtwTsHxfew+dkZqVks+fAPv1mX1ORYX+4li1XRRBHDsW/v8TvKn1Kye9/gjeK3req
         QqxzR2sqOaFPidbDOHvpO0TP3eSBoOdDO3r/SZ2ELMZ1xwrWxOc8rim6GhpKG/Sp9h
         kHTldzAnTnoj6ZfLKbwKi1eoKFPxGrMymi5/qzjXVMoJB77vq1JmR8Wr7E0sMELOkk
         DRho5cZxPB6yQ==
Date:   Mon, 7 Nov 2022 08:52:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: expose the info about version
 representing a component
Message-ID: <20221107085218.490e79ed@kernel.org>
In-Reply-To: <Y2YsSfcGgrxuuivW@nanopsycho>
References: <20221104152425.783701-1-jiri@resnulli.us>
        <20221104192510.32193898@kernel.org>
        <Y2YsSfcGgrxuuivW@nanopsycho>
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

On Sat, 5 Nov 2022 10:26:33 +0100 Jiri Pirko wrote:
>> Didn't I complain that this makes no practical sense because
>> user needs to know what file to flash, to which component?
>> Or was that a different flag that I was complaining about?  
> 
> Different. That was about exposing a default component.

Oh, my bad. But I think the same justification applies here.
Overloading the API with information with no clear use seems
counter-productive to me.
