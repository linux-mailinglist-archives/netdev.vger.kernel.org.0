Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6815A280C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245438AbiHZMwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiHZMwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:52:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78D493530
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 05:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=glyaqKMvH0eXV1qi5nMxFFZvW283txFKe//XNOv5kJw=; b=SB
        7LrUr1OZ9JXWW41YzBNb7q7l3NdQ+ziNPLW9oXUL0C6oUBhhbE/szP9xE20ugRZAePidtcEcdb40u
        x881GYpCaY5HXYNmRHF/UPCBpXUTHlzNRfqQdZgOWlRn/sbnRW2JgNZdS1YbDCNCt8FfpeL6ghpn0
        vFHz28arBwsBITs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRYod-00EgNV-2u; Fri, 26 Aug 2022 14:52:03 +0200
Date:   Fri, 26 Aug 2022 14:52:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and
 802.3
Message-ID: <YwjB84tvHAPymRRn@lunn.ch>
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
 <YwegaWH6yL2RHW+6@lunn.ch>
 <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 08:58:31AM +0200, Íñigo Huguet wrote:
> On Thu, Aug 25, 2022 at 6:17 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Aug 25, 2022 at 11:02:39AM +0200, Íñigo Huguet wrote:
> > > Most recent cards (8000 series and newer) had enough hardware support
> > > for this, but it was not enabled in the driver. The transmission of PTP
> > > packets over these protocols was already added in commit bd4a2697e5e2
> > > ("sfc: use hardware tx timestamps for more than PTP"), but receiving
> > > them was already unsupported so synchronization didn't happen.
> >
> > You don't appear to Cc: the PTP maintainer.
> >
> >     Andrew
> >
> 
> I didn't think about that, but looking at MAINTAINERS, there doesn't
> seem to be any. There are 2 maintainers for the drivers of the clock
> devices, but none for anything related to the network protocol...

PTP HARDWARE CLOCK SUPPORT
M:      Richard Cochran <richardcochran@gmail.com>
L:      netdev@vger.kernel.org
S:      Maintained
W:      http://linuxptp.sourceforge.net/
F:      Documentation/ABI/testing/sysfs-ptp
F:      Documentation/driver-api/ptp.rst
F:      drivers/net/phy/dp83640*
F:      drivers/ptp/*
F:      include/linux/ptp_cl*

I assume you are using linuxptp with this?

  Andrew
