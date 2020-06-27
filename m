Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6B520C3AF
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgF0TQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 15:16:54 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49563 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgF0TQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 15:16:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 695425C00CC;
        Sat, 27 Jun 2020 15:16:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 27 Jun 2020 15:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yXNiVh
        qsQ/fzcWT9XSpHQ+6rXxbMmaqWnOdaBooLSOM=; b=o7pIrT+A8ZwJJCDqdyouqi
        TvM8dnSfMBQEUdujjjJF83k5dlryiwAPMsOo1DqnbhWxwYirMGZOYefpK3OX/DVB
        Y+/iIJgKQy7uzxzdQaXJ3aKebgbCjhfq4oDuqAtGLiu9Oov8wW8/sSjYkbxrwE4y
        GKPGcGfdGejg6/Z978YbZ7V7cimDebP3tWldKYhzRDirWKWAk96Gz+dhLF0VNVZa
        /AuUscSbh+/cOyWaGiM/VazP81vujGDlPDHhD4PTGd0hIguMXiHE73wIeMnkDIAR
        EHqdApp5S67MNRl+Cr0XJnYkRr8HaEhnZjoWj3KIYPEm0JKh8kt8qLCTvNTFbtCg
        ==
X-ME-Sender: <xms:I5v3XlvUCf8fVntRQP5iqKpkcRiRMukey0Ooe8JC-j1q3FPwzlZxRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelfedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:I5v3XudI02FANst0Wa_dbMJ8lwS30814zCxVVywIGmOjs-zHXocpPQ>
    <xmx:I5v3Xozsyfi8prTsidHO-kTj1NTlDC_u-9Wxl-FBcpnJex2eNZcjag>
    <xmx:I5v3XsPrchbVJGAMA04TZ5cNUjLLaaF1aale8EHPloJcQt3i-xWiaA>
    <xmx:JJv3XhZ2euVStM7H74qEfP6IeC--LIvSPshEVvTQG7h6By3Z3Pbn2Q>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E47C328005D;
        Sat, 27 Jun 2020 15:16:51 -0400 (EDT)
Date:   Sat, 27 Jun 2020 22:16:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200627191648.GA245256@shredder>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
 <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 11:13:42PM +0100, Adrian Pop wrote:
> > You are saying pages 00h, 01h and 02h are mandatory for QSPF-DD.  Page
> > 03h is optional, but when present, it seems to contain what is page
> > 02h above. Since the QSPF KAPI has it, QSPF-DD KAPI should also have
> > it. So i would suggest that pages 10h and 11h come after that.
> >
> > If a driver wants to pass a subset, it can, but it must always trim
> > from the right, it cannot remove pages from the middle.
> >
> >      Andrew
> 
> I agree with this. Basically there are two big cases:
> - passive copper transceivers with flat memory => just 00h will be
> present (both lower and higher => 256 bytes)
> - optical transceivers with paged memory => 00h, 01h, 02h, 10h, 11h => 768 bytes
> Having page 03h after 02h (so 896 bytes in total) seems like a good
> idea and the updates I'll have to do to my old patch are minor
> (updating the offset value of page 10h and 11h). When I tested my
> patch, I did it with both passive copper transceivers and optical
> transceivers and there weren't any issues.

Hi Adrian, Andrew,

Not sure I understand... You want the kernel to always pass page 03h to
user space (potentially zeroed)? Page 03h is not mandatory according to
the standard and page 01h contains information if page 03h is present or
not. So user space has the information it needs to determine if after
page 02h we have page 03h or page 10h. Why always pass page 03h then?

> 
> In this patch, Ido added a comment in the code stating "Upper pages
> 10h and 11h are currently not supported by the driver.". This won't
> actually be a problem! In CMIS Rev. 4, Table 8-12 Byte 85 (55h), we
> learn that if the value of that byte is 01h or 02h, we have a SMF or
> MMF interface (both optical). In the qsfp_dd_show_sig_optical_pwr
> function (in my patch) there is this bit:
> 
> + __u8 module_type = id[QSFP_DD_MODULE_TYPE_OFFSET];
> [...]
> + /**
> + * The thresholds and the high/low alarms/warnings are available
> + * only if an optical interface (MMF/SMF) is present (if this is
> + * the case, it means that 5 pages are available).
> + */
> + if (module_type != QSFP_DD_MT_MMF &&
> +    module_type != QSFP_DD_MT_SMF &&
> +    eeprom_len != QSFP_DD_EEPROM_5PAG)
> + return;
> 
> But Ido sets the eeprom_len to be ETH_MODULE_SFF_8472_LEN which is
> 512, while QSFP_DD_EEPROM_5PAG is defined as 80h * 6 = 768. So there
> won't be any issues of accessing non-existent values, since I return
> from the function that deals with the pages 10h and 11h early. When
> the driver will support them too everything will just work so your
> idea of a driver being able to pass only a subset of pages (being
> allowed to trim only from the right) holds.

BTW, Adrian, this is the output I get with your patch on top of current
ethtool:

$ ethtool -m swp1
        Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
        Power class                               : 1
        Max power                                 : 0.25W
        Connector                                 : 0x23 (No separable connector)
        Cable assembly length                     : 0.50km
        Tx CDR bypass control                     : Yes
        Rx CDR bypass control                     : No
        Tx CDR                                    : No
        Rx CDR                                    : No
        Transmitter technology                    : 0x0a (Copper cable, unequalized)
        Attenuation at 5GHz                       : 4db
        Attenuation at 7GHz                       : 5db
        Attenuation at 12.9GHz                    : 7db
        Attenuation at 25.8GHz                    : 21db
        Module temperature                        : 0.00 degrees C / 32.00 degrees F
        Module voltage                            : 0.0000 V
        Length (SMF)                              : 0.00km
        Length (OM5)                              : 0m
        Length (OM4)                              : 0m
        Length (OM3 50/125um)                     : 0m
        Length (OM2 50/125um)                     : 17m
        Vendor name                               : Mellanox
        Vendor OUI                                : 00:02:c9
        Vendor PN                                 : MCP1660-W00AE30
        Vendor rev                                : A2
        Vendor SN                                 : MT2019VS04757
        Date code                                 : 200507  _
        Revision compliance                       : Rev. 3.0
