Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FBC21CE91
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgGMFHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgGMFHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 01:07:54 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CE8C061794;
        Sun, 12 Jul 2020 22:07:54 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id a32so9093040qtb.5;
        Sun, 12 Jul 2020 22:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zn4QovJTObyer1bkeM2XLJCYckJFice9R/PcByfIUJ8=;
        b=ThNgHLlSpgpnRfaARHvJvVG762LNQbG0fUZAGvcBXEsS3bqrJJN0UVVluSCt8deMyi
         uWEnzKHO4QMhyjYoomcglALeDyflrhp1TTfcU26u8OzhWaRWQ3oX1YDLWBdwND0nuHAl
         UI8w13XGp5yb9iP0WzOb8jDEch5c0DFakcv0ZedPje1CspVB56pIH9mLyTKxleRlqMMQ
         7pS8g/iqBZGI5xpKK6462NsdnHGM5EzeJ1sUDJ2Jh/fi6ZXc1ZXtvO/LT+lb6qAKbiKd
         N6+mHT/tuREq7G9rdOVgMY2QAIKCr/a3zmcEEFuYrPF/qf5kurc3rbn/t9NfhAadIvR0
         DK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zn4QovJTObyer1bkeM2XLJCYckJFice9R/PcByfIUJ8=;
        b=Mqo4xTEg+LSiv8KVRtSQbunBh2qZzoVqHAT7J9Xk1jsq7vdq71e66bZZ57O24DwlmP
         zY2ApVmqFtRDTdMT79fiylaNGcdd8YucK5lLpwlMXL520QbNs5FctLJy59Ag12SgTdv3
         MonW24/lKZfWaw1mt9EQjz1jDYskDN0N54UVD4iprhQesD3y4Y8zu/G6K/AMC5QHWFl6
         Vo9YQOvNyueb3T1JZ/oxdMLFwt4ycv1So3A7jIJq/JE66gtbu4su5n74CGuJu141b8wb
         663QlDH76HCmAlkZdjGjLdj0N+Z1I5WedFdmP+uzchxlsjZSEP1PPowPdn2MHJPU+3rJ
         EZhg==
X-Gm-Message-State: AOAM533mope4/FrgVtxmR6j8UvKdXkNhvN8lWRSrF5nj+OHHBceRhuUD
        s6RrJxV/IYg5ggkdHrgBWJI27c4BWPe3pueCWlI=
X-Google-Smtp-Source: ABdhPJwAyvvGNRCcOOt8bd/qMLFaLFQW73VNJhJJ0aRdBdnbxvk2SK/yLjDUI7jnRE1G6McBbITWAyI7HcCP3XNgRmw=
X-Received: by 2002:ac8:6d1a:: with SMTP id o26mr76449982qtt.87.1594616873269;
 Sun, 12 Jul 2020 22:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200705195110.405139-1-anarsoul@gmail.com> <20200705195110.405139-3-anarsoul@gmail.com>
 <99A48FC7-0DCB-42F9-A3E3-91292BB92100@holtmann.org>
In-Reply-To: <99A48FC7-0DCB-42F9-A3E3-91292BB92100@holtmann.org>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Sun, 12 Jul 2020 22:07:27 -0700
Message-ID: <CA+E=qVegvJqvVWNb7V-QHG0BDFJP6GYw7P36_M33xmRMcyetGw@mail.gmail.com>
Subject: Re: [PATCH 2/3] Bluetooth: btrtl: add support for the RTL8723CS
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 9:01 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Vasily,
>
> > The Realtek RTL8723CS is SDIO WiFi chip. It also contains a Bluetooth
> > module which is connected via UART to the host.
> >
> > It shares lmp subversion with 8703B, so Realtek's userspace
> > initialization tool (rtk_hciattach) differentiates varieties of RTL8723CS
> > (CG, VF, XX) with RTL8703B using vendor's command to read chip type.
> >
> > Also this chip declares support for some features it doesn't support
> > so add a quirk to indicate that these features are broken.
> >
> > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > ---
> > drivers/bluetooth/btrtl.c  | 128 ++++++++++++++++++++++++++++++++++++-
> > drivers/bluetooth/btrtl.h  |  12 ++++
> > drivers/bluetooth/hci_h5.c |   6 ++
> > 3 files changed, 143 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
> > index 3a9afc905f24..8c7b35abe492 100644
> > --- a/drivers/bluetooth/btrtl.c
> > +++ b/drivers/bluetooth/btrtl.c
> > @@ -17,8 +17,12 @@
> >
> > #define VERSION "0.1"
> >
> > +#define RTL_CHIP_8723CS_CG   3
> > +#define RTL_CHIP_8723CS_VF   4
> > +#define RTL_CHIP_8723CS_XX   5
> > #define RTL_EPATCH_SIGNATURE  "Realtech"
> > #define RTL_ROM_LMP_3499      0x3499
> > +#define RTL_ROM_LMP_8703B    0x8703
> > #define RTL_ROM_LMP_8723A     0x1200
> > #define RTL_ROM_LMP_8723B     0x8723
> > #define RTL_ROM_LMP_8723D     0x8873
> > @@ -31,6 +35,7 @@
> > #define IC_MATCH_FL_HCIREV    (1 << 1)
> > #define IC_MATCH_FL_HCIVER    (1 << 2)
> > #define IC_MATCH_FL_HCIBUS    (1 << 3)
> > +#define IC_MATCH_FL_CHIP_TYPE        (1 << 4)
> > #define IC_INFO(lmps, hcir) \
> >       .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_HCIREV, \
> >       .lmp_subver = (lmps), \
> > @@ -42,6 +47,7 @@ struct id_table {
> >       __u16 hci_rev;
> >       __u8 hci_ver;
> >       __u8 hci_bus;
> > +     __u8 chip_type;
> >       bool config_needed;
> >       bool has_rom_version;
> >       char *fw_name;
> > @@ -89,6 +95,39 @@ static const struct id_table ic_id_table[] = {
> >         .fw_name  = "rtl_bt/rtl8723b_fw.bin",
> >         .cfg_name = "rtl_bt/rtl8723b_config" },
> >
> > +     /* 8723CS-CG */
> > +     { .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
> > +                      IC_MATCH_FL_HCIBUS,
> > +       .lmp_subver = RTL_ROM_LMP_8703B,
> > +       .chip_type = RTL_CHIP_8723CS_CG,
> > +       .hci_bus = HCI_UART,
> > +       .config_needed = true,
> > +       .has_rom_version = true,
> > +       .fw_name  = "rtl_bt/rtl8723cs_cg_fw.bin",
> > +       .cfg_name = "rtl_bt/rtl8723cs_cg_config" },
> > +
> > +     /* 8723CS-VF */
> > +     { .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
> > +                      IC_MATCH_FL_HCIBUS,
> > +       .lmp_subver = RTL_ROM_LMP_8703B,
> > +       .chip_type = RTL_CHIP_8723CS_VF,
> > +       .hci_bus = HCI_UART,
> > +       .config_needed = true,
> > +       .has_rom_version = true,
> > +       .fw_name  = "rtl_bt/rtl8723cs_vf_fw.bin",
> > +       .cfg_name = "rtl_bt/rtl8723cs_vf_config" },
> > +
> > +     /* 8723CS-XX */
> > +     { .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
> > +                      IC_MATCH_FL_HCIBUS,
> > +       .lmp_subver = RTL_ROM_LMP_8703B,
> > +       .chip_type = RTL_CHIP_8723CS_XX,
> > +       .hci_bus = HCI_UART,
> > +       .config_needed = true,
> > +       .has_rom_version = true,
> > +       .fw_name  = "rtl_bt/rtl8723cs_xx_fw.bin",
> > +       .cfg_name = "rtl_bt/rtl8723cs_xx_config" },
> > +
> >       /* 8723D */
> >       { IC_INFO(RTL_ROM_LMP_8723B, 0xd),
> >         .config_needed = true,
> > @@ -171,7 +210,8 @@ static const struct id_table ic_id_table[] = {
> >       };
> >
> > static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
> > -                                          u8 hci_ver, u8 hci_bus)
> > +                                          u8 hci_ver, u8 hci_bus,
> > +                                          u8 chip_type)
> > {
> >       int i;
> >
> > @@ -188,6 +228,9 @@ static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
> >               if ((ic_id_table[i].match_flags & IC_MATCH_FL_HCIBUS) &&
> >                   (ic_id_table[i].hci_bus != hci_bus))
> >                       continue;
> > +             if ((ic_id_table[i].match_flags & IC_MATCH_FL_CHIP_TYPE) &&
> > +                 (ic_id_table[i].chip_type != chip_type))
> > +                     continue;
> >
> >               break;
> >       }
> > @@ -270,6 +313,7 @@ static int rtlbt_parse_firmware(struct hci_dev *hdev,
> >               { RTL_ROM_LMP_8723B, 1 },
> >               { RTL_ROM_LMP_8821A, 2 },
> >               { RTL_ROM_LMP_8761A, 3 },
> > +             { RTL_ROM_LMP_8703B, 7 },
> >               { RTL_ROM_LMP_8822B, 8 },
> >               { RTL_ROM_LMP_8723B, 9 },       /* 8723D */
> >               { RTL_ROM_LMP_8821A, 10 },      /* 8821C */
> > @@ -545,6 +589,48 @@ static int btrtl_setup_rtl8723b(struct hci_dev *hdev,
> >       return ret;
> > }
> >
> > +static bool rtl_has_chip_type(u16 lmp_subver)
> > +{
> > +     switch (lmp_subver) {
> > +     case RTL_ROM_LMP_8703B:
> > +             return true;
> > +     default:
> > +             break;
> > +     }
> > +
> > +     return  false;
> > +}
> > +
> > +static int rtl_read_chip_type(struct hci_dev *hdev, u8 *type)
> > +{
> > +     struct rtl_chip_type_evt *chip_type;
> > +     struct sk_buff *skb;
> > +     const unsigned char cmd_buf[] = {0x00, 0x94, 0xa0, 0x00, 0xb0};
> > +
> > +     /* Read RTL chip type command */
> > +     skb = __hci_cmd_sync(hdev, 0xfc61, 5, cmd_buf, HCI_INIT_TIMEOUT);
> > +     if (IS_ERR(skb)) {
> > +             rtl_dev_err(hdev, "Read chip type failed (%ld)",
> > +                         PTR_ERR(skb));
> > +             return PTR_ERR(skb);
> > +     }
> > +
> > +     if (skb->len != sizeof(*chip_type)) {
> > +             rtl_dev_err(hdev, "RTL chip type event length mismatch");
> > +             kfree_skb(skb);
> > +             return -EIO;
> > +     }
> > +
> > +     chip_type = (struct rtl_chip_type_evt *)skb->data;
> > +     rtl_dev_info(hdev, "chip_type status=%x type=%x",
> > +                  chip_type->status, chip_type->type);
> > +
> > +     *type = chip_type->type & 0x0f;
> > +
> > +     kfree_skb(skb);
> > +     return 0;
> > +}
> > +
> > void btrtl_free(struct btrtl_device_info *btrtl_dev)
> > {
> >       kvfree(btrtl_dev->fw_data);
> > @@ -561,7 +647,7 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
> >       struct hci_rp_read_local_version *resp;
> >       char cfg_name[40];
> >       u16 hci_rev, lmp_subver;
> > -     u8 hci_ver;
> > +     u8 hci_ver, chip_type = 0;
> >       int ret;
> >
> >       btrtl_dev = kzalloc(sizeof(*btrtl_dev), GFP_KERNEL);
> > @@ -586,8 +672,14 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
> >       lmp_subver = le16_to_cpu(resp->lmp_subver);
> >       kfree_skb(skb);
> >
> > +     if (rtl_has_chip_type(lmp_subver)) {
> > +             ret = rtl_read_chip_type(hdev, &chip_type);
> > +             if (ret)
> > +                     goto err_free;
> > +     }
> > +
> >       btrtl_dev->ic_info = btrtl_match_ic(lmp_subver, hci_rev, hci_ver,
> > -                                         hdev->bus);
> > +                                         hdev->bus, chip_type);
> >
> >       if (!btrtl_dev->ic_info) {
> >               rtl_dev_info(hdev, "unknown IC info, lmp subver %04x, hci rev %04x, hci ver %04x",
> > @@ -660,6 +752,7 @@ int btrtl_download_firmware(struct hci_dev *hdev,
> >       case RTL_ROM_LMP_8821A:
> >       case RTL_ROM_LMP_8761A:
> >       case RTL_ROM_LMP_8822B:
> > +     case RTL_ROM_LMP_8703B:
> >               return btrtl_setup_rtl8723b(hdev, btrtl_dev);
> >       default:
> >               rtl_dev_info(hdev, "assuming no firmware upload needed");
> > @@ -678,7 +771,12 @@ int btrtl_setup_realtek(struct hci_dev *hdev)
> >               return PTR_ERR(btrtl_dev);
> >
> >       ret = btrtl_download_firmware(hdev, btrtl_dev);
> > +     if (ret)
> > +             goto out_free;
> >
> > +     btrtl_apply_quirks(hdev, btrtl_dev);
> > +
> > +out_free:
> >       btrtl_free(btrtl_dev);
> >
> >       /* Enable controller to do both LE scan and BR/EDR inquiry
> > @@ -818,6 +916,24 @@ int btrtl_get_uart_settings(struct hci_dev *hdev,
> > }
> > EXPORT_SYMBOL_GPL(btrtl_get_uart_settings);
> >
> > +void btrtl_apply_quirks(struct hci_dev *hdev,
> > +                     struct btrtl_device_info *btrtl_dev)
> > +{
> > +     switch (btrtl_dev->ic_info->lmp_subver) {
> > +     case RTL_ROM_LMP_8703B:
> > +             /* 8723CS reports two pages for local ext features,
> > +              * but it doesn't support any features from page 2 -
> > +              * it either responds with garbage or with error status
> > +              */
> > +             set_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
> > +                     &hdev->quirks);
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +}
> > +EXPORT_SYMBOL_GPL(btrtl_apply_quirks);
> > +
> > MODULE_AUTHOR("Daniel Drake <drake@endlessm.com>");
> > MODULE_DESCRIPTION("Bluetooth support for Realtek devices ver " VERSION);
> > MODULE_VERSION(VERSION);
> > @@ -827,6 +943,12 @@ MODULE_FIRMWARE("rtl_bt/rtl8723b_fw.bin");
> > MODULE_FIRMWARE("rtl_bt/rtl8723b_config.bin");
> > MODULE_FIRMWARE("rtl_bt/rtl8723bs_fw.bin");
> > MODULE_FIRMWARE("rtl_bt/rtl8723bs_config.bin");
> > +MODULE_FIRMWARE("rtl_bt/rtl8723cs_cg_fw.bin");
> > +MODULE_FIRMWARE("rtl_bt/rtl8723cs_cg_config.bin");
> > +MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_fw.bin");
> > +MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_config.bin");
> > +MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_fw.bin");
> > +MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_config.bin");
> > MODULE_FIRMWARE("rtl_bt/rtl8723ds_fw.bin");
> > MODULE_FIRMWARE("rtl_bt/rtl8723ds_config.bin");
> > MODULE_FIRMWARE("rtl_bt/rtl8761a_fw.bin");
> > diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
> > index 2a582682136d..152ed2ece4c2 100644
> > --- a/drivers/bluetooth/btrtl.h
> > +++ b/drivers/bluetooth/btrtl.h
> > @@ -14,6 +14,11 @@
> >
> > struct btrtl_device_info;
> >
> > +struct rtl_chip_type_evt {
> > +     __u8 status;
> > +     __u8 type;
> > +} __packed;
> > +
> > struct rtl_download_cmd {
> >       __u8 index;
> >       __u8 data[RTL_FRAG_LEN];
> > @@ -60,6 +65,8 @@ int btrtl_get_uart_settings(struct hci_dev *hdev,
> >                           struct btrtl_device_info *btrtl_dev,
> >                           unsigned int *controller_baudrate,
> >                           u32 *device_baudrate, bool *flow_control);
> > +void btrtl_apply_quirks(struct hci_dev *hdev,
> > +                     struct btrtl_device_info *btrtl_dev);
> >
> > #else
> >
> > @@ -96,6 +103,11 @@ static inline int btrtl_get_uart_settings(struct hci_dev *hdev,
> >                                         bool *flow_control)
> > {
> >       return -ENOENT;
> > +
> > +static inline void btrtl_apply_quirks(struct hci_dev *hdev,
> > +                     struct btrtl_device_info *btrtl_dev)
> > +{
> > +}
> > }
>
> this hunk is fundamentally broken.

Will fix in v2

> Regards
>
> Marcel
>
