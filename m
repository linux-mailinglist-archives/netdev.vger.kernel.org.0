Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F61C064A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3TZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:25:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgD3TZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:25:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wLGvNelWRx7f6z7Et4vJA6iWvSzudrjZjEsEwnZ47Sw=; b=3ZK5cpeidzvDGhVfS3/LpFCKjf
        7BDh1W83JUvYqYghsVEu39MIOdYCtI5ov5d9Yzqv/+EDSNwUe6t8ta+2C9cbWnHSoGinis2KqmdL7
        Ib9nSLV4DWhCSJb47rr4cr3mWDhLa6TgUKhdOCJx6xNfFS2d9HZbhfrZscstRav68Ab4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUEoF-000SDe-TH; Thu, 30 Apr 2020 21:25:23 +0200
Date:   Thu, 30 Apr 2020 21:25:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: b53: Remove is_static argument to
 b53_read_op()
Message-ID: <20200430192523.GE107658@lunn.ch>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
 <20200430184911.29660-5-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430184911.29660-5-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:49:11AM -0700, Florian Fainelli wrote:
> This argument is not used.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
