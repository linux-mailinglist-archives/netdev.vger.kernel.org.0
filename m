Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703F31A89EE
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504210AbgDNSmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504162AbgDNSmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 14:42:01 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208EF2082E;
        Tue, 14 Apr 2020 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586889720;
        bh=92ouK1EZtTn+HmugH5BHACzd3FyOicJdIGabmG3nexM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X/xW7zelTwm+eLJXOa5oraSC7xyJEyB8ZvW05z0FCYozMYFK2a4FqfiL8E+EJkMkB
         tzcNKGEEUSG1tLaWK/VzGQ5Y/HiIgdk5/KCQRXyrNMe5mGfMX3siaXj3EZx3IpvQG7
         qsUSEbcxeZQZQWaxbwHU10WBAXPtIii+L+vJqouE=
Date:   Tue, 14 Apr 2020 21:41:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] kernel/module: Hide vermagic header file
 from general use
Message-ID: <20200414184155.GB1239315@unreal>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-5-leon@kernel.org>
 <20200414160349.GH31763@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200414160349.GH31763@zn.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 06:03:50PM +0200, Borislav Petkov wrote:
> On Tue, Apr 14, 2020 at 06:57:32PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > VERMAGIC* definitions are not supposed to be used by the drivers,
>
> Yeah, this was only me conjecturing here. But yes, if people agree, this
> would be one way to do it.
>
> In any case and FWIW, series looks ok to me:
>
> Acked-by: Borislav Petkov <bp@suse.de>

Thanks, finally kbuild slap me to the face.
There is a need to change scripts/mod/modpost.c too and find the reason
why I didn't get any compilation errors.

<...>
>> drivers/gpio/gpio-aspeed.mod.c:3:10: fatal error: linux/vermagic.h: No such file or directory
       3 | #include <linux/vermagic.h>
         |          ^~~~~~~~~~~~~~~~~~
   compilation terminated.

<...>


>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
