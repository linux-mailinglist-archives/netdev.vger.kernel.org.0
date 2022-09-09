Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E2C5B2B74
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiIIBVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIIBVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA410B032;
        Thu,  8 Sep 2022 18:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3374561DE3;
        Fri,  9 Sep 2022 01:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66532C433C1;
        Fri,  9 Sep 2022 01:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662686509;
        bh=fVPajho/aOku1+8nabWUPcT67X3OaItOI+7Sotm7FB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T/d4eyoFdQxk8p+PjLpEOdlfzaANQNJguMj9T0/2rVrTISomyq4dO9J6/B9wwZ327
         ZXKzlYzzzK4Rh1mwKxe+7V1Z1/XpfCaggPh9JwTbGkAWf61f/3UwZQtacdq4Iv5do/
         ATaMTXBe6nVFU+P5b5LV1uzi7sXQsm0Vpfe52HLtOS7v5ZGJqxpDe7uTA7vNiqEekY
         X6iLjiSF36DXHQhGDcIKrQ9cvd6Mcblx4ske0Cpk//Bfgb4v7l330gkspuQfLfzETh
         GP15eKqlJLQcSQHiK/rQIwpSANrstQAdfbtRkv2fvfNIiVc4fZ185yc9IV8MeUMTKQ
         +Yb+dEfLjr+6Q==
Date:   Thu, 8 Sep 2022 21:21:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 24/33] fec: Restart PPS after link state
 change
Message-ID: <YxqVLDukdCpFKWd7@sashalap>
References: <20220830171825.580603-1-sashal@kernel.org>
 <20220830171825.580603-24-sashal@kernel.org>
 <243d3362-403d-7a94-34fa-12385100cc53@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <243d3362-403d-7a94-34fa-12385100cc53@prolan.hu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 03:02:46PM +0200, Csókás Bence wrote:
>
>On 2022. 08. 30. 19:18, Sasha Levin wrote:
>>From: Csókás Bence <csokas.bence@prolan.hu>
>>
>>[ Upstream commit f79959220fa5fbda939592bf91c7a9ea90419040 ]
>>
>>On link state change, the controller gets reset,
>>causing PPS to drop out and the PHC to lose its
>>time and calibration. So we restart it if needed,
>>restoring calibration and time registers.
>
>There is an ongoing investigation on netdev@ about a potential kernel 
>panic on kernels newer than 5.12 with this patch applied. Please hold 
>off on backporting to 5.19 until the bugfix is applied to upstream.

Will do.

-- 
Thanks,
Sasha
