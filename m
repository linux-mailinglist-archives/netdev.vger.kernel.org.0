Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5412225B8E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfEVBOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:14:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42673 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfEVBOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 21:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dBfNL26h4UOw7+uWJM0IEtlP1qwnut0aoUGmAtGzb9M=; b=bdwmEOBOccPJMs9ko/nyWM9wBc
        MSvOSE0tOLqU85lrZyP9hFwRObfqHAwogdqGWLZjyIl7Co6zOKRVF8oa7CgV3n7HZ5N/sSJdN4ixZ
        5Jo3LQfSvpyRF9Pt9N33Smp01RlDcmLiEmHHwD4kqpDP7X4hOPIMRPapqcvYzxD9p9AM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTFqC-00008K-8y; Wed, 22 May 2019 03:14:48 +0200
Date:   Wed, 22 May 2019 03:14:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 4/6] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20190522011448.GF6577@lunn.ch>
References: <20190521224723.6116-5-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521224723.6116-5-richardcochran@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 03:47:21PM -0700, Richard Cochran wrote:
> This patch add a new binding that allows non-PHY MII time stamping
> devices to find their buses.  The new documentation covers both the
> generic binding and one upcoming user.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
