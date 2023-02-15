Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670D46972B9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjBOAlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBOAlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:41:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED98E29421
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 16:41:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94963B81EA3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A22C433D2;
        Wed, 15 Feb 2023 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676421674;
        bh=If1sgSeUpDZd1xAZ+A6auH+x1dunXH3QRIoMSeToUrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Put+VEuYZLOpEmjN7Eqxhf+5pjNf3anAA5iyvAQWbaQMgS/2kYie0lqpxeUDQOHrB
         CgTTna1nJA8XnAdK2+apemqM/yUf650gPgKyMXRDWLcc5isDigAziaENh4hf0icndz
         uG1dc6iv5qoQzekxTjxgo/OYrsCcJtxDpbcEnutu98odt4OWnNWXxOzGveWl2jX/+0
         3LgHPKcOPI5g1jwuxRqTxsLFqO+TCT6asMInZquVXU1q6016mx3xtDGg9s8bdi2nnn
         aCaCQB2lCCH98T51PnflRq6/lIRr0ZRDrn/hpenylgGLIYs0lNrRzujH+D0oOhQAvP
         RNGVEfOYRfmwg==
Date:   Tue, 14 Feb 2023 16:41:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Message-ID: <20230214164113.0c25dfdd@kernel.org>
In-Reply-To: <CAM0EoMmcMWrLueyaEco6r+VDbgLDmLf7O=80a8Rd+AJo-ScQOQ@mail.gmail.com>
References: <20230214134915.199004-1-jhs@mojatatu.com>
        <Y+uZ5LLX8HugO/5+@nanopsycho>
        <20230214134013.0ad390dd@kernel.org>
        <20230214134101.702e9cdf@kernel.org>
        <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
        <20230214152203.6ba83960@kernel.org>
        <CAM0EoMmcMWrLueyaEco6r+VDbgLDmLf7O=80a8Rd+AJo-ScQOQ@mail.gmail.com>
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

On Tue, 14 Feb 2023 18:52:18 -0500 Jamal Hadi Salim wrote:
> So it will work in either case (of deleting or keeping the uapi
> around). It may be a bad sample space - but if we do keep the uapi,
> how long would that be for?

Last time we deleted some ATM driver and the uAPI removal broke 
a random ATN package in debian, IIRC. The due diligence would probably
mean trying to find out if there's anything in debian which needs those
defines..

Is it possible to "download all the debian sources"? Or those which
depend on the kernel headers?
