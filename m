Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8A6E7C2B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjDSOSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjDSOSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C5B10B;
        Wed, 19 Apr 2023 07:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3683634D7;
        Wed, 19 Apr 2023 14:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4816C433EF;
        Wed, 19 Apr 2023 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681913885;
        bh=JDdMKnzmHcSgbTWc2K6IM954YuFrsrXWJQ/bzSEx1TQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TAR29+nVzDDfT2MEyHfALV+72IhAj3KD9ZN1mCwSxWj9eqmDJC2om5ozNlbMsCoF6
         1xCE36I55NtaHnrl/14m5H3IayZoJ7ECxn6I3T199oE1ILuHAjH2EAO9tRIEexP9fg
         WGgDDyqv9r2k17G/+hSGJgLLMSNcH568gFmIDllyRxluCoWBOqmL8a3z+0FAUtK2K8
         OBS86bnENgISb7EeonlyDVUA+61/yxNHRXLMyzk59u+HzfjFOaLFuOenuBqB0kwJPo
         +ySL6QpCURw4SsbZAduHCbwMa/4uLPgRkFmLJUPReyKsnr15Q/hdryol73987CvK96
         tmBHSAZa1KVTQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: airo: remove ISA_DMA_API dependency
References: <20230417205131.1560074-1-arnd@kernel.org>
        <ZD/t5VARDjrloYdG@corigine.com>
Date:   Wed, 19 Apr 2023 17:17:58 +0300
In-Reply-To: <ZD/t5VARDjrloYdG@corigine.com> (Simon Horman's message of "Wed,
        19 Apr 2023 15:34:29 +0200")
Message-ID: <87v8hsufah.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <simon.horman@corigine.com> writes:

> On Mon, Apr 17, 2023 at 10:51:24PM +0200, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> This driver does not actually use the ISA DMA API, it is purely
>> PIO based, so remove the dependency.
>> 
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hi Arnd,
>
> I think that the subject prefix should probably be 'wifi: airo: '.
> That nit aside, FWIIW, this looks good to me.

I can fix that during commit.

> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Thanks for the review!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
