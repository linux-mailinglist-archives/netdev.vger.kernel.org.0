Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB75EAE74
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiIZRqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiIZRpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:45:49 -0400
X-Greylist: delayed 651 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Sep 2022 10:15:46 PDT
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1E072B4C;
        Mon, 26 Sep 2022 10:15:44 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9e:d400:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 28QH4KZ8672490
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 18:04:22 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9e:d402:994f:a892:5647:3399])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 28QH4FPd3519149
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 19:04:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1664211855; bh=PqndwwYw1ihtRY0vSKmdDtjYH38o8PijP0Upc5+FQhk=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=SPRlWzSh0GqPerWaLEGfitcRmPvVnFn2tsRf9fFHqbrUHDzaotI9DdcctX5zwJfrD
         39g03HaXQd207SsfvAx/573cOx8NEJ8sdP3r6xKzPUuUk27j+e/iSA2oaB82kA/3qt
         LsqKbryOY7rwhyWBB6GqU3YDxYq69Z4oKDwOkslE=
Received: (nullmailer pid 818259 invoked by uid 1000);
        Mon, 26 Sep 2022 17:04:15 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-usb@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] net: usb: qmi_wwan: Add new usb-id for Dell branded
 EM7455
Organization: m
References: <20220926150740.6684-1-linux@fw-web.de>
        <20220926150740.6684-3-linux@fw-web.de>
Date:   Mon, 26 Sep 2022 19:04:15 +0200
In-Reply-To: <20220926150740.6684-3-linux@fw-web.de> (Frank Wunderlich's
        message of "Mon, 26 Sep 2022 17:07:40 +0200")
Message-ID: <87sfke9ieo.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frank Wunderlich <linux@fw-web.de> writes:

> From: Frank Wunderlich <frank-w@public-files.de>
>
> Add support for Dell 5811e (EM7455) with USB-id 0x413c:0x81c2.
>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 0cb187def5bc..26c34a7c21bd 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1402,6 +1402,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G=
 LTE Mobile Broadband Card (rev3) */
>  	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
>  	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
> +	{QMI_FIXED_INTF(0x413c, 0x81c2, 8)},	/* Dell Wireless 5811e */
>  	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
>  	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
>  	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproducti=
on config */

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
