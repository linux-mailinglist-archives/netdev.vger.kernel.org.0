Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD706220DA
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKIAfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 19:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKIAfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:35:03 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5A05C742
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 16:35:01 -0800 (PST)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221109003458epoutp01d215e5bebd97932abf899ec00b9f7439~lw2pRVCuD2092020920epoutp017
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 00:34:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221109003458epoutp01d215e5bebd97932abf899ec00b9f7439~lw2pRVCuD2092020920epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667954098;
        bh=yYNX0hx18EQO9UH2n83kcRGYZBecpuyIWIp/crBu1pA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=bhh9UEi64AgdMmRopI7Hm941/avP6mek0fhxMlKg9VHCGEWlrQi7NOqE6vgZ70/Iq
         grTqnHtFhwucEfb7pDcbQs6IFUzdUM81Bu9rvjDpoTrIOweopdJ+Wzm6i7TtbL1tkn
         C/+VQZKyL7nYlqZ2Rk0qmK8NE7qAOF1BdlYZZNh4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20221109003457epcas2p2a53f02956113e3e7edb282eca5242343~lw2oyC83t1627516275epcas2p2x;
        Wed,  9 Nov 2022 00:34:57 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.98]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N6QwK2lhrz4x9Q7; Wed,  9 Nov
        2022 00:34:57 +0000 (GMT)
X-AuditID: b6c32a46-85fff70000012ff6-45-636af5b1c1ca
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.55.12278.1B5FA636; Wed,  9 Nov 2022 09:34:57 +0900 (KST)
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
In-Reply-To: <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
Date:   Wed, 09 Nov 2022 09:34:57 +0900
X-CMS-MailID: 20221109003457epcms2p558755edeebc687dba23195ce5b1935c7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTQnfj16xkg6mThC22NE9it5jwsI3d
        Yu/rrewWU34tZbY4tkDM4sibbmYHNo8Fm0o99kw8yeaxaVUnm8eda3vYPPq2rGL0+LxJLoAt
        KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gIJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BeYFecWJucWleul5eaomVoYGBkSlQYUJ2
        xs6mlewFf40qOrbNZ21gfKXWxcjJISFgIjH3ah9rFyMXh5DADkaJK23PmLsYOTh4BQQl/u4Q
        BqkRFgiR2PP9LBuILSSgKPG/4xwbRFxX4sXfo2A2m4C2xNqjjUwgtoiAv8TKE2vAZjIL3GOU
        WPfxEjvEMl6JGe1PWSBsaYnty7cygticAoESGxqms0LENSR+LOtlhrBFJW6ufssOY78/Np8R
        whaRaL13FqpGUOLBz91QcSmJTw/PQM3Jl3i5q4MNwi6ReHxmEVS9ucSeN7vYIH70lbh0RBsk
        zCKgKvH0wztGkLCEgIvEipkRIGFmAXmJ7W/ngEOEWUBTYv0ufYgKZYkjt1ggKvgkOg7/hftv
        x7wnTBC2qkRv8xcmmF8nz26ButFD4vay/6wTGBVnIYJ5FpJdsxB2LWBkXsUollpQnJueWmxU
        YASP2eT83E2M4MSo5baDccrbD3qHGJk4GA8xSnAwK4nwrlmXlSzEm5JYWZValB9fVJqTWnyI
        0RToyYnMUqLJ+cDUnFcSb2hiaWBiZmZobmRqYK4kzts1QytZSCA9sSQ1OzW1ILUIpo+Jg1Oq
        geloRvOs3xzTl745F6x2vERVZwbzvL0XVGZMZfxYOV+fedWamPX+N3eceN/Ysv/ijZW2Fj5M
        J/am7ObZJ3hP7X3lZs59Dmvvl5zYbxxy75vsAnsb8w2WZ094SfDv/DZBXOCpzYciK4aDV8+e
        bHDtsBQUtstMaXjmGz5Zp/DM9yklLW91P2i+efAlIKyrJFcp5J5UsX5bkYNud+uLBwaex9NO
        izDzPWgMnbpRrujpPW6h9gNeO4u3iFXsVbzL8IR7xYIjH5N9IqJdXVkuLGboUOf/71PLsJdb
        U5jrVbf+zJVmq5IvioQclwuct3PG4YqbYgmv5Az+3N+YtiB1X++bwGm3+FcyLbF6/CJ4s3Zm
        ML8SS3FGoqEWc1FxIgCdlYtzFQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d
References: <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
        <20221104170422.979558-1-dvyukov@google.com>
        <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
        <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
        <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p5>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 7:52 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> On Mon, 7 Nov 2022 at 16:43, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> >
> > On Tue, Nov 8, 2022 at 3:38 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > On Sun, 6 Nov 2022 at 18:46, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > > >
> > > > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > > > The current virtual nci driver is great for testing and fuzzing.
> > > > > But it allows to create at most one "global" device which does not allow
> > > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > > Restructure the driver to allow creation of multiple independent devices.
> > > > > This should be backwards compatible for existing tests.
> > > >
> > > > I totally agree with you for parallel tests and good design.
> > > > Thanks for good idea.
> > > > But please check the abnormal situation.
> > > > for example virtual device app is closed(virtual_ncidev_close) first and then
> > > > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > > > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > > > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> > >
> > > I assumed nci core must stop calling into a driver at some point
> > > during the driver destruction. And I assumed that point is return from
> > > nci_unregister_device(). Basically when nci_unregister_device()
> > > returns, no new calls into the driver must be made. Calling into a
> > > driver after nci_unregister_device() looks like a bug in nci core.
> > >
> > > If this is not true, how do real drivers handle this? They don't use
> > > global vars. So they should either have the same use-after-free bugs
> > > you described, or they handle shutdown differently. We just need to do
> > > the same thing that real drivers do.
> > >
> > > As far as I see they are doing the same what I did in this patch:
> > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> > >
> > > They call nci_unregister_device() and then free all resources:
> > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> > >
> > > What am I missing here?
> >
> > I'm not sure but I think they are little different.
> > nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
> > But virtual_ncidev just uses file operation(close function) not related to driver.
> > so Nci simulation App can call close function at any time.
> > If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
> > other process or thread calls virtual_nci_dev's close function,
> > we need to handle this problem in virtual nci driver.
> 
> Won't the same issue happen if nci send callback is concurrent with
> USB/I2C driver disconnect?
> 
> I mean something internal to the USB subsystem cannot affect what nci
> subsystem is doing, unless the USB driver calls into nci and somehow
> notifies it that it's about to destroy the driver.
> 
> Is there anything USB/I2C drivers are doing besides calling
> nci_unregister_device() to ensure that there are no pending nci send
> calls? If yes, then we should do the same in the virtual driver. If
> not, then all other drivers are the subject to the same use-after-free
> bug.
> 
> But I assumed that nci_unregister_device() ensures that there are no
> in-flight send calls and no future send calls will be issued after the
> function returns.

Ok, I understand your mention. you mean that nci_unregister_device should prevent 
the issue using dev lock or other way. right?
It would be better to handle the issue in nci core if there is.

> 
> > > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > > Cc: netdev@vger.kernel.org
> > > > >
> > > > > ---
> > > > > Changes in v3:
> > > > >  - free vdev in virtual_ncidev_close()
> > > > >
> > > > > Changes in v2:
> > > > >  - check return value of skb_clone()
> > > > >  - rebase onto currnet net-next
> > > > > ---
> > > > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > > > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > > > >
> > > > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > > > --- a/drivers/nfc/virtual_ncidev.c
> > > > > +++ b/drivers/nfc/virtual_ncidev.c
> > > > > @@ -13,12 +13,6 @@
> > > > >
> > > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > > >  {
> > > > > -     mutex_lock(&nci_mutex);
> > > > > -     if (state != virtual_ncidev_enabled) {
> > > > > -             mutex_unlock(&nci_mutex);
> > > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > > > +
> > > > > +     mutex_lock(&vdev->mtx);
> > > >
> > > >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> > > >
> > > > > +     if (vdev->send_buff) {
> > > > > +             mutex_unlock(&vdev->mtx);
> > > > >               kfree_skb(skb);
> > > > > -             return 0;
> > > > > +             return -1;
> > > > >       }
> > > > >
> > > > >
> > > > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > > > >  {
> > > > > -     mutex_lock(&nci_mutex);
> > > > > -
> > > > > -     if (state == virtual_ncidev_enabled) {
> > > > > -             state = virtual_ncidev_disabling;
> > > > > -             mutex_unlock(&nci_mutex);
> > > > > +     struct virtual_nci_dev *vdev = file->private_data;
> > > > >
> > > > > -             nci_unregister_device(ndev);
> > > > > -             nci_free_device(ndev);
> > > > > -
> > > > > -             mutex_lock(&nci_mutex);
> > > > > -     }
> > > > > -
> > > > > -     state = virtual_ncidev_disabled;
> > > > > -     mutex_unlock(&nci_mutex);
> > > > > +     nci_unregister_device(vdev->ndev);
> > > > > +     nci_free_device(vdev->ndev);
> > > > > +     mutex_destroy(&vdev->mtx);
> > > > > +     kfree(vdev);
> > > > >
> > > > >       return 0;
> > > > >  }
> 
