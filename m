Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7094B1DA00F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgESS4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:56:48 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41039 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbgESS4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:56:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B03825819BD;
        Tue, 19 May 2020 14:56:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 19 May 2020 14:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VGG2Ae
        Tsjh3UGlkqn7yUIMsPuz9GVk3eSFFELa/CR2U=; b=zMgLNnc4yjH2cv2GRzytm8
        hCk4oUJk5M85tS3qZ/zJqWHnJuVYw2V74d0MmpcENM8rnVm/uUeGRiyA5/NTv88W
        67TqARrcwDrjzu915ss9UtmWTQu/rPL6lHeEUymA2jHg8vx1uv+4YDxl5PO5f9Wx
        E6VqU7GqSMnsp8FsOaq5or9VK+cPcCBkGklhxy4RIQ/CQdXjuhwiSswH8IjB5tlr
        u4lYvMn2Fky23IPyvfcxFIf5vHcL1o7cZOOCaGfHDskzkUrUU+f38JquQml5hPkg
        XSX+aUzLpVMQscJee+gA+WrEiaXU4jMirKWfgVUWeC4g1SdmcbxPIFt8V2sitEuA
        ==
X-ME-Sender: <xms:7SvEXoxkIuLLWrqusHIZXI0x4uBIX6mPxk23dGzysrkZ7Mv03KypEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtjedgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdethedutdevgfefvedtffeufeeghfeuleeftddvffduudetgfejleejhfeu
    veeinecuffhomhgrihhnpehmvghllhgrnhhogidrtghomhdpghhithhhuhgsrdgtohhmne
    cukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7SvEXsSzAJBv2PnHacQfS7MNoUzA4mG3KWE6H40LbGak2vATj3436g>
    <xmx:7SvEXqX63pla3OlKi1bAggtKzt4e-7SFSpmeyTx1XcZPh4bwqndbHA>
    <xmx:7SvEXmhiIERlIKXSfpPDkCMiIodVw13NA49oDrHThkP7bYQ6lZtIZw>
    <xmx:7ivEXrJFOJ-24_px1KkViXfZo0oMkS0l_-nq5-xLRfhC4Uqqffe6fA>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D011D306643D;
        Tue, 19 May 2020 14:56:44 -0400 (EDT)
Date:   Tue, 19 May 2020 21:56:42 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: net: Add port split test
Message-ID: <20200519185642.GA1016583@splinter>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-4-idosch@idosch.org>
 <20200519141541.GJ624248@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519141541.GJ624248@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 04:15:41PM +0200, Andrew Lunn wrote:
> > +# Test port split configuration using devlink-port width attribute.
> > +# The test is skipped in case the attribute is not available.
> > +#
> > +# First, check that all the ports with a width of 1 fail to split.
> > +# Second, check that all the ports with a width larger than 1 can be split
> > +# to all valid configurations (e.g., split to 2, split to 4 etc.)
> 
> Hi Ido

Hi Andrew,

> 
> I know very little about splitting ports. So these might be dumb
> questions.
> 
> Is there a well defined meaning of width? Is it something which can be
> found in an 802.3 standard?

It's basically the number of lanes: If a port is a 100Gbps port and has
a width of 4, then every lane is running at 25Gbps. Splitting this port
to 4 (via 'devlink port split') allows you to get 4 ports each capable
of supporting speeds up to 25Gbps (the original netdev disappears).

Example splitter cable:
https://www.mellanox.com/related-docs/prod_cables/PB_MCP7F00-A0xxRyyz_100GbE_QSFP28_to_4x25GbE_4xSFP28_DAC_Splitter.pdf

Some documentation from mlxsw Wiki:
https://github.com/Mellanox/mlxsw/wiki/Switch-Port-Configuration#port-splitting

> Is it well defined that all splits of the for 2, 4, 8 have to be
> supported?

That I don't actually know. It is true for Mellanox and I can only
assume it holds for other vendors. So far beside mlxsw only nfp
implemented port_split() callback. I see it has this check:

```
        if (eth_port.is_split || eth_port.port_lanes % count) {
                ret = -EINVAL;
                goto out;
        }
```

So it seems to be consistent with mlxsw. Jakub will hopefully chime in
and keep me honest.

> Must all 40Gbps ports with a width of 4, be splitable to 2x
> 20Mps? It seems like some hardware might only allow 4x 10G?

Possible. There are many vendor-specific quirks in this area, as I'm
sure you know :)

> 
> If 20Gbps is supported, can you then go recursive and split one of the
> 20G ports into 2x 10G, leaving the other as a 20G port?

Quite certain this is not supported by any vendor.

I assume you're asking because you are trying to see if the test is not
making some vendor-specific assumptions? Personally, I think it's not.
We decided to put it under net/ rather than drivers/net/mlxsw because we
always prefer to write tests that can be shared with others. This is
what actually motivated this work. We had a very Mellanox-specific test
in our regression and we wanted to remove it, but it was not possible to
write such a test without this attribute.
