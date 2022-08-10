Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C3D58E6A2
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiHJFLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiHJFLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:11:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA46B6D54E
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 22:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2719FCE192F
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D0EC433D6;
        Wed, 10 Aug 2022 05:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660108262;
        bh=goIJs8HUH9om5nJ66IdFCwkBO+AeFVWCjzCAN+gAWzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q6RanID053p30efqmyVj/YRYbm2VuLr6pech29iGBtJZJJ3wA1YZ7PJ/A1V68GWe7
         K4nJfx0+wwKIgzZhIKnL9eYq7LwD7xkHTX+wxHq5qlMWaW899dEDhwglUB/yiJI5/z
         vduq1dgMtOoyahgdoL54korMZFbm0KxK0z4hubgOTCGWlPafRBHk0ziIK0ypd5tee4
         BIfxoGjngEuBLWRYQ+my0hEZ6psILuLPXVmVm4vadOriBUgboIrN9kAYdlOe4aHON/
         tW57SuLoUal1lRK5Sdp2fg3PMfHRQ5DxDDjFGWU31MsbTKuMEAQttEC1HnA0RKO1u/
         VCvRv7yMQfj3Q==
Date:   Tue, 9 Aug 2022 22:11:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie Meng <jmeng@fb.com>
Cc:     <netdev@vger.kernel.org>, <kafai@fb.com>
Subject: Re: [PATCH net-next] tcp: Make SYN ACK RTO tunable by BPF programs
 with TFO
Message-ID: <20220809221101.30d59085@kernel.org>
In-Reply-To: <20220806000635.472853-1-jmeng@fb.com>
References: <20220806000635.472853-1-jmeng@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 17:06:35 -0700 Jie Meng wrote:
> Instead of the hardcoded TCP_TIMEOUT_INIT, this diff calls tcp_timeout_init
> to initiate req->timeout like the non TFO SYN ACK case.
> 
> Tested using the following packetdrill script, on a host with a BPF
> program that sets the initial connect timeout to 10ms.

Please make sure to CC the relevant maintainers
(./scripts/get_maintainer.pl). Apart from that:


# Form letter - net-next is closed

We have already sent the networking pull request for 6.0
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
