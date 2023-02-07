Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56068CE70
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBGFBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBGFBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:01:20 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522E817CCF;
        Mon,  6 Feb 2023 21:01:19 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31750knq018167;
        Mon, 6 Feb 2023 23:00:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675746046;
        bh=Hs3YoZCw4wOnroWydtnxjTMJ2o3lP1oFgOFPpB2f6dI=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=t4DnMBTtcQBUAXgbtM2w01I+iIro9rVB8AOZvgLj4tnjc/mR16nPLwuk3pY0HXGga
         s86um/jew7wG5WYqPy4tLn0gbblIZJObw+1pL+dXCc88vjhpYghroRYOBXH1x3czGB
         TFYAUDhEJR5MPwakp38bS9cRcpv0xFRnG0g5mG0c=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31750kkR012222
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Feb 2023 23:00:46 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Feb 2023 23:00:46 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Feb 2023 23:00:46 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 31750eK9018304;
        Mon, 6 Feb 2023 23:00:40 -0600
Message-ID: <229578d8-0ba6-1c24-c3d3-0085cf889aa3@ti.com>
Date:   Tue, 7 Feb 2023 10:30:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [EXTERNAL] Re: [PATCH v4 1/2] dt-bindings: net: Add ICSSG
 Ethernet Driver bindings
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, MD Danish Anwar <danishanwar@ti.com>
CC:     <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <ssantosh@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "Andrew F. Davis" <afd@ti.com>, <andrew@lunn.ch>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Suman Anna <s-anna@ti.com>, <srk@ti.com>,
        "David S. Miller" <davem@davemloft.net>, <nm@ti.com>,
        <netdev@vger.kernel.org>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-2-danishanwar@ti.com>
 <167569095956.1485300.151990392599002247.robh@kernel.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <167569095956.1485300.151990392599002247.robh@kernel.org>
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

Hi Rob,

On 06/02/23 19:16, Rob Herring wrote:
>=20
> On Mon, 06 Feb 2023 11:37:07 +0530, MD Danish Anwar wrote:
>> From: Puranjay Mohan <p-mohan@ti.com>
>>
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet driver. This driver uses the PRU and PRUSS consumer API=
s
>> to interface the PRUs and load/run the firmware for supporting etherne=
t
>> functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 179 +++++++++++++++++=
+
>>  1 file changed, 179 insertions(+)
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

This error is coming because this series depends on series [1]. The
ti,pru-consumer.yaml is upstreamed through series [1]. The series is appr=
oved
and will hopefully be merged soon.

[1] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.co=
m/

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
0206060708.3574472-2-danishanwar@ti.com
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
