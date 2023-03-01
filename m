Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8B6A654F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 03:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjCACKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 21:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCACKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 21:10:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BC5302AA;
        Tue, 28 Feb 2023 18:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C18AB80EB7;
        Wed,  1 Mar 2023 02:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0BAC433EF;
        Wed,  1 Mar 2023 02:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677636629;
        bh=DwD4dwYD5ZCP16+h0w7+VuPBS+OuOFme1UfFZif6HPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+/wA6Mz2o3AGsg6Sejul69Cxjb+XHyCSbWcNdrSmnNY6JXea9hVnukr0/uHT0S7R
         td/beP0ilLOkJU+JDsbvX6aFyeadTjnhdM9KE1SnoYKLh+equLmS3fvYEjHfk93Fvh
         bZ5l54i6rIfIKFmKHg7Iv6hj6Pz+c3LY+tCbv9UPAAPgv777BHBj3ARQW/NqMBb19H
         SKRCWW1bLthfgGJAd9sUO7Cnm82s5IgNv0NQ0s3qMkUwH1hCRr2Gp59QatARsiSWCU
         dhEHhI4JdgPJNJJ4VImir3hVeXKp76fdruPD1qHWd7EU1kWrVFVsM01igF4PzynPAT
         O8s8FWdT0WYDA==
Date:   Tue, 28 Feb 2023 21:10:27 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Breno Leitao <leitao@debian.org>,
        Michael van der Westhuizen <rmikey@meta.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 26/53] netpoll: Remove 4s sleep during
 carrier detection
Message-ID: <Y/60ExOLZSb4oWP/@sashalap>
References: <20230226144446.824580-1-sashal@kernel.org>
 <20230226144446.824580-26-sashal@kernel.org>
 <20230227101532.5bc82c09@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230227101532.5bc82c09@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:15:32AM -0800, Jakub Kicinski wrote:
>On Sun, 26 Feb 2023 09:44:18 -0500 Sasha Levin wrote:
>> From: Breno Leitao <leitao@debian.org>
>>
>> [ Upstream commit d8afe2f8a92d2aac3df645772f6ee61b0b2fc147 ]
>>
>> This patch removes the msleep(4s) during netpoll_setup() if the carrier
>> appears instantly.
>>
>> Here are some scenarios where this workaround is counter-productive in
>> modern ages:
>
>Potential behavior change, can we wait 4 weeks, until it's been
>in a couple of -rcs?

Dropped for now, will revisit in a few weeks. Thanks!

-- 
Thanks,
Sasha
