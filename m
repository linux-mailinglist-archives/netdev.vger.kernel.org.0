Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75E1B4E10
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfIQMlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 08:41:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbfIQMlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 08:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aar7K5K/y+RCGtVDqbMIWYGQlHMubJp2qZUhMT+Yq2U=; b=wNC1+U47xMrKyi+qAQ5IimJMH1
        5xcJGLxIgE8f9ipXN7rraucv2L0755fMrasd4vsArbJpd5ToHnBooG95Uaz4Blbwv3nEz2Vgvde79
        17gJ8Kt4MQiW0JQt/mX//D8ouxZYy8WI+leEUt5cQOkTKE6cZL1gJL1o9Yf9xdJgjqD0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iACnU-0000rT-KO; Tue, 17 Sep 2019 14:41:32 +0200
Date:   Tue, 17 Sep 2019 14:41:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, f.fainelli@gmail.com
Subject: Re: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
Message-ID: <20190917124132.GG20778@lunn.ch>
References: <20190917103052.13456-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917103052.13456-1-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 01:30:52PM +0300, Alexandru Ardelean wrote:
> The 'mac-mode' property is similar to 'phy-mode' and 'phy-connection-type',
> which are enums of mode strings.
> 
> The 'dwmac' driver supports almost all modes declared in the 'phy-mode'
> enum (except for 1 or 2). But in general, there may be a case where
> 'mac-mode' becomes more generic and is moved as part of phylib or netdev.
> 
> In any case, the 'mac-mode' field should be made an enum, and it also makes
> sense to just reference the 'phy-connection-type' from
> 'ethernet-controller.yaml'. That will also make it more future-proof for new
> modes.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Hi Alexandru

Adding a Fixes: tag would be good. Just reply in this thread, and
patchwork will do magic to append it to the patch.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
