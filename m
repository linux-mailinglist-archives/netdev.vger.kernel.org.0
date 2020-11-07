Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A2D2AA83C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 23:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgKGWTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 17:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGWTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 17:19:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825D320719;
        Sat,  7 Nov 2020 22:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604787550;
        bh=FsaqO/xu8QA/6NoytEm5unWLYIrB+c6XJPw0FFbxeg0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b1r6xmOIM7yLnWP0aHBgcDImiyqq6PwJPJFMdGD0xQDhh2tMhM9bXe+c5LjspuC1X
         m2Cm25oCEB8IpMrfTm1rfVuiBT1264XKgyuhWbNJBiOGcYiFHDIPVfuoPeFh6A3kEf
         Fo7pN1aCrixn1x6IRGHvBMB9sqIY13svuCD6PuAY=
Date:   Sat, 7 Nov 2020 14:19:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Arnd Bergmann <arnd@kernel.org>, Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Message-ID: <20201107141909.05a4c56e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <927918413d7c2e515e61d751b2424886@dev.tdt.de>
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
        <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
        <927918413d7c2e515e61d751b2424886@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Nov 2020 06:43:53 +0100 Martin Schiller wrote:
> On 2020-11-05 16:06, Arnd Bergmann wrote:
> > ...
> > Adding Martin Schiller and Andrew Hendry, plus the linux-x25 mailing
> > list to Cc. When I last looked at the wan drivers, I think I concluded
> > that this should still be kept around, but I do not remember why.
> > OTOH if it was broken for a long time, that is a clear indication that
> > it was in fact unused.  
> 
> As Xie has already mentioned, the linux-x25 mailing list unfortunately
> is broken for a long time. Maybe David could have a look at this.
> 
> I still use the X.25 subsystem together with the hdlc-x25 driver and as
> I wrote some time ago this will continue for some time.
> 
> I'm also still contributing patches for it (even if only drop by drop).
> 
> But I have never used the x25_asy driver.
> 
> > Hopefully Martin or Andrew can provide a definite Ack or Nack on this.
> >   
> 
> ACK from my side, even if I'm a bit sorry about the work of Xie.
> 
> Acked-by: Martin Schiller <ms@dev.tdt.de>

Applied to net-next, thanks!
