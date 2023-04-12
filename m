Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDF6E01AF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjDLWI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDLWI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:08:56 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFDE5FCF;
        Wed, 12 Apr 2023 15:08:54 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a3so7939010ljr.11;
        Wed, 12 Apr 2023 15:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681337332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LqNO50peXFsxe6uPYx465Z24ZJ9eZSEghZgNuC6sn4=;
        b=W+FaakmNNSAs/U+6/BouTqJwQcC14ZcNpf7dAzc8JT7ey02BCZ/sZYsCSWn4hbSabN
         YdbB/+JDjUU+VyYRYM2RZYwL68MBDULtOb703tcJjRfVzVeefW7SZWUkcD54QTWe7wiW
         41YrDJQ6C9DCwSWhoFlMWMAeR6zv4DHooAz92BJjAZorogwSiEs2kjhdHt/FV7QGWdMh
         mNVloamv1gHsTsGt7AuOXucLilISNgCNbrrnlDKA3F/QV3cAKQOE3k7shIKVCE8h4j2X
         pF3Y57pWyX3sbD4O5GRGaSbGo1e/yg/kN1yNfG/Rpk8yoX+QvGGaZPBi/emdy615Ybh9
         obqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681337332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2LqNO50peXFsxe6uPYx465Z24ZJ9eZSEghZgNuC6sn4=;
        b=hOXfAgzMFr/f0vgFmf0wH1YkwjTgpsxrfjZZv/6tC1mr2aWZKtI13lKJXt5BgkdZio
         JxYoikbe3AL3NehHmq9ZrPa8NjFX8eeaONAeb2Tn66j2RAzbJpIhrkqVIHyRUdgjNmSS
         cU3/C3bCKp+PsfveB1yB+oJJAQWFR4cX/jRquJe6fQM4Emcfn69jt+VGWPIk4xOVIBHR
         AasaDBWQZoln/lIDwdrXEcoiO0pwu8KFNKSWpZFQgtF5o5YkAafpMcVW0znUXeiDWYy0
         jSmk1xfykIPeghgb0mbE8+CYcQBV5JNJ2bzbp1VL5hDSjB6BAx24q2pILAS0WcULFuII
         5eTw==
X-Gm-Message-State: AAQBX9fP1UatIF01OyIrQ549qib+KBOb5IpSiQq/FtYiTLW9PF56sCKi
        g9oGQ0kZwR0LQ49La8b+rIJbM9doTBLtyTEGSFKAjnXig+A=
X-Google-Smtp-Source: AKy350ZAzL7NHzqR2H5baWznUulETPttgog40CtV65lOnH+5D9MYPldF6NyTmeoCJlU5elGQz5Uf4f6CNcgfq7DTY9U=
X-Received: by 2002:a2e:9d83:0:b0:2a7:8544:1e76 with SMTP id
 c3-20020a2e9d83000000b002a785441e76mr64119ljj.8.1681337332175; Wed, 12 Apr
 2023 15:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230322072712.20829-1-hildawu@realtek.com>
In-Reply-To: <20230322072712.20829-1-hildawu@realtek.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 12 Apr 2023 15:08:39 -0700
Message-ID: <CABBYNZKL2oM9y7+1+U3p-v0GB0FvrB5vkkBEpfbaCfimJEMrKg@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: msft: Extended monitor tracking by address filter
To:     hildawu@realtek.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, apusaka@chromium.org,
        mmandlik@google.com, yinghsu@chromium.org, max.chou@realtek.com,
        alex_lu@realsil.com.cn, kidman@realtek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Mar 22, 2023 at 12:27=E2=80=AFAM <hildawu@realtek.com> wrote:
>
> From: Hilda Wu <hildawu@realtek.com>
>
> Since limited tracking device per condition, this feature is to support
> tracking multiple devices concurrently.
> When a pattern monitor detects the device, this feature issues an address
> monitor for tracking that device. Let pattern monitor can keep monitor
> new devices.
> This feature adds an address filter when receiving a LE monitor device
> event which monitor handle is for a pattern, and the controller started
> monitoring the device. And this feature also has cancelled the monitor
> advertisement from address filters when receiving a LE monitor device
> event when the controller stopped monitoring the device specified by an
> address and monitor handle.
>
> Signed-off-by: Alex Lu <alex_lu@realsil.com.cn>
> Signed-off-by: Hilda Wu <hildawu@realtek.com>
> ---
> Changes in v2:
> - Fixed build bot warning, removed un-used parameter.
> - Follow suggested, adjust for readability and idiomatic, modified
>   error case, etc.
> ---
> ---
>  net/bluetooth/msft.c | 538 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 523 insertions(+), 15 deletions(-)
>
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index bf5cee48916c..82d30e50c5d3 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -91,17 +91,54 @@ struct msft_ev_le_monitor_device {
>  struct msft_monitor_advertisement_handle_data {
>         __u8  msft_handle;
>         __u16 mgmt_handle;
> +       __s8 rssi_high;
> +       __s8 rssi_low;
> +       __u8 rssi_low_interval;
> +       __u8 rssi_sampling_period;
> +       __u8 cond_type;
>         struct list_head list;
>  };
>
> +#define MANUFACTURER_REALTEK   0x005d
> +#define REALTEK_RTL8822C       13
> +#define REALTEK_RTL8852A       18
> +#define REALTEK_RTL8852C       25

This sort of information belongs to the driver.

> +#define MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR   0x04
> +struct msft_monitor_addr_filter_data {
> +       __u8     msft_handle;
> +       __u8     pattern_handle; /* address filters pertain to */
> +       __u16    mgmt_handle;
> +       bool     active;
> +       __s8     rssi_high;
> +       __s8     rssi_low;
> +       __u8     rssi_low_interval;
> +       __u8     rssi_sampling_period;
> +       __u8     addr_type;
> +       bdaddr_t bdaddr;
> +       struct list_head list;
> +};
> +
> +struct addr_filter_skb_cb {
> +       u8       pattern_handle;
> +       u8       addr_type;
> +       bdaddr_t bdaddr;
> +};
> +
> +#define addr_filter_cb(skb) ((struct addr_filter_skb_cb *)((skb)->cb))
> +
>  struct msft_data {
>         __u64 features;
>         __u8  evt_prefix_len;
>         __u8  *evt_prefix;
>         struct list_head handle_map;
> +       struct list_head address_filters;
>         __u8 resuming;
>         __u8 suspending;
>         __u8 filter_enabled;
> +       bool addr_monitor_assist;
> +       /* To synchronize add/remove address filter and monitor device ev=
ent.*/
> +       struct mutex filter_lock;
>  };
>
>  bool msft_monitor_supported(struct hci_dev *hdev)
> @@ -180,6 +217,24 @@ static struct msft_monitor_advertisement_handle_data=
 *msft_find_handle_data
>         return NULL;
>  }
>
> +/* This function requires the caller holds msft->filter_lock */
> +static struct msft_monitor_addr_filter_data *msft_find_address_data
> +                       (struct hci_dev *hdev, u8 addr_type, bdaddr_t *ad=
dr,
> +                        u8 pattern_handle)
> +{
> +       struct msft_monitor_addr_filter_data *entry;
> +       struct msft_data *msft =3D hdev->msft_data;
> +
> +       list_for_each_entry(entry, &msft->address_filters, list) {
> +               if (entry->pattern_handle =3D=3D pattern_handle &&
> +                   addr_type =3D=3D entry->addr_type &&
> +                   !bacmp(addr, &entry->bdaddr))
> +                       return entry;
> +       }
> +
> +       return NULL;
> +}
> +
>  /* This function requires the caller holds hdev->lock */
>  static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_hand=
le,
>                                    bdaddr_t *bdaddr, __u8 addr_type,
> @@ -240,6 +295,7 @@ static int msft_le_monitor_advertisement_cb(struct hc=
i_dev *hdev, u16 opcode,
>
>         handle_data->mgmt_handle =3D monitor->handle;
>         handle_data->msft_handle =3D rp->handle;
> +       handle_data->cond_type   =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_PATT=
ERN;
>         INIT_LIST_HEAD(&handle_data->list);
>         list_add(&handle_data->list, &msft->handle_map);
>
> @@ -254,6 +310,62 @@ static int msft_le_monitor_advertisement_cb(struct h=
ci_dev *hdev, u16 opcode,
>         return status;
>  }
>
> +/* This function requires the caller holds hci_req_sync_lock */
> +static void msft_remove_addr_filters_sync(struct hci_dev *hdev, u8 handl=
e)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter, *n;
> +       struct msft_cp_le_cancel_monitor_advertisement cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct list_head head;
> +       struct sk_buff *skb;
> +
> +       INIT_LIST_HEAD(&head);
> +
> +       /* Cancel all corresponding address monitors */
> +       mutex_lock(&msft->filter_lock);
> +
> +       list_for_each_entry_safe(address_filter, n, &msft->address_filter=
s,
> +                                list) {
> +               if (address_filter->pattern_handle !=3D handle)
> +                       continue;
> +
> +               list_del(&address_filter->list);
> +
> +               /* If the address_filter was added but haven't been enabl=
ed,
> +                * just free it.
> +                */
> +               if (!address_filter->active) {
> +                       kfree(address_filter);
> +                       continue;
> +               }
> +
> +               list_add_tail(&address_filter->list, &head);
> +       }
> +
> +       mutex_unlock(&msft->filter_lock);
> +
> +       list_for_each_entry_safe(address_filter, n, &head, list) {
> +               list_del(&address_filter->list);
> +
> +               cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT=
;
> +               cp.handle =3D address_filter->msft_handle;
> +
> +               skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp=
), &cp,
> +                                    HCI_CMD_TIMEOUT);
> +               if (IS_ERR_OR_NULL(skb)) {
> +                       kfree(address_filter);
> +                       continue;
> +               }
> +
> +               kfree_skb(skb);
> +
> +               bt_dev_info(hdev, "MSFT: Canceled device %pMR address fil=
ter",
> +                           &address_filter->bdaddr);
> +
> +               kfree(address_filter);
> +       }
> +}
> +
>  static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
>                                                    u16 opcode,
>                                                    struct adv_monitor *mo=
nitor,
> @@ -263,6 +375,7 @@ static int msft_le_cancel_monitor_advertisement_cb(st=
ruct hci_dev *hdev,
>         struct msft_monitor_advertisement_handle_data *handle_data;
>         struct msft_data *msft =3D hdev->msft_data;
>         int status =3D 0;
> +       u8 msft_handle;
>
>         rp =3D (struct msft_rp_le_cancel_monitor_advertisement *)skb->dat=
a;
>         if (skb->len < sizeof(*rp)) {
> @@ -293,11 +406,17 @@ static int msft_le_cancel_monitor_advertisement_cb(=
struct hci_dev *hdev,
>                                                 NULL, 0, false);
>                 }
>
> +               msft_handle =3D handle_data->msft_handle;
> +
>                 list_del(&handle_data->list);
>                 kfree(handle_data);
> -       }
>
> -       hci_dev_unlock(hdev);
> +               hci_dev_unlock(hdev);
> +
> +               msft_remove_addr_filters_sync(hdev, msft_handle);
> +       } else {
> +               hci_dev_unlock(hdev);
> +       }
>
>  done:
>         return status;
> @@ -400,6 +519,8 @@ static int msft_add_monitor_sync(struct hci_dev *hdev=
,
>         ptrdiff_t offset =3D 0;
>         u8 pattern_count =3D 0;
>         struct sk_buff *skb;
> +       int err;
> +       struct msft_monitor_advertisement_handle_data *handle_data;
>
>         if (!msft_monitor_pattern_valid(monitor))
>                 return -EINVAL;
> @@ -436,16 +557,31 @@ static int msft_add_monitor_sync(struct hci_dev *hd=
ev,
>
>         skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, total_size, cp,
>                              HCI_CMD_TIMEOUT);
> -       kfree(cp);
>
>         if (IS_ERR_OR_NULL(skb)) {
> -               if (!skb)
> -                       return -EIO;
> -               return PTR_ERR(skb);
> +               err =3D PTR_ERR(skb);
> +               goto out_free;
>         }
>
> -       return msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
> -                                               monitor, skb);
> +       err =3D msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
> +                                              monitor, skb);
> +       if (err)
> +               goto out_free;
> +
> +       handle_data =3D msft_find_handle_data(hdev, monitor->handle, true=
);
> +       if (!handle_data) {
> +               err =3D -ENODATA;
> +               goto out_free;
> +       }
> +
> +       handle_data->rssi_high  =3D cp->rssi_high;
> +       handle_data->rssi_low   =3D cp->rssi_low;
> +       handle_data->rssi_low_interval    =3D cp->rssi_low_interval;
> +       handle_data->rssi_sampling_period =3D cp->rssi_sampling_period;
> +
> +out_free:
> +       kfree(cp);
> +       return err;
>  }
>
>  /* This function requires the caller holds hci_req_sync_lock */
> @@ -497,6 +633,38 @@ int msft_resume_sync(struct hci_dev *hdev)
>         return 0;
>  }
>
> +/* This function requires the caller holds hci_req_sync_lock */
> +static bool msft_address_monitor_assist_realtek(struct hci_dev *hdev)
> +{
> +       struct sk_buff *skb;
> +       bool rc =3D false;
> +       struct {
> +               __u8   status;
> +               __u8   chip_id;
> +       } *rp;
> +
> +       skb =3D __hci_cmd_sync(hdev, 0xfc6f, 0, NULL, HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(skb)) {
> +               bt_dev_err(hdev, "MSFT: Failed to send the cmd 0xfc6f (%l=
d)",
> +                          PTR_ERR(skb));
> +               return false;
> +       }
> +
> +       rp =3D (void *)skb->data;

Why are you not using skb_pull_data here?

> +       if (skb->len < sizeof(*rp) || rp->status)
> +               goto out_free;
> +
> +       if (rp->chip_id =3D=3D REALTEK_RTL8822C ||
> +           rp->chip_id =3D=3D REALTEK_RTL8852A ||
> +           rp->chip_id =3D=3D REALTEK_RTL8852C)
> +               rc =3D true;
> +
> +out_free:
> +       kfree_skb(skb);
> +
> +       return rc;
> +}
> +
>  /* This function requires the caller holds hci_req_sync_lock */
>  void msft_do_open(struct hci_dev *hdev)
>  {
> @@ -518,6 +686,10 @@ void msft_do_open(struct hci_dev *hdev)
>         msft->evt_prefix_len =3D 0;
>         msft->features =3D 0;
>
> +       if (hdev->manufacturer =3D=3D MANUFACTURER_REALTEK)
> +               msft->addr_monitor_assist =3D
> +                       msft_address_monitor_assist_realtek(hdev);

This shall be done in the driver, so either we query the driver via
callback or we have it set some flags that it supports such a feature,
the later sounds cleaner so we don't have to send extra commands every
time the controller is powered up.

>         if (!read_supported_features(hdev, msft)) {
>                 hdev->msft_data =3D NULL;
>                 kfree(msft);
> @@ -538,6 +710,7 @@ void msft_do_close(struct hci_dev *hdev)
>  {
>         struct msft_data *msft =3D hdev->msft_data;
>         struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
> +       struct msft_monitor_addr_filter_data *address_filter, *n;
>         struct adv_monitor *monitor;
>
>         if (!msft)
> @@ -559,6 +732,14 @@ void msft_do_close(struct hci_dev *hdev)
>                 kfree(handle_data);
>         }
>
> +       mutex_lock(&msft->filter_lock);
> +       list_for_each_entry_safe(address_filter, n, &msft->address_filter=
s,
> +                                list) {
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +       }
> +       mutex_unlock(&msft->filter_lock);
> +
>         hci_dev_lock(hdev);
>
>         /* Clear any devices that are being monitored and notify device l=
ost */
> @@ -568,6 +749,58 @@ void msft_do_close(struct hci_dev *hdev)
>         hci_dev_unlock(hdev);
>  }
>
> +static int msft_cancel_address_filter_sync(struct hci_dev *hdev, void *d=
ata)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;
> +       struct msft_cp_le_cancel_monitor_advertisement cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct sk_buff *nskb;
> +       u8 handle =3D PTR_ERR(data);
> +
> +       if (!msft) {
> +               bt_dev_err(hdev, "MSFT: msft data is freed");
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&msft->filter_lock);
> +
> +       list_for_each_entry(address_filter, &msft->address_filters, list)=
 {
> +               if (address_filter->active &&
> +                   handle =3D=3D address_filter->msft_handle) {
> +                       break;
> +               }
> +       }
> +       if (!address_filter) {
> +               bt_dev_warn(hdev, "MSFT: No active addr filter (%u) to ca=
ncel",
> +                           handle);
> +               mutex_unlock(&msft->filter_lock);
> +               return -ENODEV;
> +       }
> +       list_del(&address_filter->list);
> +
> +       mutex_unlock(&msft->filter_lock);
> +
> +       cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
> +       cp.handle =3D address_filter->msft_handle;
> +
> +       nskb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
> +                             HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(nskb)) {
> +               bt_dev_err(hdev, "MSFT: Failed to cancel address (%pMR) f=
ilter",
> +                          &address_filter->bdaddr);
> +               kfree(address_filter);
> +               return -EIO;
> +       }
> +       kfree_skb(nskb);
> +
> +       bt_dev_info(hdev, "MSFT: Canceled device %pMR address filter",
> +                   &address_filter->bdaddr);

Does this really need to be using bt_dev_info? I don't think so, so
please use bt_dev_dbg.

> +       kfree(address_filter);
> +
> +       return 0;
> +}
> +
>  void msft_register(struct hci_dev *hdev)
>  {
>         struct msft_data *msft =3D NULL;
> @@ -581,7 +814,9 @@ void msft_register(struct hci_dev *hdev)
>         }
>
>         INIT_LIST_HEAD(&msft->handle_map);
> +       INIT_LIST_HEAD(&msft->address_filters);
>         hdev->msft_data =3D msft;
> +       mutex_init(&msft->filter_lock);
>  }
>
>  void msft_unregister(struct hci_dev *hdev)
> @@ -596,6 +831,7 @@ void msft_unregister(struct hci_dev *hdev)
>         hdev->msft_data =3D NULL;
>
>         kfree(msft->evt_prefix);
> +       mutex_destroy(&msft->filter_lock);
>         kfree(msft);
>  }
>
> @@ -645,12 +881,235 @@ static void *msft_skb_pull(struct hci_dev *hdev, s=
truct sk_buff *skb,
>         return data;
>  }
>
> +static int msft_add_address_filter_sync(struct hci_dev *hdev, void *data=
)
> +{
> +       struct sk_buff *skb =3D data;
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;
> +       struct sk_buff *nskb;
> +       struct msft_rp_le_monitor_advertisement *rp;
> +       bool remove =3D false;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       int err;
> +
> +       if (!msft) {
> +               bt_dev_err(hdev, "MSFT: msft data is freed");
> +               err =3D -EINVAL;
> +               goto error;
> +       }
> +
> +       mutex_lock(&msft->filter_lock);
> +
> +       address_filter =3D msft_find_address_data(hdev,
> +                                               addr_filter_cb(skb)->addr=
_type,
> +                                               &addr_filter_cb(skb)->bda=
ddr,
> +                                               addr_filter_cb(skb)->patt=
ern_handle);
> +       mutex_unlock(&msft->filter_lock);
> +       if (!address_filter) {
> +               bt_dev_warn(hdev, "MSFT: No address (%pMR) filter to enab=
le",
> +                           &addr_filter_cb(skb)->bdaddr);
> +               err =3D -ENODEV;
> +               goto error;
> +       }
> +
> +send_cmd:
> +       nskb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, skb->len, skb->d=
ata,
> +                             HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(nskb)) {
> +               bt_dev_err(hdev, "Failed to enable address %pMR filter",
> +                          &address_filter->bdaddr);
> +               nskb =3D NULL;
> +               remove =3D true;
> +               goto done;
> +       }
> +
> +       rp =3D (struct msft_rp_le_monitor_advertisement *)nskb->data;
> +       if (nskb->len < sizeof(*rp) ||
> +           rp->sub_opcode !=3D MSFT_OP_LE_MONITOR_ADVERTISEMENT) {
> +               remove =3D true;
> +               goto done;
> +       }
> +
> +       /* If Controller's memory capacity exceeded, cancel the first add=
ress
> +        * filter in the msft->address_filters, then try to add the new a=
ddress
> +        * filter.
> +        */
> +       if (rp->status =3D=3D HCI_ERROR_MEMORY_EXCEEDED) {
> +               struct msft_cp_le_cancel_monitor_advertisement cp;
> +               struct msft_monitor_addr_filter_data *n;
> +               u8 addr_type =3D 0xff;
> +
> +               mutex_lock(&msft->filter_lock);
> +
> +               /* If the current address filter is the first one in
> +                * msft->address_filters, it means no active address filt=
er in
> +                * Controller.
> +                */
> +               if (list_is_first(&address_filter->list,
> +                                 &msft->address_filters)) {
> +                       mutex_unlock(&msft->filter_lock);
> +                       bt_dev_err(hdev, "Memory capacity exceeded");
> +                       remove =3D true;
> +                       goto done;
> +               }
> +
> +               n =3D list_first_entry(&msft->address_filters,
> +                                    struct msft_monitor_addr_filter_data=
,
> +                                    list);
> +               list_del(&n->list);
> +
> +               mutex_unlock(&msft->filter_lock);
> +
> +               cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT=
;
> +               cp.handle =3D n->msft_handle;
> +
> +               nskb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(c=
p), &cp,
> +                                     HCI_CMD_TIMEOUT);
> +               if (IS_ERR_OR_NULL(nskb)) {
> +                       bt_dev_err(hdev, "MSFT: Failed to cancel filter (=
%pMR)",
> +                                  &n->bdaddr);
> +                       kfree(n);
> +                       remove =3D true;
> +                       goto done;
> +               }
> +
> +               /* Fake a device lost event after canceling the correspon=
ding
> +                * address filter.
> +                */
> +               hci_dev_lock(hdev);
> +
> +               switch (n->addr_type) {
> +               case ADDR_LE_DEV_PUBLIC:
> +                       addr_type =3D BDADDR_LE_PUBLIC;
> +                       break;
> +
> +               case ADDR_LE_DEV_RANDOM:
> +                       addr_type =3D BDADDR_LE_RANDOM;
> +                       break;
> +
> +               default:
> +                       bt_dev_err(hdev, "MSFT unknown addr type 0x%02x",
> +                                  n->addr_type);
> +                       break;
> +               }
> +
> +               msft_device_lost(hdev, &n->bdaddr, addr_type,
> +                                n->mgmt_handle);
> +               hci_dev_unlock(hdev);
> +
> +               kfree(n);
> +               kfree_skb(nskb);
> +               goto send_cmd;
> +       } else if (rp->status) {
> +               bt_dev_err(hdev, "Enable address filter err (status 0x%02=
x)",
> +                          rp->status);
> +               remove =3D true;
> +       }
> +
> +done:
> +       kfree_skb(skb);
> +
> +       mutex_lock(&msft->filter_lock);
> +
> +       /* Be careful about address_filter that is not protected by the
> +        * filter_lock while the above __hci_cmd_sync() is running.
> +        */
> +       if (remove) {
> +               bt_dev_warn(hdev, "MSFT: Remove address (%pMR) filter",
> +                           &address_filter->bdaddr);
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +       } else {
> +               address_filter->active =3D true;
> +               address_filter->msft_handle =3D rp->handle;
> +               bt_dev_info(hdev, "MSFT: Address %pMR filter enabled",
> +                           &address_filter->bdaddr);

Ditto, lets use bt_dev_dbg.

> +       }
> +
> +       mutex_unlock(&msft->filter_lock);
> +
> +       kfree_skb(nskb);
> +
> +       return 0;
> +error:
> +       kfree_skb(skb);
> +       return err;
> +}
> +
> +/* This function requires the caller holds msft->filter_lock */
> +static struct msft_monitor_addr_filter_data *msft_add_address_filter
> +               (struct hci_dev *hdev, u8 addr_type, bdaddr_t *bdaddr,
> +                struct msft_monitor_advertisement_handle_data *handle_da=
ta)
> +{
> +       struct sk_buff *skb;
> +       struct msft_cp_le_monitor_advertisement *cp;
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;
> +       size_t size;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       int err;
> +
> +       size =3D sizeof(*cp) + sizeof(addr_type) + sizeof(*bdaddr);
> +       skb =3D alloc_skb(size, GFP_KERNEL);
> +       if (!skb) {
> +               bt_dev_err(hdev, "MSFT: alloc skb err in device evt");
> +               return NULL;
> +       }
> +
> +       cp =3D skb_put(skb, sizeof(*cp));
> +       cp->sub_opcode      =3D MSFT_OP_LE_MONITOR_ADVERTISEMENT;
> +       cp->rssi_high       =3D handle_data->rssi_high;
> +       cp->rssi_low        =3D handle_data->rssi_low;
> +       cp->rssi_low_interval    =3D handle_data->rssi_low_interval;
> +       cp->rssi_sampling_period =3D handle_data->rssi_sampling_period;
> +       cp->cond_type       =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR;
> +       skb_put_u8(skb, addr_type);
> +       skb_put_data(skb, bdaddr, sizeof(*bdaddr));
> +
> +       address_filter =3D kzalloc(sizeof(*address_filter), GFP_KERNEL);
> +       if (!address_filter)
> +               goto err_skb;
> +
> +       address_filter->active               =3D false;
> +       address_filter->msft_handle          =3D 0xff;
> +       address_filter->pattern_handle       =3D handle_data->msft_handle=
;
> +       address_filter->mgmt_handle          =3D handle_data->mgmt_handle=
;
> +       address_filter->rssi_high            =3D cp->rssi_high;
> +       address_filter->rssi_low             =3D cp->rssi_low;
> +       address_filter->rssi_low_interval    =3D cp->rssi_low_interval;
> +       address_filter->rssi_sampling_period =3D cp->rssi_sampling_period=
;
> +       address_filter->addr_type            =3D addr_type;
> +       bacpy(&address_filter->bdaddr, bdaddr);
> +       list_add_tail(&address_filter->list, &msft->address_filters);
> +
> +       addr_filter_cb(skb)->pattern_handle =3D address_filter->pattern_h=
andle;
> +       addr_filter_cb(skb)->addr_type =3D addr_type;
> +       bacpy(&addr_filter_cb(skb)->bdaddr, bdaddr);
> +
> +       err =3D hci_cmd_sync_queue(hdev, msft_add_address_filter_sync, sk=
b, NULL);
> +       if (err < 0) {
> +               bt_dev_err(hdev, "MSFT: Add address %pMR filter err", bda=
ddr);
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +               goto err_skb;
> +       }
> +
> +       bt_dev_info(hdev, "MSFT: Add device %pMR address filter",
> +                   &address_filter->bdaddr);

bt_dev_dbg

> +       return address_filter;
> +err_skb:
> +       kfree_skb(skb);
> +       return NULL;
> +}
> +
>  /* This function requires the caller holds hdev->lock */
>  static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff=
 *skb)
>  {
>         struct msft_ev_le_monitor_device *ev;
>         struct msft_monitor_advertisement_handle_data *handle_data;
> +       struct msft_monitor_addr_filter_data *n, *address_filter =3D NULL=
;
>         u8 addr_type;
> +       u16 mgmt_handle =3D 0xffff;
> +       struct msft_data *msft =3D hdev->msft_data;
>
>         ev =3D msft_skb_pull(hdev, skb, MSFT_EV_LE_MONITOR_DEVICE, sizeof=
(*ev));
>         if (!ev)
> @@ -662,9 +1121,52 @@ static void msft_monitor_device_evt(struct hci_dev =
*hdev, struct sk_buff *skb)
>                    ev->monitor_state, &ev->bdaddr);
>
>         handle_data =3D msft_find_handle_data(hdev, ev->monitor_handle, f=
alse);
> -       if (!handle_data)
> +
> +       if (!msft->addr_monitor_assist) {
> +               if (!handle_data)
> +                       return;
> +               mgmt_handle =3D handle_data->mgmt_handle;
> +               goto report_state;
> +       }
> +
> +       if (handle_data) {
> +               /* Don't report any device found/lost event from pattern
> +                * monitors. Pattern monitor always has its address filte=
rs for
> +                * tracking devices.
> +                */
> +
> +               address_filter =3D msft_find_address_data(hdev, ev->addr_=
type,
> +                                                       &ev->bdaddr,
> +                                                       handle_data->msft=
_handle);
> +               if (address_filter)
> +                       return;
> +
> +               if (ev->monitor_state && handle_data->cond_type =3D=3D
> +                               MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN)
> +                       msft_add_address_filter(hdev, ev->addr_type,
> +                                               &ev->bdaddr, handle_data)=
;
> +
> +               return;
> +       }
> +
> +       /* This device event is not from pattern monitor.
> +        * Report it if there is a corresponding address_filter for it.
> +        */
> +       list_for_each_entry(n, &msft->address_filters, list) {
> +               if (n->active && n->msft_handle =3D=3D ev->monitor_handle=
) {
> +                       mgmt_handle =3D n->mgmt_handle;
> +                       address_filter =3D n;
> +                       break;
> +               }
> +       }
> +
> +       if (!address_filter) {
> +               bt_dev_warn(hdev, "MSFT: Unexpected device event %pMR, %u=
, %u",
> +                           &ev->bdaddr, ev->monitor_handle, ev->monitor_=
state);
>                 return;
> +       }
>
> +report_state:
>         switch (ev->addr_type) {
>         case ADDR_LE_DEV_PUBLIC:
>                 addr_type =3D BDADDR_LE_PUBLIC;
> @@ -681,12 +1183,16 @@ static void msft_monitor_device_evt(struct hci_dev=
 *hdev, struct sk_buff *skb)
>                 return;
>         }
>
> -       if (ev->monitor_state)
> -               msft_device_found(hdev, &ev->bdaddr, addr_type,
> -                                 handle_data->mgmt_handle);
> -       else
> -               msft_device_lost(hdev, &ev->bdaddr, addr_type,
> -                                handle_data->mgmt_handle);
> +       if (ev->monitor_state) {
> +               msft_device_found(hdev, &ev->bdaddr, addr_type, mgmt_hand=
le);
> +       } else {
> +               if (address_filter && address_filter->active)
> +                       hci_cmd_sync_queue(hdev,
> +                                          msft_cancel_address_filter_syn=
c,
> +                                          ERR_PTR(address_filter->msft_h=
andle),
> +                                          NULL);
> +               msft_device_lost(hdev, &ev->bdaddr, addr_type, mgmt_handl=
e);
> +       }
>  }
>
>  void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *s=
kb)
> @@ -724,7 +1230,9 @@ void msft_vendor_evt(struct hci_dev *hdev, void *dat=
a, struct sk_buff *skb)
>
>         switch (*evt) {
>         case MSFT_EV_LE_MONITOR_DEVICE:
> +               mutex_lock(&msft->filter_lock);
>                 msft_monitor_device_evt(hdev, skb);
> +               mutex_unlock(&msft->filter_lock);
>                 break;
>
>         default:
> --
> 2.17.1
>


--=20
Luiz Augusto von Dentz
