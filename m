Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965D6122740
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfLQJBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:01:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbfLQJBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 04:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lMf3zzy7DTDeGIL5VvC/NED1kW0fPCS7SKGgm+3+rDo=; b=Phf7JzyKB6/yZW6NZrJVVtaK2l
        WIkkHXi5c3BpCv4U0bUedMcrBAzQDd4FtAUpbeo25CTnj/i/9cqKkgSv/DUGxKeW+J/39Eq5iN1HS
        1olj6xXNpxpXYlFQwKqkj/DLlqWJtulCsjQwWCVzDHF12aUoN5J+3KMzMZeL9gUyfyEc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8ja-0003HV-OM; Tue, 17 Dec 2019 10:01:38 +0100
Date:   Tue, 17 Dec 2019 10:01:38 +0100
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
Subject: Re: [PATCH V6 net-next 03/11] net: vlan: Use the PHY time stamping
 interface.
Message-ID: <20191217090138.GI6994@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <de2f4c6f93857bc932c71574abcdc48eee706b99.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de2f4c6f93857bc932c71574abcdc48eee706b99.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:18AM -0800, Richard Cochran wrote:
> The vlan layer tests fields of the phy_device in order to determine
> whether to invoke the PHY's tsinfo ethtool callback.  This patch
> replaces the open coded logic with an invocation of the proper
> methods.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
