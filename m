Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872BA6204CC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 01:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiKHAn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 19:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiKHAn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 19:43:27 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBF5C4A
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 16:43:22 -0800 (PST)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221108004318epoutp0473d6e7641745e65652cbf9db86fa06e8~ldUpNJPa31074010740epoutp04s
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:43:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221108004318epoutp0473d6e7641745e65652cbf9db86fa06e8~ldUpNJPa31074010740epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667868199;
        bh=uqVBtm0tHK3cdhqzQW+N+QwjWT+cXYAyTVCzFI4k560=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=bCsVU9TUqtJ3Ac+AN/jorh01smBs5SDGylcLwFdCu3F482T+KmybGYHKvdmgY+Id4
         jT9lxoR/JMRiEMUx9gjyTAnsXLN6iEkAYFtTDsuQjCfclRzWoRlj1AVZ9yCXhmHkrp
         P9r92RYrAKNQpKZdt8Gci5BfbbRq3SZFZk8y3Xs0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20221108004318epcas2p3c84407a2b3ccfd3e437321a4c79b2b88~ldUo2xS0b2929929299epcas2p3L;
        Tue,  8 Nov 2022 00:43:18 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.68]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N5q8Q15H3z4x9Pr; Tue,  8 Nov
        2022 00:43:18 +0000 (GMT)
X-AuditID: b6c32a45-3f1ff7000001f07d-e1-6369a625b8d5
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        24.2E.61565.526A9636; Tue,  8 Nov 2022 09:43:17 +0900 (KST)
Mime-Version: 1.0
Subject: Re: [PATCH net-next v3] nfc: Allow to create multiple virtual nci
 devices
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>
CC:     "leon@kernel.org" <leon@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
Date:   Tue, 08 Nov 2022 09:43:16 +0900
X-CMS-MailID: 20221108004316epcms2p63ff537496ef759cb0c734068bd58855c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTQld1WWaywal+KYstzZPYLSY8bGO3
        2Pt6K7vFlF9LmS2OLRCzOPKmm9mBzWPBplKPPRNPsnlsWtXJ5nHn2h42j74tqxg9Pm+SC2CL
        yrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpCSaEs
        MacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgXqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd
        sbhTpeCBWsX0x1PZGhg75boYOTkkBEwkmtv2M3UxcnEICexglPhyvYG9i5GDg1dAUOLvDmGQ
        GmGBEIk938+ygdhCAooS/zvOsUHEdSVe/D0KZrMJaEusPdrIBGKLCPhLrDyxhhVkJrPAPUaJ
        dR8vsUMs45WY0f6UBcKWlti+fCsjyC5OgUCJZxNtIMIaEj+W9TJD2KISN1e/ZYex3x+bzwhh
        i0i03jsLVSMo8eDnbqi4lMSnh2dYIex8iZe7Otgg7BKJx2cWQdWbS+x5swsszivgK3Fl71yw
        m1kEVCUWLD7GBnKOhICLxLpGM5Aws4C8xPa3c5hBwswCmhLrd+lDVChLHLnFAlHBJ9Fx+C/c
        fzvmPWGCsFUlepu/MMH8Onl2C9SRHhK3l/1nncCoOAsRzLOQ7JqFsGsBI/MqRrHUguLc9NRi
        owJDeMQm5+duYgSnRS3XHYyT337QO8TIxMF4iFGCg1lJhFekJjNZiDclsbIqtSg/vqg0J7X4
        EKMp0JMTmaVEk/OBiTmvJN7QxNLAxMzM0NzI1MBcSZy3a4ZWspBAemJJanZqakFqEUwfEwen
        VAOT8rx1H7YdiS4v89AQ/7k+0uPTxmknT8kpPC7qCF3IeerAdcN/HoaVH2q0pzRtqmRKLO20
        fbMske97t+oSNavP1z8szHf7ffXeX+bn539/uCVnJ1med0djwU9L/Tq2re8VqqP1Hk59vtqY
        TfASg1JB+FsFk2/n8zPnVf0+95w5UtKHY/7dHfO/W6Y/l/v88PFmprf63y7qfBK4zf7YdqHk
        1veMD9PvH5x/sF5l+W+R4E1P90+Ln3fsVvKXQzPkl8gt09y3K+T0i+/ht8qX/T00M97nqNzD
        5kNaITH3Wh6mBM97wLRnl8Dy5eV1qd474uM92uOnOG3v2+AlutjC7MPZEp+Dwa8ruXeeOaCk
        VKivcU+JpTgj0VCLuag4EQCIYShIFAQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d
References: <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
        <20221104170422.979558-1-dvyukov@google.com>
        <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p6>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 3:38 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> On Sun, 6 Nov 2022 at 18:46, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> >
> > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > The current virtual nci driver is great for testing and fuzzing.
> > > But it allows to create at most one "global" device which does not allow
> > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > Restructure the driver to allow creation of multiple independent devices.
> > > This should be backwards compatible for existing tests.
> >
> > I totally agree with you for parallel tests and good design.
> > Thanks for good idea.
> > But please check the abnormal situation.
> > for example virtual device app is closed(virtual_ncidev_close) first and then
> > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> 
> I assumed nci core must stop calling into a driver at some point
> during the driver destruction. And I assumed that point is return from
> nci_unregister_device(). Basically when nci_unregister_device()
> returns, no new calls into the driver must be made. Calling into a
> driver after nci_unregister_device() looks like a bug in nci core.
> 
> If this is not true, how do real drivers handle this? They don't use
> global vars. So they should either have the same use-after-free bugs
> you described, or they handle shutdown differently. We just need to do
> the same thing that real drivers do.
> 
> As far as I see they are doing the same what I did in this patch:
> https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> 
> They call nci_unregister_device() and then free all resources:
> https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> 
> What am I missing here?

I'm not sure but I think they are little different.
nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
But virtual_ncidev just uses file operation(close function) not related to driver.
so Nci simulation App can call close function at any time.
If Scheduler interrupts the nci core code right after calling virtual_nci_send and then 
other process or thread calls virtual_nci_dev's close function,
we need to handle this problem in virtual nci driver.

> > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > Cc: netdev@vger.kernel.org
> > >
> > > ---
> > > Changes in v3:
> > >  - free vdev in virtual_ncidev_close()
> > >
> > > Changes in v2:
> > >  - check return value of skb_clone()
> > >  - rebase onto currnet net-next
> > > ---
> > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > >
> > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > --- a/drivers/nfc/virtual_ncidev.c
> > > +++ b/drivers/nfc/virtual_ncidev.c
> > > @@ -13,12 +13,6 @@
> > >
> > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > >  {
> > > -     mutex_lock(&nci_mutex);
> > > -     if (state != virtual_ncidev_enabled) {
> > > -             mutex_unlock(&nci_mutex);
> > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > +
> > > +     mutex_lock(&vdev->mtx);
> >
> >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> >
> > > +     if (vdev->send_buff) {
> > > +             mutex_unlock(&vdev->mtx);
> > >               kfree_skb(skb);
> > > -             return 0;
> > > +             return -1;
> > >       }
> > >
> > >
> > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > >  {
> > > -     mutex_lock(&nci_mutex);
> > > -
> > > -     if (state == virtual_ncidev_enabled) {
> > > -             state = virtual_ncidev_disabling;
> > > -             mutex_unlock(&nci_mutex);
> > > +     struct virtual_nci_dev *vdev = file->private_data;
> > >
> > > -             nci_unregister_device(ndev);
> > > -             nci_free_device(ndev);
> > > -
> > > -             mutex_lock(&nci_mutex);
> > > -     }
> > > -
> > > -     state = virtual_ncidev_disabled;
> > > -     mutex_unlock(&nci_mutex);
> > > +     nci_unregister_device(vdev->ndev);
> > > +     nci_free_device(vdev->ndev);
> > > +     mutex_destroy(&vdev->mtx);
> > > +     kfree(vdev);
> > >
> > >       return 0;
> > >  }
