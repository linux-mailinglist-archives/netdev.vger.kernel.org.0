Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130161D8847
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgERTfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgERTfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 15:35:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91FB720643;
        Mon, 18 May 2020 19:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589830542;
        bh=Y9r1KHGALqrAUILV9ehHYdn1y1R+klWrJkIuAC7v01I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9YqDv9QcOnyngUaTHY+B1U1EVmsyzpB/KJWE0Jxee/HyfS9yCRJSMZ4kFQB4jGq2
         l1Pa1SkY35rdxJ6IVvWaZV64HV6HaLaEmR8LQKBw/SxSK70DmKzpctm5F5JZXKbMfk
         5APHLDxRWt+g6k5xqAzrslan0f8368xhtR36yV6U=
Date:   Mon, 18 May 2020 12:35:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 May 2020 08:16:47 +0000 Ioana Ciornei wrote:
> > With the Rx QoS features users won't even be able to tell via standard Linux
> > interfaces what the config was.  
> 
> Ok, that is true. So how should this information be exported to the user?

I believe no such interface currently exists. 
