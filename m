Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D1123A0FA
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgHCI0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHCI0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 04:26:31 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA049C06174A;
        Mon,  3 Aug 2020 01:26:30 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d14so34413466qke.13;
        Mon, 03 Aug 2020 01:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zMAKXCwpjk/M1ee/TFS2x2huVLNZMq4N2Rp0iTVZNjg=;
        b=gEdu+rqa45mywu49q8wrCUvSkUqQiQKuw+ZDUuL8isP/amM0IgvMg4DRSQeLqmThIq
         8/MJ9HFnVabE37NqUx3K3dz/eLp/YxvHULzH+YM3WKJxof3priDRSgfzOTNWo5fzzNXY
         v7QyXERvbvANuR7XzsvlRvbIqfP7pCs9M5ZmRSalmvpAG7nmT0pcMlocTkmwtsVC1HNu
         Vm1DOidNctGSXx2S0OXXYkKXngovHEyowkrP6302Y6ypnZgd/DKGgzYUd3kkUpONZLD0
         Fu7VHPn4k1RGR0SgUjoeCrolBTFZcvKtDOgGGJr3fSRAUI6O4aXj6zisL0A//Gaoh7qi
         191w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zMAKXCwpjk/M1ee/TFS2x2huVLNZMq4N2Rp0iTVZNjg=;
        b=lFCKrYUsBfNaUQkFG8OrT6AlwDY7VDvCVbEi5Rtgry1vo7OeYusLDHk4DXUrhQBZfx
         3NXu/KvVsJK98f9mhv6WqE74h5Mjjquh1kQTTnLpjSN1YyGBKzTP38TYNIyCYGkaR7xX
         DBL4KzD4dvBf1yDYR5K0ssc2RQdNN77bKDT+WrMSeouN6Y98AWW/XnYxX2iG1iKSCvUw
         McbeC68Z+2rmmWpAljcu15XuYYJ5hvzSscZNgYZn5FtPmPcGUyZj6vFuMvm8GolUgP/Z
         O3lfiIIOr8bU3RcygS/vafCCzC9mXQGh9h/DiAGD3eFyqicxjqHGhG5tGgexZA2Sh3Q0
         RHyQ==
X-Gm-Message-State: AOAM533qanTxm/CiM6nFeppM4FtiwdG68/dP8XfAcMZKbLqo4KncS24w
        Ug5C5BndxtyuQfqDJ0gDvHkmL+2vLzNXcZnGIfN9MlZp
X-Google-Smtp-Source: ABdhPJzwqUXgMfEogucuJJhDaPrfMMO3vaCECekOSQ+MevzxKBugSycI1HERJxqq6hKh4bMM7kxZVgtEm91kRu4KIEc=
X-Received: by 2002:a37:9b91:: with SMTP id d139mr14214072qke.377.1596443190069;
 Mon, 03 Aug 2020 01:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200803065105.8997-1-yzc666@netease.com> <20200803081604.GC493272@kroah.com>
In-Reply-To: <20200803081604.GC493272@kroah.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 3 Aug 2020 10:26:18 +0200
Message-ID: <CAGRyCJE-BF=0tWakreObGv-skahDp-ui8zP1TPPkX48sMFk4-w@mail.gmail.com>
Subject: Re: [PATCH] qmi_wwan: support modify usbnet's rx_urb_size
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     yzc666@netease.com, =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>,
        carl <carl.yin@quectel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Il giorno lun 3 ago 2020 alle ore 10:18 Greg KH
<gregkh@linuxfoundation.org> ha scritto:
>
> On Mon, Aug 03, 2020 at 02:51:05PM +0800, yzc666@netease.com wrote:
> > From: carl <carl.yin@quectel.com>
> >
> >     When QMUX enabled, the 'dl-datagram-max-size' can be 4KB/16KB/31KB depend on QUALCOMM's chipsets.
> >     User can set 'dl-datagram-max-size' by 'QMI_WDA_SET_DATA_FORMAT'.
> >     The usbnet's rx_urb_size must lager than or equal to the 'dl-datagram-max-size'.
> >     This patch allow user to modify usbnet's rx_urb_size by next command.
> >
> >               echo 4096 > /sys/class/net/wwan0/qmi/rx_urb_size
> >
> >               Next commnds show how to set and query 'dl-datagram-max-size' by qmicli
> >               # qmicli -d /dev/cdc-wdm1 --wda-set-data-format="link-layer-protocol=raw-ip, ul-protocol=qmap,
> >                               dl-protocol=qmap, dl-max-datagrams=32, dl-datagram-max-size=31744, ep-type=hsusb, ep-iface-number=4"
> >               [/dev/cdc-wdm1] Successfully set data format
> >                                       QoS flow header: no
> >                                   Link layer protocol: 'raw-ip'
> >                      Uplink data aggregation protocol: 'qmap'
> >                    Downlink data aggregation protocol: 'qmap'
> >                                         NDP signature: '0'
> >               Downlink data aggregation max datagrams: '10'
> >                    Downlink data aggregation max size: '4096'
> >
> >           # qmicli -d /dev/cdc-wdm1 --wda-get-data-format
> >               [/dev/cdc-wdm1] Successfully got data format
> >                                  QoS flow header: no
> >                              Link layer protocol: 'raw-ip'
> >                 Uplink data aggregation protocol: 'qmap'
> >               Downlink data aggregation protocol: 'qmap'
> >                                    NDP signature: '0'
> >               Downlink data aggregation max datagrams: '10'
> >               Downlink data aggregation max size: '4096'
> >
> > Signed-off-by: carl <carl.yin@quectel.com>
> > ---
> >  drivers/net/usb/qmi_wwan.c | 39 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 07c42c0719f5b..8ea57fd99ae43 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -400,6 +400,44 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
> >       return ret;
> >  }
> >
> > +static ssize_t rx_urb_size_show(struct device *d, struct device_attribute *attr, char *buf)
> > +{
> > +     struct usbnet *dev = netdev_priv(to_net_dev(d));
> > +
> > +     return sprintf(buf, "%zd\n", dev->rx_urb_size);
>
> Why do you care about this?
>
> > +}
> > +
> > +static ssize_t rx_urb_size_store(struct device *d,  struct device_attribute *attr,
> > +                              const char *buf, size_t len)
> > +{
> > +     struct usbnet *dev = netdev_priv(to_net_dev(d));
> > +     u32 rx_urb_size;
> > +     int ret;
> > +
> > +     if (kstrtou32(buf, 0, &rx_urb_size))
> > +             return -EINVAL;
> > +
> > +     /* no change? */
> > +     if (rx_urb_size == dev->rx_urb_size)
> > +             return len;
> > +
> > +     if (!rtnl_trylock())
> > +             return restart_syscall();
> > +
> > +     /* we don't want to modify a running netdev */
> > +     if (netif_running(dev->net)) {
> > +             netdev_err(dev->net, "Cannot change a running device\n");
> > +             ret = -EBUSY;
> > +             goto err;
> > +     }
> > +
> > +     dev->rx_urb_size = rx_urb_size;
> > +     ret = len;
> > +err:
> > +     rtnl_unlock();
> > +     return ret;
> > +}
> > +
> >  static ssize_t add_mux_show(struct device *d, struct device_attribute *attr, char *buf)
> >  {
> >       struct net_device *dev = to_net_dev(d);
> > @@ -505,6 +543,7 @@ static DEVICE_ATTR_RW(add_mux);
> >  static DEVICE_ATTR_RW(del_mux);
> >
> >  static struct attribute *qmi_wwan_sysfs_attrs[] = {
> > +     &dev_attr_rx_urb_size.attr,
>
> You added a driver-specific sysfs file and did not document in in
> Documentation/ABI?  That's not ok, sorry, please fix up.
>
> Actually, no, this all should be done "automatically", do not change the
> urb size on the fly.  Change it at probe time based on the device you
> are using, do not force userspace to "know" what to do here, as it will
> not know that at all.
>

the problem with doing at probe time is that rx_urb_size is not fixed,
but depends on the configuration done at the userspace level with
QMI_WDA_SET_DATA_FORMAT, so the userspace knows that.

Currently there's a workaround for setting rx_urb_size i.e. changing
the network interface MTU: this is fine for most uses with qmap, but
there's the limitation that certain values (multiple of the endpoint
size) are not allowed.

Thanks,
Daniele

> thanks,
>
> greg k-h
