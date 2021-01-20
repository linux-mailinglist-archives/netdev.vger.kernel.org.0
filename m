Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60412FD1CB
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbhATN1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 08:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731056AbhATNOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:14:36 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984D2C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:13:55 -0800 (PST)
Received: from miraculix.mork.no (fwa136.mork.no [192.168.9.136])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10KDDk88028336
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 20 Jan 2021 14:13:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611148426; bh=f7usLHEwtXaZEMJIInzm30T0cQiBe6Bp+4SEsYKM+08=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=UWrkBRtK3z+f5jmNTdWURJ3KHP6LD9UByRrcYjVD2QlNRYfTbVtkmgkJWXp1VmuPx
         9Ot3ZbZG5xeHMi5j1Or8BoxB3pI88pFwwJuMU90Q0AlOjta5Y3C08TfaWdPawdXFc+
         OGfFBNsSRDLIMgdjAkAdcN8LPTKaCAo6AzJ20Q1A=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l2DIv-002lDQ-SK; Wed, 20 Jan 2021 14:13:45 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Giacinto Cifelli <gciofono@gmail.com>
Cc:     Reinhard Speyerer <rspmn@t-online.de>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
Organization: m
References: <20210118054611.15439-1-gciofono@gmail.com>
        <20210118115250.GA1428@t-online.de> <87a6t6j6vn.fsf@miraculix.mork.no>
        <CAKSBH7HbaVxyZJRuZPv+t2uBipZAkAYTcyJwRDy-UTB_sD4SJA@mail.gmail.com>
Date:   Wed, 20 Jan 2021 14:13:45 +0100
In-Reply-To: <CAKSBH7HbaVxyZJRuZPv+t2uBipZAkAYTcyJwRDy-UTB_sD4SJA@mail.gmail.com>
        (Giacinto Cifelli's message of "Wed, 20 Jan 2021 13:36:01 +0100")
Message-ID: <87mtx3agza.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Giacinto Cifelli <gciofono@gmail.com> writes:

> Hi Bj=C3=B8rn,
> I have fixed and resent, but from your comment I might not have
> selected the right line from maintaner.pl?
> what I have is this:
> $ ./scripts/get_maintainer.pl --file drivers/net/usb/qmi_wwan.c
> "Bj=C3=B8rn Mork" <bjorn@mork.no> (maintainer:USB QMI WWAN NETWORK DRIVER)
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
> netdev@vger.kernel.org (open list:USB QMI WWAN NETWORK DRIVER)
> <<<< this seems the right one
> linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)
>
> I have at the same time sent a patch for another enumeration of the
> same product, for cdc_ether.  In that case, I have picked the
> following line, which also looked the best fit:
>   linux-usb@vger.kernel.org (open list:USB CDC ETHERNET DRIVER)
>
> Did I misinterpret the results of the script?

Yes, but I'll be the first to admit that it isn't easy.=20=20

netdev is definitely correct, and the most important one.

But in theory you are supposed to use all the listed addresses.  Except
that I don't think you need to CC David (and Jakub?) since they probably
read everything in netdev anyway.  And I believe many (most?) people
leave out the linux-kernel catch-all, since it doesn't provide any extra
coverage for networking. At least I do.

Then there's the two remaining addresses.  The linux-usb list is
traditionally CCed on patches touching USB drivers, since the USB
experts are there and not necessarily in netdev.  And I'd like a copy
because that's the only way I'll be able to catch these patches.  I
don't read any of the lists regularily.

This is my interpretation only.  I am sure there are other opinions. But
as usual, you cannot do anything wrong. The worst that can ever happen
is that you have to resend a patch or miss my review of it ;-)


Bj=C3=B8rn
