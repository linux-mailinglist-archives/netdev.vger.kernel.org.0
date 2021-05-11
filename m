Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4B37AD09
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhEKRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:24:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhEKRYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 13:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ku5o60Uda8ZBIzKz23zeLhUSNmtSK2p64+IzFDQCsXE=; b=dMLtNLFZrTo+mfkJIAn6TGzGvt
        E0nX+PEqBjjPXElMrcB216WzYo5nT8Cz179AyVOlatWlbrRhCc+YpoCPJK7J9BcsjPh7TeVfUoxFW
        ZzZUAPbOy2Y1dc+hFavdGEnOo6BW+jNIEiUjDCl89UCY3tmqIeoE+thU0j2cIFDuLk4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgW5p-003nl3-SY; Tue, 11 May 2021 19:22:49 +0200
Date:   Tue, 11 May 2021 19:22:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: networking: device_drivers: fix bad usage of
 UTF-8 chars
Message-ID: <YJq9abOeuBla3Jiw@lunn.ch>
References: <cover.1620744606.git.mchehab+huawei@kernel.org>
 <95eb2a48d0ca3528780ce0dfce64359977fa8cb3.1620744606.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95eb2a48d0ca3528780ce0dfce64359977fa8cb3.1620744606.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
> +monitoring tools such as `ifstat` or `sar -n DEV [interval] [number of samples]`

...

>  For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
> -monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
> +monitoring tools such as ``ifstat`` or ``sar -n DEV [interval] [number of samples]``

Is there a difference between ` and `` ? Does it make sense to be
consistent?

	Andrew
