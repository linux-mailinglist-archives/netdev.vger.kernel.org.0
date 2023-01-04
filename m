Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0F465DD6A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 21:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjADUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 15:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240035AbjADUJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 15:09:14 -0500
X-Greylist: delayed 872 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 Jan 2023 12:09:03 PST
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AD040851
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 12:09:02 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 304Js5hg1256852
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 19:54:06 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 304JrujY2557740
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 20:53:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1672862039; bh=2CtMqG13v5p77cQO1RxO322vAedWDfdLoNrhunqULYg=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=kl8YQQ44kH6UBNMae/Jto9P+uzFotqgg+q6FyWJzd1zrN+edp3p77cjXBbyQLQPTI
         aKcochDtnmoD92/O5HHIFqki54mdEYtqwd9GckcBuUoMR3NEDQVZP9Kw4t9Egth9KC
         Uss+f3SPLPRAGPlNBY2ryqtqmW1B8MzuBy3PznMA=
Received: (nullmailer pid 11784 invoked by uid 1000);
        Wed, 04 Jan 2023 19:53:56 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
Cc:     johan@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Matthew Garrett <mgarrett@aurora.tech>
Subject: Re: [PATCH V2 2/3] net: usb: qmi_wwan: Add generic MDM9207
 configuration
Organization: m
References: <20221226234751.444917-1-mjg59@srcf.ucam.org>
        <20221226234751.444917-3-mjg59@srcf.ucam.org>
Date:   Wed, 04 Jan 2023 20:53:56 +0100
In-Reply-To: <20221226234751.444917-3-mjg59@srcf.ucam.org> (Matthew Garrett's
        message of "Mon, 26 Dec 2022 15:47:50 -0800")
Message-ID: <87y1qikre3.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> The Orbic Speed RC400L presents as a generic MDM9207 device that supports
> multiple configurations with different USB IDs. One exposes a QMI interfa=
ce.
> Add the ID for that.
>
> Signed-off-by: Matthew Garrett <mgarrett@aurora.tech>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index a808d718c012..bf05b7feacc0 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1223,6 +1223,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x05c6, 0x90b2, 3)},    /* ublox R410M */
>  	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
>  	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
> +	{QMI_FIXED_INTF(0x05c6, 0xf601, 5)},
>  	{QMI_QUIRK_SET_DTR(0x05c6, 0x9625, 4)},	/* YUGA CLM920-NC5 */
>  	{QMI_FIXED_INTF(0x0846, 0x68a2, 8)},
>  	{QMI_FIXED_INTF(0x0846, 0x68d3, 8)},	/* Netgear Aircard 779S */


Looks good to me, but checkpatch warns about

 WARNING: From:/Signed-off-by: email address mismatch: 'From: Matthew Garre=
tt <mjg59@srcf.ucam.org>' !=3D 'Signed-off-by: Matthew Garrett <mgarrett@au=
rora.tech>'

which you might want to consider, unless this was intentional for some
reason?  In any case:

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
