Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107A6692238
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjBJPb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjBJPby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:31:54 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5035596;
        Fri, 10 Feb 2023 07:31:48 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31AFV6Pr040918;
        Fri, 10 Feb 2023 09:31:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1676043066;
        bh=Fjzk5JVx8ctbdtCLPvudP63oV7cXI9Tq/NfyxDy4p7U=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=QU3toFf8xybywgYfzBShVZqqMl8TdwU0b3me6WZQcKMZtcMP6MD/79CR6wcjN5rEK
         y8YQP7pNiQCecghMxGdWQI/7U/ApoT/gVa0ypal2cMyN5wFrS7LocrUvjHVcjo5yyQ
         QvxQkkRBVPxTMI9dhKKfmXc4hge9X6Mm+dugq09A=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31AFV6YF009143
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Feb 2023 09:31:06 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 10
 Feb 2023 09:31:05 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 10 Feb 2023 09:31:05 -0600
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 31AFUxRW127820;
        Fri, 10 Feb 2023 09:31:00 -0600
Message-ID: <69f54246-5541-7899-f4ed-76d0a600e1b0@ti.com>
Date:   Fri, 10 Feb 2023 21:00:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG
 Ethernet
To:     Rob Herring <robh@kernel.org>, MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Paolo Abeni <pabeni@redhat.com>,
        <srk@ti.com>, <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <ssantosh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <nm@ti.com>, "David S. Miller" <davem@davemloft.net>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Roger Quadros <rogerq@kernel.org>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
 <167603709479.2486232.8105868847286398852.robh@kernel.org>
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <167603709479.2486232.8105868847286398852.robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/02/23 19:28, Rob Herring wrote:
>=20
> On Fri, 10 Feb 2023 17:19:56 +0530, MD Danish Anwar wrote:
>> From: Puranjay Mohan <p-mohan@ti.com>
>>
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet hardware. The ICSSG driver uses the PRU and PRUSS consu=
mer
>> APIs to interface the PRUs and load/run the firmware for supporting
>> ethernet functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 184 +++++++++++++++++=
+
>>  1 file changed, 184 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-pru=
eth.yaml
>>
>=20
> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_chec=
k'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> ./Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml: Unable to=
 find schema file matching $id: http://devicetree.org/schemas/remoteproc/=
ti,pru-consumer.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings=
/net/ti,icssg-prueth.example.dtb: ethernet: False schema does not allow {=
'compatible': ['ti,am654-icssg-prueth'], 'pinctrl-names': ['default'], 'p=
inctrl-0': [[4294967295]], 'ti,sram': [[4294967295]], 'ti,prus': [[429496=
7295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]], 'firm=
ware-name': ['ti-pruss/am65x-pru0-prueth-fw.elf', 'ti-pruss/am65x-rtu0-pr=
ueth-fw.elf', 'ti-pruss/am65x-txpru0-prueth-fw.elf', 'ti-pruss/am65x-pru1=
-prueth-fw.elf', 'ti-pruss/am65x-rtu1-prueth-fw.elf', 'ti-pruss/am65x-txp=
ru1-prueth-fw.elf'], 'ti,pruss-gp-mux-sel': [[2, 2, 2, 2, 2, 2]], 'dmas':=
 [[4294967295, 49920], [4294967295, 49921], [4294967295, 49922], [4294967=
295, 49923], [4294967295, 49924], [4294967295, 49925], [4294967295, 49926=
], [4294967295, 49927], [4294967295, 17152], [4294967295, 17153]], 'dma-n=
ames': ['tx0-0', 'tx0-1', 'tx0-2', 'tx0-3', 'tx1-0', 'tx1-1', 'tx1-2', 't=
x1-3', 'rx0', 'rx1'], 'ti,mii-g-rt': [[429!
>  4967295]], 'interrupts': [[24, 0, 2], [25, 1, 3]], 'interrupt-names': =
['tx_ts0', 'tx_ts1'], 'ethernet-ports': {'#address-cells': [[1]], '#size-=
cells': [[0]], 'port@0': {'reg': [[0]], 'phy-handle': [[4294967295]], 'ph=
y-mode': ['rgmii-id'], 'interrupts-extended': [[4294967295, 24]], 'ti,sys=
con-rgmii-delay': [[4294967295, 16672]], 'local-mac-address': [[0, 0, 0, =
0, 0, 0]]}, 'port@1': {'reg': [[1]], 'phy-handle': [[4294967295]], 'phy-m=
ode': ['rgmii-id'], 'interrupts-extended': [[4294967295, 25]], 'ti,syscon=
-rgmii-delay': [[4294967295, 16676]], 'local-mac-address': [[0, 0, 0, 0, =
0, 0]]}}, '$nodename': ['ethernet']}
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devic=
etree/bindings/net/ti,icssg-prueth.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings=
/net/ti,icssg-prueth.example.dtb: ethernet: Unevaluated properties are no=
t allowed ('firmware-name', 'ti,prus', 'ti,pruss-gp-mux-sel' were unexpec=
ted)
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devic=
etree/bindings/net/ti,icssg-prueth.yaml
>=20
> doc reference errors (make refcheckdocs):
>=20
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/2023=
0210114957.2667963-2-danishanwar@ti.com

Hi Rob,
This patch depends on the patch [1] which is posted through series [2]. P=
atch
[1] is currently approved, reviewed and will soon be merged to mainline L=
inux.
Once it is merged this patch won't throw the above error.

In the meantime I have posted this patch to get it reviewed so that once =
patch
[1] gets merged, this will be ready to be merged.

[1] https://lore.kernel.org/all/20230106121046.886863-2-danishanwar@ti.co=
m/
[2] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.co=
m/

>=20
> The base for the series is generally the latest rc1. A different depend=
ency
> should be noted in *this* patch.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to=

> date:
>=20
> pip3 install dtschema --upgrade
>=20
> Please check and re-submit after running the above command yourself. No=
te
> that DT_SCHEMA_FILES can be set to your schema file to speed up checkin=
g
> your schema. However, it must be unset to test all examples with your s=
chema.
>=20

--=20
Thanks and Regards,
Danish.
