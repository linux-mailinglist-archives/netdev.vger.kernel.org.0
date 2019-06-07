Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F4E38279
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 03:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfFGB7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 21:59:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbfFGB7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 21:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rPiY4ryxbX5lKhyCC1Ro4K1SQb3yamQXN8Milhacjic=; b=5LtqdWJE3vWshALdzBkQbb4G6i
        f6BrlycBkg5wl8vKZicRTuwz5HKSUUx4vQBq+WiRQwN8mvnZPWp371pqQgJxjPkxG3jLVGkrOTdTQ
        FMXCKd5e7p1m6V1f0mHc09+9AAfELeq6FDIoPoSo28ikUmjKAbwjsvABAcwpypEc8Km8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZ49w-0002jZ-FY; Fri, 07 Jun 2019 03:59:12 +0200
Date:   Fri, 7 Jun 2019 03:59:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers: net: phy: fix warning same module names
Message-ID: <20190607015912.GI20899@lunn.ch>
References: <20190606094727.23868-1-anders.roxell@linaro.org>
 <20190606125817.GF20899@lunn.ch>
 <e56b59ce-5d5d-b28f-4886-d606fee19152@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56b59ce-5d5d-b28f-4886-d606fee19152@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 12:34:47PM +1200, Michael Schmitz wrote:
> Hi Andew, Anders,
> 
> sorry I dropped the ball on that one - I've got a patch for the ax88796b PHY
> driver that I just forgot to resend.
> 
> It'll clash with your patch, Anders - are you happy to drop the
> CONFIG_ASIX_PHY from your series?

Hi Michael

Please send your patch. Anders needs to split up his patchset anyway,
so dropping one is not a problem.

   Andrew
