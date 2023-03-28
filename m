Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2506CB7B2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjC1HKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjC1HKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:10:12 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B30D1BE4;
        Tue, 28 Mar 2023 00:10:10 -0700 (PDT)
Received: from [IPV6:2003:e9:d70f:38af:8fa6:61a3:c689:f3f7] (p200300e9d70f38af8fa661a3c689f3f7.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:38af:8fa6:61a3:c689:f3f7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 31052C006B;
        Tue, 28 Mar 2023 09:10:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1679987408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DuBv8CUC+KVrr7fTs+K4LUeaLTIXU8XDSv8HwWaDwWU=;
        b=MhSZCyhrb2yRFibanZkIbY445V/khVKyWJNbpY9Jomgz58ErUMkjkJXQMzB0IPKI43gLtR
        OOmKilTpNyjhRP7XaBdwaRbhmo417LWdIBLpsvBPHXFddymO0aaVS50CqIhRbVVlhd7cAa
        Irl+QDkwgNUhZNamkRyX9T2NBpZfX0mlSgRwY+X0JaoUYaP84ukqV0SAAL7GxIFEWK5uql
        Ih8wtm4SaVCawYHfeAw6rwHQcKbqOsHS9/wDRsxVPQfMHhgfRVRm8Yg3j+ZfSEnZuKFyPk
        MOETCVGVv+yfTk+Cc5YZgPOOuOWDezbK4jbvvL3kN9wK6waaFnh6c4vTvnvkxg==
Message-ID: <605a1c16-0c03-a3be-9aec-12bb4d0113dc@datenfreihafen.org>
Date:   Tue, 28 Mar 2023 09:10:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: pull-request: ieee802154 for net 2023-03-24
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        netdev@vger.kernel.org
References: <20230324173931.1812694-1-stefan@datenfreihafen.org>
 <20230327193842.59631f11@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230327193842.59631f11@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub.

On 28.03.23 04:38, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 18:39:31 +0100 Stefan Schmidt wrote:
>> An update from ieee802154 for your *net* tree:
>>
>> Two small fixes this time.
>>
>> Dongliang Mu removed an unnecessary null pointer check.
>>
>> Harshit Mogalapalli fixed an int comparison unsigned against signed from a
>> recent other fix in the ca8210 driver.
> 
> Hi Stefan! I see a ieee802154-for-net-2023-03-02 tag in your tree but
> no ieee802154-for-net-2023-03-24:
> 
> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git \
> 	tags/ieee802154-for-net-2023-03-24
> fatal: couldn't find remote ref tags/ieee802154-for-net-2023-03-24

Sorry for that. I did not update my pull request script when changing 
the git tree URLs to our team tree. Updated now.

The tag is now on the tree above. You want me to send a new pull request 
or do you take it from here?

regards
Stefan Schmidt
