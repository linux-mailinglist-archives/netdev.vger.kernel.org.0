Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595949BF18
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 19:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfHXR6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 13:58:15 -0400
Received: from mail.nic.cz ([217.31.204.67]:41592 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbfHXR6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 13:58:15 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 00C15140BDC;
        Sat, 24 Aug 2019 19:58:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566669494; bh=2p0CPHOejSu6fQOALJB/rhrZz4VqsDnMlZoFZs/SYgs=;
        h=Date:From:To;
        b=ucohJOfcOBAsTM3/LmHSp13TKThPxbxNV3nXR2fpD2Eo/Y++stl8XH3/Mi2s2AqMa
         fVDKWaeIPT0/hv98hbnPv0nwb4cWf3vjrvfWdov5vrJS8bxc3j7TrGF8wSz76NQ1Ra
         ENaBVmnacBiKuC/5wTXjbUtL93OOc3LUHn7atJns=
Date:   Sat, 24 Aug 2019 19:58:13 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824195813.43349620@nic.cz>
In-Reply-To: <20190824155636.GD8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
        <20190824155636.GD8251@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 17:56:36 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> I expect bad things will happen if frames are flooded to multiple CPU
> ports. For this to work, the whole switch design needs to support
> multiple CPU ports. I doubt this will work on any old switch.
> 
> Having a host interface connected to a user port of the switch is a
> completely different uses case, and not what this patchset is about.

In the next proposal I shall also add a guard to all DSA drivers, that
if more than one CPU port is set, the driver will not probe.

After that the next patch will try to add multi-CPU support to
mv88e6xxx (while removeing the guard for that driver).

qca8k should also be possible to do, since we used it in such a way in
openwrt. I shall look into that afterwards.

Marek
