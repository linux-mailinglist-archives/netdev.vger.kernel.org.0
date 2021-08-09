Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F2B3E4EA7
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhHIVl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:41:28 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49171 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhHIVl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 17:41:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628545265; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=f2tkS2Mofmv3XLFarN8UyJyv3rXNIvO7YZsDauoNs3Y=;
 b=H/5pgjr3Nr4CsjgqWgppJkNDwz4xQqcW2hDQIaLd92sDV2JgHGZGF8kJ+gkkShJ9V2dCAchB
 g4nIx44NHJpw007QDPZvpLIuNjfLTzaQXjxy9Tpt5cC8yAOEihV+Dg0WwtJn4kX+MdGwGkj2
 JiLgN5gen+dOUESfNxQ7+zr8KFQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6111a0db91487ad520934d62 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Aug 2021 21:40:43
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 87AA0C433F1; Mon,  9 Aug 2021 21:40:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A6837C433F1;
        Mon,  9 Aug 2021 21:40:41 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Aug 2021 15:40:41 -0600
From:   subashab@codeaurora.org
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <87sfzlplr2.fsf@miraculix.mork.no>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
 <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
 <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
 <87bl6aqrat.fsf@miraculix.mork.no>
 <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
 <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
 <87sfzlplr2.fsf@miraculix.mork.no>
Message-ID: <394353d6f31303c64b0d26bc5268aca7@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No need for () around a constant, is there?
> 
> Either I'm blind, or you don't actuelly change the rx_urb_size for the
> mux and pass through modes?
> 

I seem to have missed this and the other stuff you have pointed out.
Can you please review this update-

> 
> I'd also prefer this to reset back to syncing with hard_mtu if/when
> muxing or passthrough is disabled.  Calling usbnet_change_mtu() won't 
> do
> that. It doesn't touch rx_urb_size if it is different from hard_mtu.
> 
> I also think that it might be useful to keep the mtu/hard_mtu control,
> wouldn't it?
> 
> 
> Something like
> 
>    old_rx_urb_size = dev->rx_urb_size;
>    if (mux|passthrough)
>        dev->rx_urb_size = MAP_DL_URB_SIZE;
>    else
>        dev->rx_urb_size = dev->hard_mtu;
>    if (dev->rx_urb_size > old_rx_urb_size)
>        unlink_urbs etc;
>    return usbnet_change_mtu(net, new_mtu);
> 
> should do that, I think.  Completely untested....
> 
> And add it to the (!qmimux_has_slaves(dev)) cas in del_mux_store() too.
> 

Assuming this patch doesn't have too many other issues, can I request
Aleksander / Daniele to try this out.

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6a2e4f8..4676544 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -75,6 +75,8 @@ struct qmimux_priv {
         u8 mux_id;
  };

+#define MAP_DL_URB_SIZE 32768
+
  static int qmimux_open(struct net_device *dev)
  {
         struct qmimux_priv *priv = netdev_priv(dev);
@@ -303,6 +305,39 @@ static void qmimux_unregister_device(struct 
net_device *dev,
         dev_put(real_dev);
  }

+static int qmi_wwan_change_mtu(struct net_device *net, int new_mtu)
+{
+       struct usbnet *dev = netdev_priv(net);
+       struct qmi_wwan_state *info = (void *)&dev->data;
+       int old_rx_urb_size = dev->rx_urb_size;
+
+       /* mux and pass through modes use a fixed rx_urb_size and the 
value
+        * is independent of mtu
+        */
+       if (info->flags & (QMI_WWAN_FLAG_MUX | 
QMI_WWAN_FLAG_PASS_THROUGH)) {
+               if (old_rx_urb_size == MAP_DL_URB_SIZE)
+                       return 0;
+
+               if (old_rx_urb_size < MAP_DL_URB_SIZE) {
+                       dev->rx_urb_size = MAP_DL_URB_SIZE;
+
+                       usbnet_pause_rx(dev);
+                       usbnet_unlink_rx_urbs(dev);
+                       usbnet_resume_rx(dev);
+                       usbnet_update_max_qlen(dev);
+               }
+
+               return 0;
+       }
+
+       /* rawip mode uses existing logic of setting rx_urb_size based 
on mtu.
+        * rx_urb_size will be updated within usbnet_change_mtu only if 
it is
+        * equal to existing hard_mtu
+        */
+       dev->rx_urb_size = dev->hard_mtu;
+       return usbnet_change_mtu(net, new_mtu);
+}
+
  static void qmi_wwan_netdev_setup(struct net_device *net)
  {
         struct usbnet *dev = netdev_priv(net);
@@ -326,7 +361,7 @@ static void qmi_wwan_netdev_setup(struct net_device 
*net)
         }

         /* recalculate buffers after changing hard_header_len */
-       usbnet_change_mtu(net, net->mtu);
+       qmi_wwan_change_mtu(net, net->mtu);
  }

  static ssize_t raw_ip_show(struct device *d, struct device_attribute 
*attr, char *buf)
@@ -433,6 +468,7 @@ static ssize_t add_mux_store(struct device *d,  
struct device_attribute *attr, c
         if (!ret) {
                 info->flags |= QMI_WWAN_FLAG_MUX;
                 ret = len;
+               qmi_wwan_change_mtu(dev->net, dev->net->mtu);
         }
  err:
         rtnl_unlock();
@@ -466,8 +502,11 @@ static ssize_t del_mux_store(struct device *d,  
struct device_attribute *attr, c
         }
         qmimux_unregister_device(del_dev, NULL);

-       if (!qmimux_has_slaves(dev))
+       if (!qmimux_has_slaves(dev)) {
                 info->flags &= ~QMI_WWAN_FLAG_MUX;
+               qmi_wwan_change_mtu(dev->net, dev->net->mtu);
+       }
+
         ret = len;
  err:
         rtnl_unlock();
@@ -514,6 +553,8 @@ static ssize_t pass_through_store(struct device *d,
         else
                 info->flags &= ~QMI_WWAN_FLAG_PASS_THROUGH;

+       qmi_wwan_change_mtu(dev->net, dev->net->mtu);
+
         return len;
  }

@@ -643,7 +684,7 @@ static const struct net_device_ops 
qmi_wwan_netdev_ops = {
         .ndo_stop               = usbnet_stop,
         .ndo_start_xmit         = usbnet_start_xmit,
         .ndo_tx_timeout         = usbnet_tx_timeout,
-       .ndo_change_mtu         = usbnet_change_mtu,
+       .ndo_change_mtu         = qmi_wwan_change_mtu,
         .ndo_get_stats64        = dev_get_tstats64,
         .ndo_set_mac_address    = qmi_wwan_mac_addr,
         .ndo_validate_addr      = eth_validate_addr,
