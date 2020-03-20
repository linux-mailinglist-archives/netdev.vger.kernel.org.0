Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C579A18DB4C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgCTWrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:47:17 -0400
Received: from canardo.mork.no ([148.122.252.1]:37687 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCTWrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 18:47:16 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 02KMl2We000379
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 20 Mar 2020 23:47:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1584744423; bh=syVd/UqIUk4uQQChdInf/Q9Jll6os/XzMsgigKZli+c=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=NvjPXZ+xZYPQXfFRcdLubdEXHCNaJp1VlZ7ObyBDu6X/G3bgdoR3RsoM730gcTZl0
         kx/SYb6EARmyj9+E6X1jryGVnSJ1Z36zIzYoQi85QG0af9DAIV6SHCxBV2WKAdrtFz
         CdHgVwpmL+eXCl2YlgjQ59I9rrUvvyiaMrSicV7M=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jFQPu-0003FH-87; Fri, 20 Mar 2020 23:47:02 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Cezary Jackiewicz <cezary@eko.one.pl>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: qmi_wwan: add support for ASKEY WWHC050
Organization: m
References: <20200320204614.4662-1-paweldembicki@gmail.com>
Date:   Fri, 20 Mar 2020 23:47:02 +0100
In-Reply-To: <20200320204614.4662-1-paweldembicki@gmail.com> (Pawel Dembicki's
        message of "Fri, 20 Mar 2020 21:46:14 +0100")
Message-ID: <87lfnuve3d.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pawel Dembicki <paweldembicki@gmail.com> writes:

> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 5754bb6ca0ee..6c738a271257 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1210,6 +1210,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x1435, 0xd182, 5)},	/* Wistron NeWeb D18 */
>  	{QMI_FIXED_INTF(0x1435, 0xd191, 4)},	/* Wistron NeWeb D19Q1 */
>  	{QMI_QUIRK_SET_DTR(0x1508, 0x1001, 4)},	/* Fibocom NL668 series */
> +	{QMI_FIXED_INTF(0x1690, 0x7588, 4)},    /* ASKEY WWHC050 */
>  	{QMI_FIXED_INTF(0x16d8, 0x6003, 0)},	/* CMOTech 6003 */
>  	{QMI_FIXED_INTF(0x16d8, 0x6007, 0)},	/* CMOTech CHE-628S */
>  	{QMI_FIXED_INTF(0x16d8, 0x6008, 0)},	/* CMOTech CMU-301 */

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
