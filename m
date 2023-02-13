Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E82694E24
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBMRgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBMRgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:36:51 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A2B5FFB;
        Mon, 13 Feb 2023 09:36:50 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DDE8861CC457B;
        Mon, 13 Feb 2023 18:36:47 +0100 (CET)
Message-ID: <dc78660f-c4cf-37a3-ad5a-91d24624d7c6@molgen.mpg.de>
Date:   Mon, 13 Feb 2023 18:36:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
 <bd10dd58-35ff-e0e2-5ac4-97df1f6a30a8@linux.intel.com>
 <AM9PR04MB8603E350AC2E06CB788909C0E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ad1fc5d4-6d44-4982-71f9-6721aa8914d2@linux.intel.com>
 <AM9PR04MB8603C653BE4266E3343B1F12E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <AM9PR04MB8603C653BE4266E3343B1F12E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Neeraj,


Am 13.02.23 um 18:25 schrieb Neeraj sanjay kale:

>>> Thank you for your review comments and sorry for the delay in
>>> replying to some of your queries.
>> 
>> I made some additional comments against v2 and I meant those ones
>> were not addressed, the ones I made for v1 you've addressed I
>> think.

> I checked with my colleagues Amitkumar and Rohit (in CC) and we can't
> seem to find your comments on V2 patch in our inbox. It might have
> probably been blocked by firewall or due to some other issue we have
> not received it.
> 
> Maybe you could please re-send that email and I can quickly take a
> look at it and resolve them.

lore.kernel.org allows you to access the messages. I found Ilpo’s reply [1].


Kind regards,

Paul


[1]: 
https://lore.kernel.org/linux-bluetooth/1dde194e-2e44-663d-b128-f8ef7edd03f@linux.intel.com/
