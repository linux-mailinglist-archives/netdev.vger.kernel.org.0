Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E6F2C84B7
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgK3NKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:10:43 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:22454 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgK3NKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:10:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606741841; x=1638277841;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yU4RBZDIdf9/SfV6ulpzlpSrR2PxxdPt8Zp4NcqDETM=;
  b=D75/is2V0072hcD2QOL5WrJz9opZw3RXuvbK9VHAO+pUuixCs3/TdnrQ
   DG3c7tGT8+2GGxBFqsJRt/GqkS+32TKOC2sVWbGz4adxUSmqwcfgYtori
   PUJzt3flT07GtxkZB+bxyzkpYQNDctPwkF5eUrnjxR0MlAIauJyY8jTYr
   zaVmal2W0k9mueO9KGME7gWOOipCC2XuQOW8sIxKyKCKSjSy6Kklj6wyU
   JfDgEcKRE5dv1vndxGHNdYiiXbDTrnnTIYLpMD1a4EDZB4qHz0TK+X8Tq
   n2GgSTw/iFWWWP2MjS5NMH3ZQVi9nbkDKvD+6DFU9XRIWRUBMBk7Rkeld
   g==;
IronPort-SDR: 42TuJ3Tf4hd0dymHoAyHq7FSgqRqW2hoHbfuWJbrPNxfmFF2j15hS2JjJDRQG1AEQyC8/1KV4d
 UQGdpKsk9G0lxAmFnDnUen+lR2mxttxPV4GNz8mQGJLMRGVXEOAUQcofxdDVLGXH3t/UOJT8aG
 ETmxD5nuWbaGIc3Jd3O6PrmtJHK8WTgoqBelH1kNYmFFR9iD7QPnKGGosii1DdQ3rxe0UQeu5b
 0FKqRJm0NX08SUpKn0MvfOHfwcAcNsnkoGmkNu3ThfIHMkm5wu9o+ax9hwMSOEha4VGzhBgr9O
 GOQ=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="100787599"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 06:09:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 06:09:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 06:09:35 -0700
Date:   Mon, 30 Nov 2020 14:09:34 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/3] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
Message-ID: <20201130130934.o47mdjiqidtznm2t@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-2-steen.hegelund@microchip.com>
 <20201127170052.GV2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201127170052.GV2073444@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.11.2020 18:00, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +  reg-names:
>> +    minItems: 153
>> +    items:
>> +      - const: dev2g5_0
>> +      - const: dev5g_0
>> +      - const: pcs5g_br_0
>> +      - const: dev2g5_1
>> +      - const: dev5g_1
>...
>> +      - const: ana_ac
>> +      - const: vop
>
>> +    switch: switch@600000000 {
>> +      compatible = "microchip,sparx5-switch";
>> +      reg = <0x10004000 0x4000>, /* dev2g5_0 */
>> +        <0x10008000 0x4000>, /* dev5g_0 */
>> +        <0x1000c000 0x4000>, /* pcs5g_br_0 */
>> +        <0x10010000 0x4000>, /* dev2g5_1 */
>> +        <0x10014000 0x4000>, /* dev5g_1 */
>
>...
>
>> +        <0x11800000 0x100000>, /* ana_l2 */
>> +        <0x11900000 0x100000>, /* ana_ac */
>> +        <0x11a00000 0x100000>; /* vop */
>
>This is a pretty unusual binding.
>
>Why is it not
>
>reg = <0x10004000 0x1af8000>
>
>and the driver can then break up the memory into its sub ranges?
>
>    Andrew
Hi Andrew,

Since the targets used by the driver is not always in the natural
address order (e.g. the dev2g5_x targets), I thought it best to let the DT
take care of this since this cannot be probed.  I am aware that this causes
extra mappings compared to the one-range strategy, but this layout seems more
transparent to me, also when mapped over PCIe.


BR
Steen


---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
