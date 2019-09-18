Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C903B6352
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 14:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfIRMfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 08:35:03 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44648 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIRMfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 08:35:03 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id C1C8B25AF19;
        Wed, 18 Sep 2019 22:35:00 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id EBCA9942C13; Wed, 18 Sep 2019 14:34:57 +0200 (CEST)
Date:   Wed, 18 Sep 2019 14:34:57 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v7 1/7] nfc: pn533: i2c: "pn532" as dt compatible string
Message-ID: <20190918123457.wg6mtygr6cboqsp6@verge.net.au>
References: <20190910093129.1844-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910093129.1844-1-poeschel@lemonage.de>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 11:31:21AM +0200, Lars Poeschel wrote:
> It is favourable to have one unified compatible string for devices that
> have multiple interfaces. So this adds simply "pn532" as the devicetree
> binding compatible string and makes a note that the old ones are
> deprecated.

Do you also need to update
Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt
to both document the new compat string and deprecate the old ones?

> Cc: Johan Hovold <johan@kernel.org>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> Changes in v6:
> - Rebased the patch series on v5.3-rc5
> 
> Changes in v3:
> - This patch is new in v3
> 
>  drivers/nfc/pn533/i2c.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
> index 1832cd921ea7..1abd40398a5a 100644
> --- a/drivers/nfc/pn533/i2c.c
> +++ b/drivers/nfc/pn533/i2c.c
> @@ -245,6 +245,11 @@ static int pn533_i2c_remove(struct i2c_client *client)
>  }
>  
>  static const struct of_device_id of_pn533_i2c_match[] = {
> +	{ .compatible = "nxp,pn532", },
> +	/*
> +	 * NOTE: The use of the compatibles with the trailing "...-i2c" is
> +	 * deprecated and will be removed.
> +	 */
>  	{ .compatible = "nxp,pn533-i2c", },
>  	{ .compatible = "nxp,pn532-i2c", },
>  	{},
> -- 
> 2.23.0
> 
