Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0CA1C0609
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgD3TTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:19:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgD3TTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kn6td7end1fk2SRFrPwPsOdgAphzqnVSSD+aX/O1L5I=; b=sfxamlTtpV7dZTa2/x8O+89mEb
        9BmRPUt2CzYIxYHdueS8IkTiw+NaRI65TdiObtQrILhwkNeDrWdkujLlK9e0YfVdCvCBq9s2Fqdjo
        4lWzn5k3shIcDsZE61kF+NUNpJpbwxTPVlBfEa+/rlTgV305XlGAuy8wjUuDaKkj1lMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUEim-000S6e-Li; Thu, 30 Apr 2020 21:19:44 +0200
Date:   Thu, 30 Apr 2020 21:19:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next 1/4] net: dsa: b53: Rename num_arl_entries to
 num_arl_bins
Message-ID: <20200430191944.GB107658@lunn.ch>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
 <20200430184911.29660-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430184911.29660-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:49:08AM -0700, Florian Fainelli wrote:
> The variable currently holds the number of ARL bins per ARL buckets,
> which is different from the number of ARL entries which would be bins
> times buckets. We will be adding a num_arl_buckets in a subsequent patch
> so get variables straight now.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
