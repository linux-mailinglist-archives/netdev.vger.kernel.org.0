Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99C95ACB73
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 08:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiIEGz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 02:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbiIEGza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 02:55:30 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465861D0C5;
        Sun,  4 Sep 2022 23:55:20 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9e:d400:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 2856t5FO876715
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 07:55:07 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:961:910a:a293:6d6e:8bbf:c204])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2856t0fO1042270
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 08:55:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1662360900; bh=B8ds51VEQCz5E7/NG7drgSbJ23MaxqKfWsx4DbN9JtM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=hnJa60PtRVy0j9Y7+kZGgs3afvqGApgD0Ic6z4z9qfFCszjcvjCcwnMkX1F/yFJFe
         pFYcp9P7a/9mQcOq0xMFQHQVgxitiISdCy+ccAcEvjkkFBwzL1s9uOcWS+CrhYV/o4
         LjvAhj4hJRruFTsSX0UfzhgxT4C4PWyHPtfeQSsQ=
Received: (nullmailer pid 176082 invoked by uid 1000);
        Mon, 05 Sep 2022 06:54:45 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "jerry.meng" <jerry-meng@foxmail.com>
Cc:     davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add Quectel RM520N
Organization: m
References: <tencent_E50CA8A206904897C2D20DDAE90731183C05@qq.com>
Date:   Mon, 05 Sep 2022 08:54:45 +0200
In-Reply-To: <tencent_E50CA8A206904897C2D20DDAE90731183C05@qq.com> (jerry
        meng's message of "Mon, 5 Sep 2022 09:24:52 +0800")
Message-ID: <874jxmfgzu.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.6 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"jerry.meng" <jerry-meng@foxmail.com> writes:

> add support for Quectel RM520N which is based on Qualcomm SDX62 chip.
>
> 0x0801: DIAG + NMEA + AT + MODEM + RMNET
>
> T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D01 Cnt=3D02 Dev#=3D 10 Spd=3D480  =
MxCh=3D 0
> D:  Ver=3D 2.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D2c7c ProdID=3D0801 Rev=3D 5.04
> S:  Manufacturer=3DQuectel
> S:  Product=3DRM520N-GL
> S:  SerialNumber=3D384af524
> C:* #Ifs=3D 5 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:* If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Driver=
=3Doption
> E:  Ad=3D01(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D81(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D40 Driver=
=3Doption
> E:  Ad=3D83(I) Atr=3D03(Int.) MxPS=3D  10 Ivl=3D32ms
> E:  Ad=3D82(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D02(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> E:  Ad=3D85(I) Atr=3D03(Int.) MxPS=3D  10 Ivl=3D32ms
> E:  Ad=3D84(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D03(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> E:  Ad=3D87(I) Atr=3D03(Int.) MxPS=3D  10 Ivl=3D32ms
> E:  Ad=3D86(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D04(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Driver=
=3Dqmi_wwan
> E:  Ad=3D88(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D32ms
> E:  Ad=3D8e(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D0f(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
>
> Signed-off-by: jerry.meng <jerry-meng@foxmail.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 709e3c59e340..0cb187def5bc 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1087,6 +1087,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
>  	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
>  	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
> +	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0801)},	/* Quectel RM520N */
>=20=20
>  	/* 3. Combined interface devices matching on interface number */
>  	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */


Looks good!

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
