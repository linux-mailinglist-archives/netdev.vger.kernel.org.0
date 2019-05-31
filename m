Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC234317EE
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEaX2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:28:49 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:29887 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfEaX2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:28:48 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VNSkS5006286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 17:28:46 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VNSk2h012981
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 31 May 2019 17:28:46 -0600
Subject: Re: [PATCH net-next 01/13] net: axienet: Fixed 64-bit compile, enable
 build on X86 and ARM
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
 <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
 <20190531211043.GD3154@lunn.ch>
From:   Robert Hancock <hancock@sedsystems.ca>
Openpgp: preference=signencrypt
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 mQINBFfazlkBEADG7wwkexPSLcsG1Rr+tRaqlrITNQiwdXTZG0elskoQeqS0FyOR4BrKTU8c
 FAX1R512lhHgEZHV02l0uIWRTFBshg/8EK4qwQiS2L7Bp84H1g5c/I8fsT7c5UKBBXgZ0jAL
 ls4MJiSTubo4dSG+QcjFzNDj6pTqzschZeDZvmCWyC6O1mQ+ySrGj+Fty5dE7YXpHEtrOVkq
 Y0v3jRm51+7Sufhp7x0rLF7X/OFWcGhPzru3oWxPa4B1QmAWvEMGJRTxdSw4WvUbftJDiz2E
 VV+1ACsG23c4vlER1muLhvEmx7z3s82lXRaVkEyTXKb8X45tf0NUA9sypDhJ3XU2wmri+4JS
 JiGVGHCvrPYjjEajlhTAF2yLkWhlxCInLRVgxKBQfTV6WtBuKV/Fxua5DMuS7qUTchz7grJH
 PQmyylLs44YMH21cG6aujI2FwI90lMdZ6fPYZaaL4X8ZTbY9x53zoMTxS/uI3fUoE0aDW5hU
 vfzzgSB+JloaRhVtQNTG4BjzNEz9zK6lmrV4o9NdYLSlGScs4AtiKBxQMjIHntArHlArExNr
 so3c8er4mixubxrIg252dskjtPLNO1/QmdNTvhpGugoE6J4+pVo+fdvu7vwQGMBSwQapzieT
 mVxuyGKiWOA6hllr5mheej8D1tWzEfsFMkZR2ElkhwlRcEX0ewARAQABtCZSb2JlcnQgSGFu
 Y29jayA8aGFuY29ja0BzZWRzeXN0ZW1zLmNhPokCNwQTAQIAIQIbAwIeAQIXgAUCV9rOwQUL
 CQgHAwUVCgkICwUWAgMBAAAKCRCAQSxR8cmd98VTEADFuaeLonfIJiSBY4JQmicwe+O83FSm
 s72W0tE7k3xIFd7M6NphdbqbPSjXEX6mMjRwzBplTeBvFKu2OJWFOWCETSuQbbnpZwXFAxNJ
 wTKdoUdNY2fvX33iBRGnMBwKEGl+jEgs1kxSwpaU4HwIwso/2BxgwkF2SQixeifKxyyJ0qMq
 O+YRtPLtqIjS89cJ7z+0AprpnKeJulWik5hNTHd41mcCr+HI60SFSPWFRn0YXrngx+O1VF0Z
 gUToZVFv5goRG8y2wB3mzduXOoTGM54Z8z+xdO9ir44btMsW7Wk+EyCxzrAF0kv68T7HLWWz
 4M+Q75OCzSuf5R6Ijj7loeI4Gy1jNx0AFcSd37toIzTW8bBj+3g9YMN9SIOTKcb6FGExuI1g
 PgBgHxUEsjUL1z8bnTIz+qjYwejHbcndwzZpot0XxCOo4Ljz/LS5CMPYuHB3rVZ672qUV2Kd
 MwGtGgjwpM4+K8/6LgCe/vIA3b203QGCK4kFFpCFTUPGOBLXWbJ14AfkxT24SAeo21BiR8Ad
 SmXdnwc0/C2sEiGOAmMkFilpEgm+eAoOGvyGs+NRkSs1B2KqYdGgbrq+tZbjxdj82zvozWqT
 aajT/d59yeC4Fm3YNf0qeqcA1cJSuKV34qMkLNMQn3OlMCG7Jq/feuFLrWmJIh+G7GZOmG4L
 bahC07kCDQRX2s5ZARAAvXYOsI4sCJrreit3wRhSoC/AIm/hNmQMr+zcsHpR9BEmgmA9FxjR
 357WFjYkX6mM+FS4Y2+D+t8PC1HiUXPnvS5FL/WHpXgpn8O8MQYFWd0gWV7xefPv5cC3oHS8
 Q94r7esRt7iUGzMi/NqHXStBwLDdzY2+DOX2jJpqW+xvo9Kw3WdYHTwxTWWvB5earh2I0JCY
 LU3JLoMr/h42TYRPdHzhVZwRmGeKIcbOwc6fE1UuEjq+AF1316mhRs+boSRog140RgHIXRCK
 +LLyPv+jzpm11IC5LvwjT5o71axkDpaRM/MRiXHEfG6OTooQFX4PXleSy7ZpBmZ4ekyQ17P+
 /CV64wM+IKuVgnbgrYXBB9H3+0etghth/CNf1QRTukPtY56g2BHudDSxfxeoRtuyBUgtT4gq
 haF1KObvnliy65PVG88EMKlC5TJ2bYdh8n49YxkIk1miQ4gfA8WgOoHjBLGT5lxz+7+MOiF5
 4g03e0so8tkoJgHFe1DGCayFf8xrFVSPzaxk6CY9f2CuxsZokc7CDAvZrfOqQt8Z4SofSC8z
 KnJ1I1hBnlcoHDKMi3KabDBi1dHzKm9ifNBkGNP8ux5yAjL/Z6C1yJ+Q28hNiAddX7dArOKd
 h1L4/QwjER2g3muK6IKfoP7PRjL5S9dbH0q+sbzOJvUQq0HO6apmu78AEQEAAYkCHwQYAQIA
 CQUCV9rOWQIbDAAKCRCAQSxR8cmd90K9D/4tV1ChjDXWT9XRTqvfNauz7KfsmOFpyN5LtyLH
 JqtiJeBfIDALF8Wz/xCyJRmYFegRLT6DB6j4BUwAUSTFAqYN+ohFEg8+BdUZbe2LCpV//iym
 cQW29De9wWpzPyQvM9iEvCG4tc/pnRubk7cal/f3T3oH2RTrpwDdpdi4QACWxqsVeEnd02hf
 ji6tKFBWVU4k5TQ9I0OFzrkEegQFUE91aY/5AVk5yV8xECzUdjvij2HKdcARbaFfhziwpvL6
 uy1RdP+LGeq+lUbkMdQXVf0QArnlHkLVK+j1wPYyjWfk9YGLuznvw8VqHhjA7G7rrgOtAmTS
 h5V9JDZ9nRbLcak7cndceDAFHwWiwGy9s40cW1DgTWJdxUGAMlHT0/HLGVWmmDCqJFPmJepU
 brjY1ozW5o1NzTvT7mlVtSyct+2h3hfHH6rhEMcSEm9fhe/+g4GBeHwwlpMtdXLNgKARZmZF
 W3s/L229E/ooP/4TtgAS6eeA/HU1U9DidN5SlON3E/TTJ0YKnKm3CNddQLYm6gUXMagytE+O
 oUTM4rxZQ3xuR595XxhIBUW/YzP/yQsL7+67nTDiHq+toRl20ATEtOZQzYLG0/I9TbodwVCu
 Tf86Ob96JU8nptd2WMUtzV+L+zKnd/MIeaDzISB1xr1TlKjMAc6dj2WvBfHDkqL9tpwGvQ==
Organization: SED Systems
Message-ID: <94beef09-4ec9-194b-b8ed-47032c586b50@sedsystems.ca>
Date:   Fri, 31 May 2019 17:28:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531211043.GD3154@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-31 3:10 p.m., Andrew Lunn wrote:
>>  static inline u32 axienet_ior(struct axienet_local *lp, off_t offset)
>>  {
>> -	return in_be32(lp->regs + offset);
>> +#ifdef CONFIG_MICROBLAZE
>> +	return __raw_readl(lp->regs + offset);
>> +#else
>> +	return ioread32(lp->regs + offset);
>> +#endif
>>  }
> 
> Please dig deeper into the available accessor functions. There should
> be a set which works without this #defery. 

This driver previously only compiled on MicroBlaze, and on that
platform, in_be32 is mapped to __raw_readl which reads with no byte
swapping. The confusing this is that MicroBlaze can apparently be set up
as either LE or BE, so I'm guessing that the hardware setup just
arranges that the reads are natively in the right byte order depending
on the mode. If I were to just use ioread32, there would be no change on
LE Microblaze, but BE Microblaze would start byte-swapping, which I
assume would break things.

The Xilinx version of this driver also supports Zynq (arm) and ZynqMP
(aarch64) platforms, and for those platforms it defines in_be32 to
__raw_readl as well. Since those are little-endian that ends up being
the same byte order as ioread32.

Finally, the setup we're using this hardware with on ARM over a PCIe to
AXI bridge exposes the device with the same byte order as any other PCIe
device, so the regular ioread32 accessors are correct.

I'm not quite sure what to make of that.. most platforms either would
need or work fine with the "regular" accessors, but I'm not sure that
wouldn't break big-endian MicroBlaze. It would be useful if one of the
Xilinx people could confirm that..

-- 
Robert Hancock
Senior Software Developer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
