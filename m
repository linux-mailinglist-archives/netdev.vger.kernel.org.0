Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9741D9D56
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgESQ6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728778AbgESQ6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:58:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C022075F;
        Tue, 19 May 2020 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589907500;
        bh=wON0KBDCS5zMpkAAmFVUnsEOH1a7o5ryClmYvR0Mm+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IxwqA0P84DMGAtGNa4obAfFwhbdvqD3Bz5YPObh3hQU3+G7QF/veLi7gsfIjYfnZX
         /ydynmdSwffGagAYILULpz6y+xAIiBcvxmcax+WzgJ5IkoNLw4dQ1B2eHaVn+W2stk
         il5tnivohL+/cQxG2HFS1qu+f5LNv3zuJipykdw8=
Date:   Tue, 19 May 2020 09:58:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
Message-ID: <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519141813.28167-3-dmurphy@ti.com>
References: <20200519141813.28167-1-dmurphy@ti.com>
        <20200519141813.28167-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 09:18:11 -0500 Dan Murphy wrote:
> If the op-mode for the device is not set in the device tree then set
> the strapped op-mode and store it for later configuration.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

../drivers/net/phy/dp83869.c: In function0 dp83869_set_strapped_mode:
../drivers/net/phy/dp83869.c:171:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
  171 |  if (val < 0)
      |          ^
