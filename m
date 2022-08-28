Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54625A3E43
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 17:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiH1POX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiH1POV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 11:14:21 -0400
X-Greylist: delayed 481 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Aug 2022 08:14:19 PDT
Received: from 2.mo550.mail-out.ovh.net (2.mo550.mail-out.ovh.net [178.32.119.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F320C32BB4
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 08:14:19 -0700 (PDT)
Received: from player756.ha.ovh.net (unknown [10.109.143.145])
        by mo550.mail-out.ovh.net (Postfix) with ESMTP id 8271222C51
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 15:06:16 +0000 (UTC)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player756.ha.ovh.net (Postfix) with ESMTPSA id 296002D1E2613;
        Sun, 28 Aug 2022 15:05:54 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-101G0040d0c2933-f865-4457-8ea0-b423c711832b,
                    E8B3FA25B4F8D98D1FC0498694F8FFDB0E70245B) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 194.187.74.233
Message-ID: <768ff63a-54f5-9cde-e888-206cdf018df3@milecki.pl>
Date:   Sun, 28 Aug 2022 17:05:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v1 00/14] nvmem: core: introduce NVMEM layouts
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
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
In-Reply-To: <20220825214423.903672-1-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9540875810652269499
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrvdejledgkeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeftrghfrghlucfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpeehkeevtdeiudeffeefjeevffdvteeuhfegfffgveefffejkeeuieetueevtdeutdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedtrddtrddtrddtpdduleegrddukeejrdejgedrvdeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeehiedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehrrghfrghlsehmihhlvggtkhhirdhplhdpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehtd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.08.2022 23:44, Michael Walle wrote:
> This is now the third attempt to fetch the MAC addresses from the VPD
> for the Kontron sl28 boards. Previous discussions can be found here:
> https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/
> 
> 
> NVMEM cells are typically added by board code or by the devicetree. But
> as the cells get more complex, there is (valid) push back from the
> devicetree maintainers to not put that handling in the devicetree.

I dropped the ball waiting for Rob's reponse in the
[PATCH 0/2] dt-bindings: nvmem: support describing cells
https://lore.kernel.org/linux-arm-kernel/0b7b8f7ea6569f79524aea1a3d783665@walle.cc/T/

Before we go any further can we have a clear answer from Rob (or
Krzysztof now too?):


Is there any point in having bindings like:

compatible = "mac-address";

for NVMEM cells nodes? So systems (Linux, U-Boot) can handle them in a
more generic way?


Or do we prefer more conditional drivers code (or layouts code as in
this Michael's proposal) that will handle cells properly based on their
names?


I'm not arguing for any solution. I just want to make sure we choose the
right way to proceed.


> Therefore, introduce NVMEM layouts. They operate on the NVMEM device and
> can add cells during runtime. That way it is possible to add complex
> cells than it is possible right now with the offset/length/bits
> description in the device tree. For example, you can have post processing
> for individual cells (think of endian swapping, or ethernet offset
> handling). You can also have cells which have no static offset, like the
> ones in an u-boot environment. The last patches will convert the current
> u-boot environment driver to a NVMEM layout and lifting the restriction
> that it only works with mtd devices. But as it will change the required
> compatible strings, it is marked as RFC for now. It also needs to have
> its device tree schema update which is left out here.

So do I get it right that we want to have:

1. NVMEM drivers for providing I/O access to NVMEM devices
2. NVMEM layouts for parsing & NVMEM cells and translating their content
?

I guess it sounds good and seems to be a clean solution.


One thing I believe you need to handle is replacing "cell_post_process"
callback with your layout thing.

I find it confusing to have
1. cell_post_process() CB at NVMEM device level
2. post_process() CB at NVMEM cell level


> For now, the layouts are selected by a specifc compatible string in a
> device tree. E.g. the VPD on the kontron sl28 do (within a SPI flash node):
>    compatible = "kontron,sl28-vpd", "user-otp";
> or if you'd use the u-boot environment (within an MTD patition):
>    compatible = "u-boot,env", "nvmem";
> 
> The "user-otp" (or "nvmem") will lead to a NVMEM device, the
> "kontron,sl28-vpd" (or "u-boot,env") will then apply the specific layout
> on top of the NVMEM device.
> 
> NVMEM layouts as modules?
> While possible in principle, it doesn't make any sense because the NVMEM
> core can't be compiled as a module. The layouts needs to be available at
> probe time. (That is also the reason why they get registered with
> subsys_initcall().) So if the NVMEM core would be a module, the layouts
> could be modules, too.
> 
> Michael Walle (14):
>    net: add helper eth_addr_add()
>    of: base: add of_parse_phandle_with_optional_args()
>    nvmem: core: add an index parameter to the cell
>    nvmem: core: drop the removal of the cells in nvmem_add_cells()
>    nvmem: core: add nvmem_add_one_cell()
>    nvmem: core: introduce NVMEM layouts
>    nvmem: core: add per-cell post processing
>    dt-bindings: mtd: relax the nvmem compatible string
>    dt-bindings: nvmem: add YAML schema for the sl28 vpd layout
>    nvmem: layouts: add sl28vpd layout
>    nvmem: core: export nvmem device size
>    nvmem: layouts: rewrite the u-boot-env driver as a NVMEM layout
>    nvmem: layouts: u-boot-env: add device node
>    arm64: dts: ls1028a: sl28: get MAC addresses from VPD
> 
>   .../devicetree/bindings/mtd/mtd.yaml          |   7 +-
>   .../nvmem/layouts/kontron,sl28-vpd.yaml       |  52 +++++
>   .../fsl-ls1028a-kontron-kbox-a-230-ls.dts     |   8 +
>   .../fsl-ls1028a-kontron-sl28-var1.dts         |   2 +
>   .../fsl-ls1028a-kontron-sl28-var2.dts         |   4 +
>   .../fsl-ls1028a-kontron-sl28-var4.dts         |   2 +
>   .../freescale/fsl-ls1028a-kontron-sl28.dts    |  13 ++
>   drivers/nvmem/Kconfig                         |   2 +
>   drivers/nvmem/Makefile                        |   1 +
>   drivers/nvmem/core.c                          | 183 +++++++++++----
>   drivers/nvmem/imx-ocotp.c                     |   4 +-
>   drivers/nvmem/layouts/Kconfig                 |  22 ++
>   drivers/nvmem/layouts/Makefile                |   7 +
>   drivers/nvmem/layouts/sl28vpd.c               | 144 ++++++++++++
>   drivers/nvmem/layouts/u-boot-env.c            | 147 ++++++++++++
>   drivers/nvmem/u-boot-env.c                    | 218 ------------------
>   include/linux/etherdevice.h                   |  14 ++
>   include/linux/nvmem-consumer.h                |  11 +
>   include/linux/nvmem-provider.h                |  47 +++-
>   include/linux/of.h                            |  25 ++
>   20 files changed, 649 insertions(+), 264 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>   create mode 100644 drivers/nvmem/layouts/Kconfig
>   create mode 100644 drivers/nvmem/layouts/Makefile
>   create mode 100644 drivers/nvmem/layouts/sl28vpd.c
>   create mode 100644 drivers/nvmem/layouts/u-boot-env.c
>   delete mode 100644 drivers/nvmem/u-boot-env.c
