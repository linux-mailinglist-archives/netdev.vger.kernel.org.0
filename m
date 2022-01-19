Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14599493E49
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 17:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356093AbiASQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 11:29:16 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17407 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiASQ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 11:29:15 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2022 11:29:15 EST
ARC-Seal: i=1; a=rsa-sha256; t=1642608814; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=aJMQk2/gRzk2u+iK/pBDsX/CH7MsfqQBpe32N6corqGj2Ow4oJmiSNkve0MntMjwytO9H61YWEO7AM0HXFzjCnE16U00F32kO72pV2dbh4r/L2xdCS1cqkm19W/AG22+qcuL98J1QaSEhqU8LS/MKETd4buDRVl3gX4rnUwjBZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1642608814; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ZI8+0hLk3hJb5h6vCsTq+HcCYv1CIJ6YfhciX13D9QQ=; 
        b=JUxSzPJ2BGARef/inhQeDHeyi0hWx0z6ZJjmiPpWbvDG28XzuCwEaI4PvSi7tLmhCpzQJgKn4ZT9ExyDko01kfkTYcwNQqNhcuZ6ROSHxjOB6mr3vHvnFg8uXNynF6+c2czQvlJZAfnibxADT0K13j5pC+Th8E3nTwxGQxtwzQ0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1642608814;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=ZI8+0hLk3hJb5h6vCsTq+HcCYv1CIJ6YfhciX13D9QQ=;
        b=VrBlmFh5W98OPqyKylPM59ijjwY/Abo0Y7ybAKmBtxLg9bUAQ0YvM4OKv+UaCo/D
        vxTVUdLz8Xq+rnqg3//yhSl2VYtZueKN3I2uzk+2cjce/jjrIh7oXkeydLvjQNFp0+q
        ETk6oBeVdoTKURi7E+cBgTYHbXptP0qA/I6J7xYQ=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1642608812121314.97149490388495; Wed, 19 Jan 2022 08:13:32 -0800 (PST)
Message-ID: <a25ebb17-e494-35ab-c1d4-a272ad02289b@arinc9.com>
Date:   Wed, 19 Jan 2022 19:13:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: MT7621 ethernet does not get probed on net-next branch after 5.15
 merge
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>, netdev <netdev@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     openwrt-devel@lists.openwrt.org
References: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is fixed with the patch series (yet to be applied upstream) in the 
link below.

https://lore.kernel.org/all/20220110114930.1406665-1-sergio.paracuellos@gmail.com/

On 15/10/2021 17:23, DENG Qingfang wrote:
> Hi,
> 
> After the merge of 5.15.y into net-next, MT7621 ethernet
> (mtk_eth_soc.c) does not get probed at all.
> 
> Kernel log before 5.15 merge:
> ...
> libphy: Fixed MDIO Bus: probed
> libphy: mdio: probed
> mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 20
> mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> ...
> 
> Kernel log after 5.15 merge:
> ...
> libphy: Fixed MDIO Bus: probed
> mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> ...
> 
> 
> I tried adding debug prints into the .mtk_probe function, but it did
> not execute.
> There are no dts changes for MT7621 between 5.14 and 5.15, so I
> believe it should be something else.
> 
> Any ideas?
> 
