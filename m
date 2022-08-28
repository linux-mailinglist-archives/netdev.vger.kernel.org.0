Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E815A3DEF
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 16:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiH1OE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 10:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiH1OE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 10:04:27 -0400
X-Greylist: delayed 509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Aug 2022 07:04:25 PDT
Received: from 16.mo550.mail-out.ovh.net (16.mo550.mail-out.ovh.net [178.33.104.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF0332DAA
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 07:04:25 -0700 (PDT)
Received: from player157.ha.ovh.net (unknown [10.108.16.29])
        by mo550.mail-out.ovh.net (Postfix) with ESMTP id 4F7FC22D99
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 13:55:54 +0000 (UTC)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player157.ha.ovh.net (Postfix) with ESMTPSA id 1047C2DF32520;
        Sun, 28 Aug 2022 13:55:32 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-99G003f23c38e5-03f4-4967-903a-0a692511f0a2,
                    E8B3FA25B4F8D98D1FC0498694F8FFDB0E70245B) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 194.187.74.233
Message-ID: <ca7d8fe6-023f-1e2d-da34-c23d0cdc3b03@milecki.pl>
Date:   Sun, 28 Aug 2022 15:55:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [RFC PATCH v1 13/14] nvmem: layouts: u-boot-env: add device node
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-14-michael@walle.cc>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
In-Reply-To: <20220825214423.903672-14-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8352488460933508027
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrvdejledgjeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeftrghfrghlucfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpefftedtteffieevudduueelkeeukefhhfelvdevleffhfeiueelffegtddvudejvdenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppedtrddtrddtrddtpdduleegrddukeejrdejgedrvdeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrudehjedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehrrghfrghlsehmihhlvggtkhhirdhplhdpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehtd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.08.2022 23:44, Michael Walle wrote:
> Register the device node so we can actually make use of the cells from
> within the device tree.
> 
> This obviously only works if the environment variable name can be mapped
> to the device node, which isn't always the case. Think of "_" vs "-".
> But for simple things like ethaddr, this will work.

We probably shouldn't support undocumented syntax (bindings).

I've identical local patch that waits for
[PATCH] dt-bindings: nvmem: u-boot,env: add basic NVMEM cells
https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20220703084843.21922-1-zajec5@gmail.com/
to be accepted.
