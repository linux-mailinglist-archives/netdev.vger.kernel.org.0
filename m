Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C951261FCC0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiKGSFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiKGSFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB0F24F03
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36B8C611BD
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 18:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73169C433C1;
        Mon,  7 Nov 2022 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667844127;
        bh=xe5Uvsbc86PEPW2FpNGGvW+O6RsOv36sTwOle1GCkEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uh7d4wTIL46Ta44MiNHvgFdEJ9AE5R2L3TAp0Yrjy/ODlSCwZsQa43SRS39L1h/l7
         xU/eoMSzhEVfuPT7GqfYJf+3Ko2elgVTjJ12Z+XZCgrvGMACtaqU1rb76L66gPyJlG
         QKIZjIIGMdy8JPjeSeCHmV3pT5bP3vaKpYOYBU1Ks3etAh8bvWG/505F3Job08ZmuB
         aNkudCetXyflALH8L7iLWdewXKFtvNd63H08LBl4tBFrZ2m1IsPptBoGE0E8cnTeG5
         KTce32vQ8e1W1nZmx5dc8+I3c3Mfk5baogYPcQ1MchIGNEAdtE2DIoa0R9tckPbAAv
         adnWdIAiR1QlA==
Date:   Mon, 7 Nov 2022 10:02:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: expose the info about version
 representing a component
Message-ID: <20221107100206.1e2f3743@kernel.org>
In-Reply-To: <Y2k6SpW9Wu4Ctznm@nanopsycho>
References: <20221104152425.783701-1-jiri@resnulli.us>
        <20221104192510.32193898@kernel.org>
        <Y2YsSfcGgrxuuivW@nanopsycho>
        <20221107085218.490e79ed@kernel.org>
        <Y2k6SpW9Wu4Ctznm@nanopsycho>
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

On Mon, 7 Nov 2022 18:03:06 +0100 Jiri Pirko wrote:
>> Oh, my bad. But I think the same justification applies here.
>> Overloading the API with information with no clear use seems
>> counter-productive to me.  
> 
> Well, it gives the user hint about what he can pass as a "component
> name" on the cmdline. Otherwise, the user has no clue.

The command line contains:
 - device
 - component (optional)
 - fw file to flash

What scenario are you thinking of where the user has the file they want
to flash, intent to flash a particular component only but does not know
whether that component can be flashed? 
