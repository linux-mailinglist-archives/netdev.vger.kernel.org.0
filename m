Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9754313740E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAJQsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:48:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgAJQsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 11:48:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Vy2KD8u+BGYIDw6PxzqkmDZBzhBcbSdW6vHaku/QLXo=; b=tWvXfsZN4O/tRDQojzB7SxLRGm
        8JNn9xER9FyEqAU9aPyHgoaicpty03M2kCX2DvuDWf1l7p6xHn3uiucytfotEg8xzjU7rbGaJcNgF
        ikFk5W6F8zOay5rIyUa+4zl+T4PsDrwZ+ktSHvyIBQLjElPU6svVDM0W3LaLqkxZYt2M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipxSB-0001YL-E5; Fri, 10 Jan 2020 17:48:07 +0100
Date:   Fri, 10 Jan 2020 17:48:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anirudh.venkataramanan@intel.com, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
Message-ID: <20200110164807.GA1849@lunn.ch>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
 <20200110160456.enzomhfsce7bptu3@soft-dev3.microsemi.net>
 <CA+h21hrq7U4EdqSgpYQRjK8rkcJdvD5jXCSOH_peA-R4xCocTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrq7U4EdqSgpYQRjK8rkcJdvD5jXCSOH_peA-R4xCocTg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think it would help your case if you explained a bit more about
> the hw offload primitives you have implemented internally.

Agreed.

Horatiu, could you also give some references to the frames that need
to be sent. I've no idea what information they need to contain, if the
contents is dynamic, or static, etc.

	 Andrew
