Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BF8B93B0
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391249AbfITPIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:08:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbfITPIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 11:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JiyFVAhOA/iIKj2xca9nm1lZOLBrx55dMt6SEYaYwks=; b=hma3kseKhRHDXuf4glN3SYi9le
        vnQgcWfZfm2H1iGaRbJVjnA1n0kTTdNU/H1lSuBzatmHjSioEh/S+N1ejdHsegGaq5RhURLEgTABI
        w9GyY+JhHLGn5YD4VVG6/mSvf+LB1o7EZ4DdvbRhnwv7VBIH00Na4kauwkvUlm4zSzNA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iBKWL-0005rY-VT; Fri, 20 Sep 2019 17:08:29 +0200
Date:   Fri, 20 Sep 2019 17:08:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: vsc73xx: Return an error code as a
 constant in vsc73xx_platform_probe()
Message-ID: <20190920150829.GF3530@lunn.ch>
References: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
 <738c12c8-f51e-d2e5-f31e-7f726cf6325d@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <738c12c8-f51e-d2e5-f31e-7f726cf6325d@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 04:30:13PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 20 Sep 2019 16:07:07 +0200
> 
> * Return an error code without storing it in an intermediate variable.
> 
> * Delete the local variable “ret” which became unnecessary
>   with this refactoring.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

