Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F01B646A34
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiLHINu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHINh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:13:37 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59565477A;
        Thu,  8 Dec 2022 00:13:36 -0800 (PST)
Received: from [IPV6:2003:e9:d707:bb64:2bb8:7d68:ff48:d4b2] (p200300e9d707bb642bb87d68ff48d4b2.dip0.t-ipconnect.de [IPv6:2003:e9:d707:bb64:2bb8:7d68:ff48:d4b2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B7A52C042A;
        Thu,  8 Dec 2022 09:13:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1670487214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1R2BJ+a6CzIk8AqdhME0WgEMohI422Z6fCD3wTPRzw=;
        b=XsH98MOXyfSsKjcV1S1X2gqb2JjDIFifZUBRq/Kh0Wy2HOnYz0waC2NZ0NAzxcjH5KNwGt
        mJmWupwUKKL34oYLx2uU2mT1MuAslA3fNnY5DTKx6ilXFHu4O333UOQ6ZPOgRsPuatp5zr
        NDuxF6/x1ZO9JlmKeoKRlBMjGAnSEAAuzShHrdE2/2aaFKCCNXvuF39if8haCT9bAAVb/t
        OWaAilAUZOwHy/iaGPoDqb9yrKvDklhTZjBu66c2KQQQ/k7JtF9FugfwcbzdKryCB2TV4U
        3EgYDca/aP/woOEVRBNvBMKiWGTFff7HaAPke9I5xhqzM8miZdszEaoL8lA42A==
Message-ID: <2c754517-b9c7-cb2b-4a76-d95b377bfc55@datenfreihafen.org>
Date:   Thu, 8 Dec 2022 09:13:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: pull-request: ieee802154 for net 2022-12-05
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
References: <20221205122515.1720539-1-stefan@datenfreihafen.org>
 <20221207172625.7da96708@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221207172625.7da96708@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub.

On 08.12.22 02:26, Jakub Kicinski wrote:
> On Mon,  5 Dec 2022 13:25:15 +0100 Stefan Schmidt wrote:
>> Hello Dave, Jakub.
>>
>> An update from ieee802154 for your *net* tree:
>>
>> Three small fixes this time around.
>>
>> Ziyang Xuan fixed an error code for a timeout during initialization of the
>> cc2520 driver.
>> Hauke Mehrtens fixed a crash in the ca8210 driver SPI communication due
>> uninitialized SPI structures.
>> Wei Yongjun added INIT_LIST_HEAD ieee802154_if_add() to avoid a potential
>> null pointer dereference.
> 
> Sorry for the lateness, we are backed up since the weekend :(
> 
> I believe this is now in net:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=92439a859000c6f4c74160a3c08c1a519e3ca125
> 
> But the bot has not replied?

True, no bot reply but I can see the merge in the net tree. All good.

regards
Stefan Schmidt
