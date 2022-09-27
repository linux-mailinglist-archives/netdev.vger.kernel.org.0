Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46945EBAA6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 08:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiI0GbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 02:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiI0Ga5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 02:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561778670A;
        Mon, 26 Sep 2022 23:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A5A61604;
        Tue, 27 Sep 2022 06:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6F0C433D6;
        Tue, 27 Sep 2022 06:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664260255;
        bh=YGDSP5vLuXAeAgX4Rz1u2FTBmaQowm/Pe9gP8nWeNdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdpgttYZfI8FZsZgXi1OHKUN56K+EB+ohwmfdOS6Vf+JrdQS9wj/I41PhZmtrm16E
         hlx5xleiavKfW//6iijp71HVs5s6zCV5CzlV5Q3G/vR+3mhTlk2QhTv6MU44lPh2GG
         1zYzKB1SezyEMw0WXRV1CAES/pvHJ3LyDHvoba6lrbjTaEngLROohVRd+L+/l9jHUS
         PNAHFtII8LGQ/+RINhboAtj+qfQz0/mn4BZWFToLBrdReOluLCZEXI+aOHsILwruvO
         qEBFRZxZHbd6qDjRYRLeNhnwxVptZbJCzRYcAjk/7jwBK5v059RsUR2nWJd3cOOi8W
         Qipv8yGXPhJcw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1od47Q-0006Uq-UD; Tue, 27 Sep 2022 08:31:00 +0200
Date:   Tue, 27 Sep 2022 08:31:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-usb@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: serial: qcserial: add new usb-id for Dell
 branded EM7455
Message-ID: <YzKYpPFyZYMkVaxS@hovoldconsulting.com>
References: <20220926150740.6684-1-linux@fw-web.de>
 <20220926150740.6684-2-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926150740.6684-2-linux@fw-web.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:07:39PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Add support for Dell 5811e (EM7455) with USB-id 0x413c:0x81c2.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/usb/serial/qcserial.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
> index 586ef5551e76..7897609916a6 100644
> --- a/drivers/usb/serial/qcserial.c
> +++ b/drivers/usb/serial/qcserial.c
> @@ -177,6 +177,7 @@ static const struct usb_device_id id_table[] = {
>  	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
>  	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
>  	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
> +	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e QDL */

I assume this is not just for QDL mode as the comment indicates.

Could you post the output of usb-devices for this device?

>  	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
>  	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
>  	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */

Johan
