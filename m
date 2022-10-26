Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFDA60DCA7
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiJZH6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiJZH6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:58:18 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456A2A98C7;
        Wed, 26 Oct 2022 00:58:17 -0700 (PDT)
Received: from [10.0.252.2] (unknown [92.79.119.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BABE5C025B;
        Wed, 26 Oct 2022 09:58:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1666771095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAHH6ooeSYjB8S/Chqr94kL7w8pMRqj/Lx1u8nNDfjE=;
        b=XrXzJch8ujcFDz1/PPl3Esub/rn7dmzVcFO739g0V8hsiHoydHGsmTPVG6r1TKtlwGW68M
        SPk0Mf1l3jbRfL1ml1VM2Z6scZGdDciHk+BmPtWDR5sjIBjgqGSYFuTm1bGOx24+65J0Gh
        9bjLjpuWw4ii5sPrl4cXnSoZfb8f/zQH/xbZo8S+MakBzq3DbdkyuPCfViuNfADgtOVFGs
        0m9affo58VA34qSlfTvw3Rx+KDHDz04+CiAu4R6GAjIq4qYUOAPptDzpyh8MeFGa56MNAi
        m1iZbev1+m53yu5avkDyAMa0+kV2YdjGhs0AdoZ7+34xtAsgfcmkW+aucU3MAA==
Message-ID: <6ff97af7-05ed-8659-ab25-63cd3591217c@datenfreihafen.org>
Date:   Wed, 26 Oct 2022 09:58:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: pull-request: ieee802154-next 2022-10-25
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
References: <20221025102029.534025-1-stefan@datenfreihafen.org>
 <20221025195920.68849bdd@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221025195920.68849bdd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 26.10.22 04:59, Jakub Kicinski wrote:
> On Tue, 25 Oct 2022 12:20:29 +0200 Stefan Schmidt wrote:
>> Hello Dave, Jakub.
>> 
>> An update from ieee802154 for *net-next*
>> 
>> One of the biggest cycles for ieee802154 in a long time. We are
>> landing the first pieces of a big enhancements in managing PAN's.
>> We might have another pull request ready for this cycle later on,
>> but I want to get this one out first.
>> 
>> Miquel Raynal added support for sending frames synchronously as a
>> dependency to handle MLME commands. Also introducing more filtering
>> levels to match with the needs of a device when scanning or
>> operating as a pan coordinator. To support development and testing
>> the hwsim driver for ieee802154 was also enhanced for the new
>> filtering levels and to update the PIB attributes.
>> 
>> Alexander Aring fixed quite a few bugs spotted during reviewing
>> changes. He also added support for TRAC in the atusb driver to have
>> better failure handling if the firmware provides the needed
>> information.
>> 
>> Jilin Yuan fixed a comment with a repeated word in it.
> 
> nit: would you mind sorting these out before we pull ?
> 
> net/mac802154/util.c:27: warning: Function parameter or member 'hw'
> not described in 'ieee802154_wake_queue' net/mac802154/util.c:27:
> warning: Excess function parameter 'local' description in
> 'ieee802154_wake_queue' net/mac802154/util.c:53: warning: Function
> parameter or member 'hw' not described in 'ieee802154_stop_queue' 
> net/mac802154/util.c:53: warning: Excess function parameter 'local'
> description in 'ieee802154_stop_queue'

I certainly can fix this up. Sorry for missing it initially.

Pushed a fix and sent a new pull request as v2 with today's date.

regards
Stefan Schmidt
