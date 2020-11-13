Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9CB2B139E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKMBCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgKMBCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:02:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB7B208D5;
        Fri, 13 Nov 2020 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605229340;
        bh=MI1jTo/efK1I/wkR3i2F7I0ku16tHOZXGV5gXJmGxLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VsD2E+UUMdRPK62PcoxS+LScythsP+DRcobPTDSOH0b8ZnJlml7kqvkJkHsk0cUeE
         x4MyDMSogksr9H0p4vG07B+Ut9w6wCjpppvgnlhwO+uaYeyiJdGi2B6XVKhAyuM9eD
         0IJvT5m0h2JHblYqO7ehJnR+qTEDqZIcF7YtTPug=
Date:   Thu, 12 Nov 2020 17:02:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc:     Joel Stanley <joel@jms.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net/ncsi: Fix netlink registration
Message-ID: <20201112170218.5ad073c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6514889a7af123eed01e3471ae1c48252e9aa296.camel@mendozajonas.com>
References: <20201112061210.914621-1-joel@jms.id.au>
        <6514889a7af123eed01e3471ae1c48252e9aa296.camel@mendozajonas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 08:25:39 -0800 Samuel Mendoza-Jonas wrote:
> On Thu, 2020-11-12 at 16:42 +1030, Joel Stanley wrote:
> > If a user unbinds and re-binds a NC-SI aware driver the kernel will
> > attempt to register the netlink interface at runtime. The structure
> > is
> > marked __ro_after_init so registration fails spectacularly at this
> > point.  
> 
> Reviewed-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>

Applied to net, thanks!
