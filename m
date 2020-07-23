Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9A622A678
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGWEYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 00:24:42 -0400
Received: from mail.intenta.de ([178.249.25.132]:42578 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgGWEYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 00:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=v1bVdfWnKv2eed55O0NUDMlXj8ZOjB9IMpuGlZyCe30=;
        b=FXJwIBdK8F8bZ4IJdJwZ5CVUN5q1FdU/J+l3qDlMn7yp63uPrjWhs/yAPZqC8bSOK5bg2IXg1syOCoTLrKL/eEGBZjq40C+9i8Xx+MBAiKNeJJQrBg6gF0Smqkl3ExjtLhXah7NHtGgMGsYBod4krQmOX6tWm/YORsFRF/u3gu9NiQ9FZioJUs/YN4cgFutVSV501KT8Ufk2BJPjCyZOdb3+kOzlKRDvkh5unqP+W1X/nAww9lIVoBtXw2lIglrCitQUNrW0O7gFQhysGtpYeFqusaJ5XvL9U4C54bbzMSAI49Ng0QbG+x3uNNLyPokXEtNxyPXUYxWReTm/gKR2Qw==;
Date:   Thu, 23 Jul 2020 06:24:31 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] net: dsa: microchip: delete dead code
Message-ID: <20200723042431.GA14746@laureti-dev>
References: <20200721083300.GA12970@laureti-dev>
 <20200722143953.GA1339445@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200722143953.GA1339445@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Jul 22, 2020 at 04:39:53PM +0200, Andrew Lunn wrote:
> This patch probably is correct. But it is not obviously correct,
> because there are so many changes at once. Please could you break it
> up.

From my pov, it is less a question of whether it is correct, but whether
it goes into the desired direction. There are a few comments in the
driver that point to pending work. It might as well be that I'm removing
the infrastructure that other patches are meant to build upon.

I guess only the microchip people can answer this and in the event of
silence, the best course of action likely is to proceed. Maybe give it
some time? It's summer holdiday time in northern hemisphere.

> So at minimum, break it up into 3 patches, one per structure.  I would
> even go further.
> 
> Small patches are easier to review. And if something does break, a git
> bisect gives you more information about what change broke it.

Yes, sure. But this was deliberately RFC and I deliberately merged all
the removals to give you a quick idea of the dead code size. I didn't
expect this to be applied as is but rather generate a reply regarding
the purpose of the code that I propose to remove (in smaller steps).

Helmut
