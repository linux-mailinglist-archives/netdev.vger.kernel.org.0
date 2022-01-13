Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4195A48DCEA
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiAMR1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:27:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45498 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiAMR1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:27:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB6DB822D6;
        Thu, 13 Jan 2022 17:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A2FC36AEB;
        Thu, 13 Jan 2022 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642094865;
        bh=Xm0k0hBuHh7dvJeIyDxX/w+rbC6J3wxBnImdzwoZAeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C15N4mFkPjl6hjxZ4AQ1Yf4A7Q+eKCVpxdtCm6XK9kh1oxa+6s459b66i+dsKdAX9
         /yOKQg17ZL97nj4wpNW8dAMSWjhTf5YTFWuF/cNlC24i8JaDPObcjbUS9oVYX+46XX
         YVRHAR+e1qbQq4aVliKJPcrMOTyhZ2209OlSZau9jm5ck8VKdAp4mtKYHdMQ9Z5Z+o
         P9OfV6UMzuMhso1p2ctq6XcRUNF7rqco7kTMS2kYouX+D4ODm2qgMIFPIVyv+wyOdI
         H32Ntos7dVv3caduRH2ONXdjVhSgZ5yQBPJgsJ/PvEmYOEme3OZAAqXlOMqp0Q6T2a
         hCX4NAf60l5SA==
Date:   Thu, 13 Jan 2022 09:27:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Joseph CHAMG <josright123@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Leon Romanovsky <leon@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v11, 2/2] net: Add dm9051 driver
Message-ID: <20220113092743.00c25fdc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAHp75VeRx8X+5i7SG4KMKADAUj=tkbjfmFDwup5dQ64SLq4yvw@mail.gmail.com>
References: <20220113074614.407-1-josright123@gmail.com>
        <20220113074614.407-3-josright123@gmail.com>
        <CAHp75VeRx8X+5i7SG4KMKADAUj=tkbjfmFDwup5dQ64SLq4yvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 12:16:38 +0200 Andy Shevchenko wrote:
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: andy Shevchenko <andy.shevchenko@gmail.com>  
> 
> Instead, utilize --cc parameter to `git send-email ...`

.. or put them under the --- so git cuts them off when patch is applied.
