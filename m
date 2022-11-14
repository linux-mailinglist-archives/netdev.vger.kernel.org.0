Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09E4627A3D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiKNKOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiKNKOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:14:22 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B274D1FA
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:13:23 -0800 (PST)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221114101319epoutp03ff65f0d92e48f793ac6ea058d2c360ea~na_CMvn8r2273322733epoutp03b
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 10:13:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221114101319epoutp03ff65f0d92e48f793ac6ea058d2c360ea~na_CMvn8r2273322733epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668420799;
        bh=54FAW0s/JHBSC0+QbmCy6nVHY6Ph8FHnqQ1/Z+on7yo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=vPBQwCUv/2zTq3/cNfyOhzYnRNt/OE36tIwIIIItaKpocjaHSr7deKvb9XD6MCe47
         nk2ATubTCcZmbQnq4ffb/XcaTYDfLzTz+DIDPmXbnJfgYGBHZwVlti/e5UdzDSF7Pc
         GMEcLLeflE+LmRC3DT6ws/f7F6UG9h34t13DG/6g=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20221114101318epcas2p3cb38c46036e5874f12573d6b8a9f01de~na_B_tPgT3265032650epcas2p3S;
        Mon, 14 Nov 2022 10:13:18 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.97]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N9lWL329fz4x9Pt; Mon, 14 Nov
        2022 10:13:18 +0000 (GMT)
X-AuditID: b6c32a48-8a7fa7000001494a-4e-637214be7253
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.A6.18762.EB412736; Mon, 14 Nov 2022 19:13:18 +0900 (KST)
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
In-Reply-To: <CACT4Y+ZuBJbooj6OLj9drHY6cB7pix1Osk0AUXdtG3G+SdqVFA@mail.gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221114101318epcms2p7fb5585f189a480717a80518ef1a8b8ba@epcms2p7>
Date:   Mon, 14 Nov 2022 19:13:18 +0900
X-CMS-MailID: 20221114101318epcms2p7fb5585f189a480717a80518ef1a8b8ba
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdljTXHefSFGywby/IhZbmiexW0x42MZu
        sff1VnaLKb+WMlscWyBmceRNN7MDm8eCTaUeeyaeZPPYtKqTzePOtT1sHn1bVjF6fN4kF8AW
        lW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SEkkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafAvECvODG3uDQvXS8vtcTK0MDAyBSoMCE7
        Y9vbmcwFq50qNv7tZmlgvGHQxcjJISFgIrF601yWLkYuDiGBHYwSb5bMZ+pi5ODgFRCU+LtD
        GKRGWCBEYs/3s2wgtpCAosT/jnNsEHFdiRd/j4LZbALaEmuPNjKB2CIC/hIrT6xhBZnJLHCP
        UWLdx0vsEMt4JWa0P2WBsKUlti/fyghicwoESky+f4kZIq4h8WNZL5QtKnFz9Vt2GPv9sfmM
        ELaIROu9s1A1ghIPfu6GiktJfHp4hhXCzpd4uauDDcIukXh8ZhFUvbnEnje7wOK8Ar4SXTvf
        gt3DIqAq8ffIW6h6F4nJn46B2cwC8hLb385hBoUJs4CmxPpd+iCmhICyxJFbLBAVfBIdh//C
        fbhj3hMmCFtVorf5CxPMt5Nnt0Bd6SFxe9l/1gmMirMQAT0Lya5ZCLsWMDKvYhRLLSjOTU8t
        Niowgcdtcn7uJkZwctTy2ME4++0HvUOMTByMhxglOJiVRHjnyeQnC/GmJFZWpRblxxeV5qQW
        H2I0BfpyIrOUaHI+MD3nlcQbmlgamJiZGZobmRqYK4nzds3QShYSSE8sSc1OTS1ILYLpY+Lg
        lGpg0nnPseryXZ2py7YmNyjKbF33deX3E9O2q05bEHRmseBEr5WNfmzPNhmmxF457Lw7a9mq
        1VnuMcuvsqs2f7r/d9LrNY82qW9f4s27cSlL3+EER/t1junrvEUfWEW+kA6qqEr/uFVz+eRf
        AXLyn1h/7HT4vNdcbM/+HYtTbi3hSGp+2Pr2QQ9jSwLbqfqrDZP+/Vz3vq54ocL3tLQdSQkf
        8g9fn7v8y8MXgfY61dq515dKhWTU9G5tu6Me+uxHIfNirUOCPnU862/1ffsge7Rv25PtPQLr
        JhZsWMv7aIuPWHWR1q7JPxm25+7TiK2YJ3boOAPvWbv5XIcOHLU9uN7eb/2O6TfKI+WSfvCY
        3vDTNbZXYinOSDTUYi4qTgQADS3wjhcEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d
References: <CACT4Y+ZuBJbooj6OLj9drHY6cB7pix1Osk0AUXdtG3G+SdqVFA@mail.gmail.com>
        <20221104170422.979558-1-dvyukov@google.com>
        <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
        <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
        <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
        <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
        <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
        <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com>
        <20221113233254epcms2p4a55e241336fd6f5d8868f00f9a8ed3ec@epcms2p4>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p7>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 6:54 PM Dmitry Vyukov<dvyukov@google.com> wrote:
> On Mon, 14 Nov 2022 at 00:32, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > > > > > > > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > > > > > > > The current virtual nci driver is great for testing and fuzzing.
> > > > > > > > > But it allows to create at most one "global" device which does not allow
> > > > > > > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > > > > > > Restructure the driver to allow creation of multiple independent devices.
> > > > > > > > > This should be backwards compatible for existing tests.
> > > > > > > >
> > > > > > > > I totally agree with you for parallel tests and good design.
> > > > > > > > Thanks for good idea.
> > > > > > > > But please check the abnormal situation.
> > > > > > > > for example virtual device app is closed(virtual_ncidev_close) first and then
> > > > > > > > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > > > > > > > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > > > > > > > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> > > > > > >
> > > > > > > I assumed nci core must stop calling into a driver at some point
> > > > > > > during the driver destruction. And I assumed that point is return from
> > > > > > > nci_unregister_device(). Basically when nci_unregister_device()
> > > > > > > returns, no new calls into the driver must be made. Calling into a
> > > > > > > driver after nci_unregister_device() looks like a bug in nci core.
> > > > > > >
> > > > > > > If this is not true, how do real drivers handle this? They don't use
> > > > > > > global vars. So they should either have the same use-after-free bugs
> > > > > > > you described, or they handle shutdown differently. We just need to do
> > > > > > > the same thing that real drivers do.
> > > > > > >
> > > > > > > As far as I see they are doing the same what I did in this patch:
> > > > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> > > > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> > > > > > >
> > > > > > > They call nci_unregister_device() and then free all resources:
> > > > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> > > > > > >
> > > > > > > What am I missing here?
> > > > > >
> > > > > > I'm not sure but I think they are little different.
> > > > > > nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
> > > > > > But virtual_ncidev just uses file operation(close function) not related to driver.
> > > > > > so Nci simulation App can call close function at any time.
> > > > > > If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
> > > > > > other process or thread calls virtual_nci_dev's close function,
> > > > > > we need to handle this problem in virtual nci driver.
> > > > >
> > > > > Won't the same issue happen if nci send callback is concurrent with
> > > > > USB/I2C driver disconnect?
> > > > >
> > > > > I mean something internal to the USB subsystem cannot affect what nci
> > > > > subsystem is doing, unless the USB driver calls into nci and somehow
> > > > > notifies it that it's about to destroy the driver.
> > > > >
> > > > > Is there anything USB/I2C drivers are doing besides calling
> > > > > nci_unregister_device() to ensure that there are no pending nci send
> > > > > calls? If yes, then we should do the same in the virtual driver. If
> > > > > not, then all other drivers are the subject to the same use-after-free
> > > > > bug.
> > > > >
> > > > > But I assumed that nci_unregister_device() ensures that there are no
> > > > > in-flight send calls and no future send calls will be issued after the
> > > > > function returns.
> > > >
> > > > Ok, I understand your mention. you mean that nci_unregister_device should prevent
> > > > the issue using dev lock or other way. right?
> > >
> > > Yes.
> > >
> > > > It would be better to handle the issue in nci core if there is.
> > >
> > > And yes.
> > >
> > > Krzysztof, can you confirm this is the case (nci core won't call
> > > ops->send callback after nci_unregister_device() returns)?
> >
> > I think we can add this to selftest to verify nci core.
> 
> I am not sure how the test for that particular scenario should look
> like. It's only possible with concurrent syscalls, right? After
> nci_unregister_device() returns and the virtual device fd is closed,
> it's not possible to trigger the send callback, right?
> 

As you think, we can't control concurrent timing so that it will be hard to
test exactly same scenario that i asked first.
I just wanted to see the simple scenario testcase with single thread.
I thought following simple sequence.

1. virtualDevFd = open() // for virtual device 
2. enable and open nci dev and connect NFC socket with virtualDevFd using NFC/NCI System Call
3. close virtualDevFd.( nci_unregister_device )
4. send test data using connected NFC socket.
=> if socket write operation failed and there were no issues in kernel, then it works properly.

> 
> > > > > > > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > > > > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > > > > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > > > > > > Cc: netdev@vger.kernel.org
> > > > > > > > >
> > > > > > > > > ---
> > > > > > > > > Changes in v3:
> > > > > > > > >  - free vdev in virtual_ncidev_close()
> > > > > > > > >
> > > > > > > > > Changes in v2:
> > > > > > > > >  - check return value of skb_clone()
> > > > > > > > >  - rebase onto currnet net-next
> > > > > > > > > ---
> > > > > > > > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > > > > > > > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > > > > > > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > > > > > > > --- a/drivers/nfc/virtual_ncidev.c
> > > > > > > > > +++ b/drivers/nfc/virtual_ncidev.c
> > > > > > > > > @@ -13,12 +13,6 @@
> > > > > > > > >
> > > > > > > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > > > > > > >  {
> > > > > > > > > -     mutex_lock(&nci_mutex);
> > > > > > > > > -     if (state != virtual_ncidev_enabled) {
> > > > > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > > > > > > > +
> > > > > > > > > +     mutex_lock(&vdev->mtx);
> > > > > > > >
> > > > > > > >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> > > > > > > >
> > > > > > > > > +     if (vdev->send_buff) {
> > > > > > > > > +             mutex_unlock(&vdev->mtx);
> > > > > > > > >               kfree_skb(skb);
> > > > > > > > > -             return 0;
> > > > > > > > > +             return -1;
> > > > > > > > >       }
> > > > > > > > >
> > > > > > > > >
> > > > > > > > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > > > > > > > >  {
> > > > > > > > > -     mutex_lock(&nci_mutex);
> > > > > > > > > -
> > > > > > > > > -     if (state == virtual_ncidev_enabled) {
> > > > > > > > > -             state = virtual_ncidev_disabling;
> > > > > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > > > > +     struct virtual_nci_dev *vdev = file->private_data;
> > > > > > > > >
> > > > > > > > > -             nci_unregister_device(ndev);
> > > > > > > > > -             nci_free_device(ndev);
> > > > > > > > > -
> > > > > > > > > -             mutex_lock(&nci_mutex);
> > > > > > > > > -     }
> > > > > > > > > -
> > > > > > > > > -     state = virtual_ncidev_disabled;
> > > > > > > > > -     mutex_unlock(&nci_mutex);
> > > > > > > > > +     nci_unregister_device(vdev->ndev);
> > > > > > > > > +     nci_free_device(vdev->ndev);
> > > > > > > > > +     mutex_destroy(&vdev->mtx);
> > > > > > > > > +     kfree(vdev);
> > > > > > > > >
> > > > > > > > >       return 0;
> > > > > > > > >  }
> > > > >
