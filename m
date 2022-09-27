Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06B5EBAF4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 08:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiI0Gsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 02:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiI0Gsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 02:48:51 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02BBA0251;
        Mon, 26 Sep 2022 23:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1664261303;
        bh=MABeniCegLHmuQuCAgbLgNA+XbXcpQDMwpltzh3OtV0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IqEVFeofQz1Yfq5THi90YsyCzsHuuZ0lOOmKnO4csS9fiKuf3mvfE/QuBrOLvGNhv
         H6PaIXO9oQYpVZxl2+V4WkJSk99Skc4zZc54c3QNCv8hY1fLBqCIVU1xl9rcohbx3k
         K7UScYhgyYN01XNTVMOrj5Cfz31ETIyK1vKutI6k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.76.226] ([80.245.76.226]) by web-mail.gmx.net
 (3c-app-gmx-bs56.server.lan [172.19.170.140]) (via HTTP); Tue, 27 Sep 2022
 08:48:23 +0200
MIME-Version: 1.0
Message-ID: <trinity-91bc03bb-af6e-42bc-a365-455816214834-1664261303738@3c-app-gmx-bs56>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     Frank Wunderlich <linux@fw-web.de>, linux-usb@vger.kernel.org,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Aw: Re: [PATCH 1/2] USB: serial: qcserial: add new usb-id for Dell
 branded EM7455
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 27 Sep 2022 08:48:23 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YzKYpPFyZYMkVaxS@hovoldconsulting.com>
References: <20220926150740.6684-1-linux@fw-web.de>
 <20220926150740.6684-2-linux@fw-web.de>
 <YzKYpPFyZYMkVaxS@hovoldconsulting.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:qtACESdS4ViVIblRS4dcWVxifOgPd/ZklD2tL9ypNecYge125EUBrs1QoPML1PHddwU/+
 prZ+19CTUgQBsa2T439oH7/8V8rFU5scghkedoMjUgJo1GNKEn5+I6j/IoVaRc8TVb7+x6ttIHM8
 mjPwCeehz9DTtXxxOE3GUgZw/SLB8VBb6oxSZTf1Bb5arJ+hWmqjzJ5/vHoiHZojCGCkS1fMbxv8
 L8t/rSF9WvvWseJpavjaS1JKqz9QAQ5HXnopvemfbyO/WHopSxo0nevUgrRreij7Jon7rhQV0qqh
 wI=
X-UI-Out-Filterresults: notjunk:1;V03:K0:NHJsZrdeaPU=:1QbKYvzQPsRQxAZxcNcP07
 UM+Q3EkEG9MwQprJdhi5UBXwKkP9RSM3uW+Nzh15KXhlRnUmYagyPuJAsOcDEOJHGQkRx4GHu
 kVl7uqS26H3kPQlMbfs+u+1aq2ljmpVQFu4JCG0MV57dmRkkbGp7wjGjgbWy7zsvQxAJREH83
 s4RmPJE5QOX68Tw8DiAGIE6YuPwzYtkYoHbthNHD+rDqjTH0s/E3ylCh1YtLBZTc/jgKp2aF+
 9856lvGm+j0ozj86Oh+I+XLD6Nah4j5WKVKEabEP9Q60jDh1DLCr4y9lR1xwyXkGPbrZi9JgG
 wf07tfkftPosRhNu6jn03zxbkTKIR8iUO9sVKJBZr3Re9+nwdDKileFLseNekC1WVDDKkY5rn
 uoxbf3VKOi3HbV4JiMwFqenPaKXZT4BGwfl+xLApjkslB85KX8wmkwq6XEuILmuq1r6kdoFg3
 sCrcLatMSWZND5HAY6o/WyI00LJkj59Tubk4O1XC8fJDh0c1V3tDZve1iNRjUkNZAOOm50ziy
 iRXUp9YhhVRv+K5nssVNEMJkuYlggckLfDg7YQmv6dJyymXWOEI/mAHn69WSY1ndwC1Tk28fn
 ZGjjkwwRQnjW6DPd9VyndIgoBNDeQuGpNeMVvYIlK+oWqNddoqXewV5d+IWjFNek9LoRs3TKU
 +V5/AY0akWzOcR3wG/f6nTvw4Hl2+6L8tIA/zXj7AiOtpW5q4v50T3U6Ww4fyekETJ0XM3D+N
 SMbClbA8RJ25s4H6RUASG4rc01aG/3x+ULfmRLkn7A2TV+7O55wReK1Q8v5DjFBY5paI2VEou
 M6WYyTo
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Dienstag, 27=2E September 2022 um 08:31 Uhr
> Von: "Johan Hovold" <johan@kernel=2Eorg>
> An: "Frank Wunderlich" <linux@fw-web=2Ede>
> Cc: linux-usb@vger=2Ekernel=2Eorg, "Frank Wunderlich" <frank-w@public-fi=
les=2Ede>, "Bj=C3=B8rn Mork" <bjorn@mork=2Eno>, "David S=2E Miller" <davem@=
davemloft=2Enet>, "Eric Dumazet" <edumazet@google=2Ecom>, "Jakub Kicinski" =
<kuba@kernel=2Eorg>, "Paolo Abeni" <pabeni@redhat=2Ecom>, "Greg Kroah-Hartm=
an" <gregkh@linuxfoundation=2Eorg>, netdev@vger=2Ekernel=2Eorg, linux-kerne=
l@vger=2Ekernel=2Eorg, stable@vger=2Ekernel=2Eorg
> Betreff: Re: [PATCH 1/2] USB: serial: qcserial: add new usb-id for Dell =
branded EM7455
>
> On Mon, Sep 26, 2022 at 05:07:39PM +0200, Frank Wunderlich wrote:
> > From: Frank Wunderlich <frank-w@public-files=2Ede>

> > +++ b/drivers/usb/serial/qcserial=2Ec
> > @@ -177,6 +177,7 @@ static const struct usb_device_id id_table[] =3D {
> >  	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE=
 Mobile Broadband Card (rev3) */
> >  	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
> >  	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
> > +	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e QDL */
>=20
> I assume this is not just for QDL mode as the comment indicates=2E

to be honest, have not found out yet what QDL means and assumed that it's =
like the other dw5811e, so not changed comment :)

> Could you post the output of usb-devices for this device?

Bus 001 Device 004: ID 413c:81c2 Sierra Wireless, Incorporated DW5811e Sna=
pdragon=E2=84=A2 X7 LTE


/:  Bus 01=2EPort 1: Dev 1, Class=3Droot_hub, Driver=3Dxhci-mtk/2p, 480M  =
                                                               =20
    ID 1d6b:0002 Linux Foundation 2=2E0 root hub                          =
                                                           =20
    |__ Port 1: Dev 2, If 0, Class=3DHub, Driver=3Dhub/4p, 480M           =
                                                             =20
        ID 1a40:0101 Terminus Technology Inc=2E Hub                       =
                                                           =20
        |__ Port 1: Dev 6, If 0, Class=3DVendor Specific Class, Driver=3Dq=
cserial, 480M                                                =20
            ID 413c:81c2 Dell Computer Corp=2E                            =
                                                           =20
        |__ Port 1: Dev 6, If 2, Class=3DVendor Specific Class, Driver=3Dq=
cserial, 480M                                                =20
            ID 413c:81c2 Dell Computer Corp=2E                            =
                                                           =20
        |__ Port 1: Dev 6, If 3, Class=3DVendor Specific Class, Driver=3Dq=
cserial, 480M                                                =20
            ID 413c:81c2 Dell Computer Corp=2E                            =
                                                           =20
        |__ Port 1: Dev 6, If 8, Class=3DVendor Specific Class, Driver=3Dq=
mi_wwan, 480M                                                =20
            ID 413c:81c2 Dell Computer Corp=2E       =20

> >  	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
> >  	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
> >  	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
>=20
> Johan

regards Frank
