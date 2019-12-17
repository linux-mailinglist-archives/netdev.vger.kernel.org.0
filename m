Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9BD12273E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfLQJBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:01:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbfLQJBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 04:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a5G2aLhfMhgdBcJ8dMVKYG/5bVkQmxzG5JkgB7MqChU=; b=fcuCRD1MeS1Ksk+nVP91aZq9sV
        Dq3pDb2SFGp+5BuDNfEm8EHn3wakMgAtRrriLFuk3B8og6Yt4uNxEq1ecw0Xz9Bgc87miA+T11jdT
        oaey3w2L6cnMzo/r2o8QGeN5zL9aDRmWyu6t+N1ZbVUoFjTkcxYAGa5qVNEt6P4TdxZc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8jI-0003CC-Sb; Tue, 17 Dec 2019 10:01:20 +0100
Date:   Tue, 17 Dec 2019 10:01:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 01/11] net: phy: Introduce helper functions
 for time stamping support.
Message-ID: <20191217090120.GH6994@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <153343b4ae5dd92dff803127c467dcce58a5933f.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153343b4ae5dd92dff803127c467dcce58a5933f.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:16AM -0800, Richard Cochran wrote:
> Some parts of the networking stack and at least one driver test fields
> within the 'struct phy_device' in order to query time stamping
> capabilities and to invoke time stamping methods.  This patch adds a
> functional interface around the time stamping fields.  This will allow
> insulating the callers from future changes to the details of the time
> stamping implemenation.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
