Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052E615BF0B
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgBMNRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:17:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBMNRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 08:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XZ2JSFqEYtXTcD66uTPaHVmT67gwWXHQHTcBxJNnU2M=; b=4t81T9ZC5+VYUbXvXS85vYjzzS
        wcQr7ad8KmelSCrHY50Lu/Dxx4S3Ut6KIi6IdXgkndN9u9ALaVgDTjVc/RHlBsfuQEpoa/tHdtCke
        ApbZn8t/VgTd6jnonfwOR+3QtjWiBOLkMR5ub7kCtlXwYwRZqSMnyGBeCYAmdRL9Unnw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2EMx-00036g-Lg; Thu, 13 Feb 2020 14:17:27 +0100
Date:   Thu, 13 Feb 2020 14:17:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Per@axis.com
Cc:     netdev@vger.kernel.org, o.rempel@pengutronix.de,
        davem@davemloft.net, Per Forlin <per.forlin@axis.com>,
        Per Forlin <perfn@axis.com>
Subject: Re: [PATCH 1/2] net: dsa: tag_qca: Make sure there is headroom for
 tag
Message-ID: <20200213131727.GB11855@lunn.ch>
References: <20200213090707.27937-1-per.forlin@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213090707.27937-1-per.forlin@axis.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Per

Thanks for the patches.

Please take a look at

https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

For a multi-patch series, a cover note is required.

You should indicate in the patch subject which tree this is for, net
or net-next. net-next is closed at the moment.


On Thu, Feb 13, 2020 at 10:07:06AM +0100, Per@axis.com wrote:
> From: Per Forlin <per.forlin@axis.com>
> 
> Passing tag size to skb_cow_head will make sure
> there is enough headroom for the tag data.
> This change does not introduce any overhead in case there
> is already available headroom for tag.
> 
> Signed-off-by: Per Forlin <perfn@axis.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
