Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45825E79D9
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfJ1UQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:16:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39004 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbfJ1UQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 16:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MR3qQXq6D3fnR/mRwAsKkVGp0L0BCXTk2l0dnxNTYMI=; b=mm0l+BfiVdce/0diy/ZppZIRgB
        B7RrdoML3gD/+nFF0rbOX83bbXWbc+Dh1VI9d2T8CC4EgYJLOsbMW68dzWXQiMo00jyQ9M6YQc2/F
        7c8ovX1ksYasCQmvokiGB3hPXF+YQpnQjzdL/OUpFrCzQ08VnXskvkNbG8Cx8ChPIkcM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPBQj-0008RL-0u; Mon, 28 Oct 2019 21:15:57 +0100
Date:   Mon, 28 Oct 2019 21:15:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next 4/4] net: phy: marvell: add PHY tunable support
 for more PHY versions
Message-ID: <20191028201557.GJ17625@lunn.ch>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
 <e74bb89c-f510-61f7-f2fc-41fe0114c282@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74bb89c-f510-61f7-f2fc-41fe0114c282@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:54:17PM +0100, Heiner Kallweit wrote:
> More PHY versions are compatible with the existing downshift
> implementation, so let's add downshift support for them.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
