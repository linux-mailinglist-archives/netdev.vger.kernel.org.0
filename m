Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B3211921C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfLJUd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:33:58 -0500
Received: from mail.nic.cz ([217.31.204.67]:51412 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLJUdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 15:33:54 -0500
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 5429F140AC8;
        Tue, 10 Dec 2019 21:33:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1576010032; bh=gT9/qt/EE7APHbwGwmFdoeHh/5ij9tU8+0uQXcYhjVI=;
        h=Date:From:To;
        b=sThtOEeX+qYfIcojZT7f2Vbh9MTdECtF/Ctl0YngNsUBcL6Y7s6S5lCAiP0kfmx/v
         KAyG5LPOqa6UrjRlit08uN0nTJHjzOo98m/IKDFtXdVfk1tYHqKKb1DttwKCg+MKk+
         ufKzsCzDzfO82MDF5WYpvs/zZSe04O4Ms945Lx40=
Date:   Tue, 10 Dec 2019 21:33:51 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Landen Chao <landen.chao@mediatek.com>, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of
 MT7531 switch
Message-ID: <20191210213351.2df6acbf@nic.cz>
In-Reply-To: <20191210163557.GC27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
        <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
        <20191210163557.GC27714@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 17:35:57 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Tue, Dec 10, 2019 at 04:14:40PM +0800, Landen Chao wrote:
> > Add new support for MT7531:
> > 
> > MT7531 is the next generation of MT7530. It is also a 7-ports switch with
> > 5 giga embedded phys, 2 cpu ports, and the same MAC logic of MT7530. Cpu
> > port 6 only supports HSGMII interface. Cpu port 5 supports either RGMII
> > or HSGMII in different HW sku.  
> 
> Hi Landen
> 
> Looking at the code, you seem to treat HSGMII as 2500Base-X. Is this
> correct? Or is it SGMII over clocked to 2.5Gbps?
> 
> 	 Andrew

How would that work? Would 10 and 100 be overclocked to 25 and 250?
