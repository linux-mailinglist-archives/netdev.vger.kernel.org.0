Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF56489B73
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 15:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiAJOko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 09:40:44 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:53301 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231196AbiAJOko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 09:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641825640;
        bh=XedwP+iNO0nilHdgO1plTP2iIBF+Vm/O4VtBN+afGmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=MgsMPXESmcpqPI12C6aaMYc3Uoh4Vg/0FhuHnzeph76f7fwZ/YxK7lIhZ2QYaUnVi
         pETN5g2KS4y1Ab7XgthLzfsZL0tNegkUoTTt+8oQckhYyrqFHkzOrkU9xoqGKkIRyv
         SA/tp1Z8P9YmWRdsqFy5ABV4se1nvlmpXty7QTqo=
Received: from localhost ([119.32.47.91])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id A26B40E0; Mon, 10 Jan 2022 22:40:38 +0800
X-QQ-mid: xmsmtpt1641825638t6fz0uysb
Message-ID: <tencent_0C9377D282B45298ADD426820211360E8F07@qq.com>
X-QQ-XMAILINFO: MgAERLP4sJkUEQnYpOWuVgMj2GOpMqUigaUYhzPzTk9iNKTiN6uJ90QLX5xYoI
         mA9PSt8Z2SpJPk/vSsS2IQKDECq/cogSlxDfgc+an/PjgWcsnMCr0D9dKOsK/fb1kIKM+OPJhTDS
         cxK1LVT4Sr3qRxJLyTBIrm3XSUfApSO+gjLSQPlaE2sCa0bioDN182eXFbNeyTScqkLmthWaJ2j2
         x3Ir/K4P3WD9n1jqhDzZO81ni59L464Vmb0Yms3LC1LcRt8vjF+rNz65+/5SQZv0xg2uUJz2ETOL
         fxegnSd/FkDsc05QDM8H98cTD8+5GY+VEMLNADKCvQl3EUiM991K8ManNjPc+5oad+Ci8v/Uo++O
         x9UEo5KIs02WHOGX8oArE8FotItNfr9VYtyMXG7wKeNUMGXT2s9qZ3SX5mQj2Q0BuUGew+lb8hSn
         A6wAm5YRbNha7IK1HMMJVsVSx2+e470zy3lw6RXY3bAx4fOZeQGoWYSQQV1YZAWTH+39+60pAYKV
         KmsN9NrJLXKp/ha2LYYd5bBe1uO3wanbWYZpkdQn0WNQh6D6IJwqt6bIG4NNDwlwX5paddTqP7Mm
         AWU6Rng0PHsEg7T/m/5HFodnmPGp84wK0pkW5xC8FFY7L5CvjZlz/fCLRXprUHR8icuSiVuFgPBt
         To2v24CJ+YQhktMYd/V1VUPNZaQ0z+KHq7OHvEewucbZlQktLjohdj0uW69bZO19ypwkJxpANgRB
         q1jjNmP8rGRC6y92oVpS8PsR47qQSP7NM3EP7vNkjVQRNPZOtp96Qf+SG1AZEwbweTo/MiDUg8Wm
         kvY94yOtgfCqXbLf/HOcEG6NmzSoFyK6RAMQixBDRe7OOVWvEIiQffS9rIZPUZ/I4o7FYgbTIBtQ
         ==
Date:   Mon, 10 Jan 2022 22:40:38 +0800
From:   Conley Lee <conleylee@foxmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
X-OQ-MSGID: <YdxFZpzzvX0jxtNi@fedora>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
 <Ydw1MOcmS6fZ6J8d@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ydw1MOcmS6fZ6J8d@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/10/22 at 02:31下午, Andrew Lunn wrote:
> Date: Mon, 10 Jan 2022 14:31:28 +0100
> From: Andrew Lunn <andrew@lunn.ch>
> To: Conley Lee <conleylee@foxmail.com>
> Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
>  wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number
>  with macro
> 
> > @@ -637,7 +637,9 @@ static void emac_rx(struct net_device *dev)
> >  		if (!rxcount) {
> >  			db->emacrx_completed_flag = 1;
> >  			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -			reg_val |= (0xf << 0) | (0x01 << 8);
> > +			reg_val |=
> > +				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
> > +				 EMAC_INT_CTL_RX_EN);
> 
> Putting the first value on the next line is a bit odd. This would be
> preferred:
> 
> +			reg_val |= (EMAC_INT_CTL_TX_EN |
> +                                   EMAC_INT_CTL_TX_ABRT_EN |
> +				    EMAC_INT_CTL_RX_EN);
> 
> I also have to wonder why two | have become three? (0x01 << 8) is
> clearly a single value. (0xf << 0) should either be a single macro, or
> 4 macros since 0xf is four bits. Without looking into the details, i
> cannot say this is wrong, but it does look strange.
> 
>        Andrew
> 
Thanks for your suggestion. The (0xf << 0) mask enable tx finish and tx abort
interrupts at hardware level. And the reason this mask has 4 bits is that
sun4i emac has 2 tx channels. I reduce it into two macros EMAC_INT_CTL_TX_EN 
and EMAC_INT_CTL_TX_ABRT_EN, this may be more readable, since we always
enable both tx channels in the driver.
