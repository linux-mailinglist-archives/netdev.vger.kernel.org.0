Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B022CE76FC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 17:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403898AbfJ1Qs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 12:48:26 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38443 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403879AbfJ1QsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 12:48:25 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so11468452iom.5
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 09:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HP7R06sgub2pl+44CqebBT1D+LSMqPlZv+cDsUIjYtU=;
        b=WDOMRuRfeA1c9NC4kUW1Y3maIUTtYaO7iHBj/L53oFqr9srR83Jl+5b7mNgmyVnmMb
         G1IGOgbRgMiRE0CfYb7IaMO8iCfyG14kSBH8txym9NDsBbIi4ZXdsMVdBoJIMn0FIkZT
         Q+RUoMMhDaPaQgtheaKPd3pUwcC1JOueQN4xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HP7R06sgub2pl+44CqebBT1D+LSMqPlZv+cDsUIjYtU=;
        b=mEyQvpvlNACoeJF219teQo7tNhhEOw8FHmQF0scH94HzG99JFUg2NSUC068C4ukqxk
         D7wAjKbewpBlSHsgb6QxWZ5nGdMJMooz8h4K+I+5gp9/k/He8soj8nelcmlTIaYJz374
         KLswwYXCfKR/Po6m8fAKOV0Jb6v6riSHP2RF8f5tEEnB821Vcy5E+ylvxfl9BSd/TXYP
         MILb/h0pmpR+FORACeS1610SH34ik8gaoQYtBWWHJ0vhL6nz9XolV0nctb+JQE0o+QHR
         bC6CPOHeD3QqZAKGxfPbjOAT4yLTAqxqX/PqKChrAHlzWZg+cAXJvgYx7+IFOYtzn2cL
         IFFg==
X-Gm-Message-State: APjAAAVOTa+aOsYuv4pCq7yzmBbp8qpeoc9wUdUpIKzjSLK4ZHXaLBeD
        GCMIk4CGcS6UFvCwjYWzpmhhn4GwPJQAeXgIUqa9YA==
X-Google-Smtp-Source: APXvYqxqEckvyJAwA68p5KMDes2C38TzdcKS9IZGmBXWrpWAUJFcwJhLMI37yaBlojbvSEV79lhXblXtSrVQznIlLbQ=
X-Received: by 2002:a5d:938d:: with SMTP id c13mr9066263iol.167.1572281303545;
 Mon, 28 Oct 2019 09:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <1394712342-15778-330-Taiwan-albertk@realtek.com> <1394712342-15778-331-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-331-Taiwan-albertk@realtek.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Mon, 28 Oct 2019 09:48:11 -0700
Message-ID: <CANEJEGtrezF_CjjVQjnHnb7UownW837Rf9Wkh4zQCGVtry9PSA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] r8152: rename fw_type_1 with fw_mac
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev <netdev@vger.kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Prashant Malani <pmalani@chromium.org>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 8:41 PM Hayes Wang <hayeswang@realtek.com> wrote:
>
> The struct fw_type_1 is used by MAC only, so rename it to a meaningful one.
>
> Besides, adjust two messages. Replace "load xxx fail" with "check xxx fail"
>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Looks good to me.

Reviewed-by: Grant Grundler <grundler@chromium.org>

cheers,
grant

> ---
>  drivers/net/usb/r8152.c | 82 ++++++++++++++++++++---------------------
>  1 file changed, 41 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 55d0bcb00aef..55a7674a0c06 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -867,11 +867,11 @@ struct fw_header {
>  } __packed;
>
>  /**
> - * struct fw_type_1 - a firmware block used by RTL_FW_PLA and RTL_FW_USB.
> + * struct fw_mac - a firmware block used by RTL_FW_PLA and RTL_FW_USB.
>   *     The layout of the firmware block is:
> - *     <struct fw_type_1> + <info> + <firmware data>.
> + *     <struct fw_mac> + <info> + <firmware data>.
>   * @fw_offset: offset of the firmware binary data. The start address of
> - *     the data would be the address of struct fw_type_1 + @fw_offset.
> + *     the data would be the address of struct fw_mac + @fw_offset.
>   * @fw_reg: the register to load the firmware. Depends on chip.
>   * @bp_ba_addr: the register to write break point base address. Depends on
>   *     chip.
> @@ -888,7 +888,7 @@ struct fw_header {
>   * @info: additional information for debugging, and is followed by the
>   *     binary data of firmware.
>   */
> -struct fw_type_1 {
> +struct fw_mac {
>         struct fw_block blk_hdr;
>         __le16 fw_offset;
>         __le16 fw_reg;
> @@ -3397,14 +3397,14 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
>         ocp_write_word(tp, type, PLA_BP_BA, 0);
>  }
>
> -static bool rtl8152_is_fw_type1_ok(struct r8152 *tp, struct fw_type_1 *type1)
> +static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
>  {
>         u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start;
>         bool rc = false;
>         u32 length, type;
>         int i, max_bp;
>
> -       type = __le32_to_cpu(type1->blk_hdr.type);
> +       type = __le32_to_cpu(mac->blk_hdr.type);
>         if (type == RTL_FW_PLA) {
>                 switch (tp->version) {
>                 case RTL_VER_01:
> @@ -3461,46 +3461,46 @@ static bool rtl8152_is_fw_type1_ok(struct r8152 *tp, struct fw_type_1 *type1)
>                 goto out;
>         }
>
> -       length = __le32_to_cpu(type1->blk_hdr.length);
> -       if (length < __le16_to_cpu(type1->fw_offset)) {
> +       length = __le32_to_cpu(mac->blk_hdr.length);
> +       if (length < __le16_to_cpu(mac->fw_offset)) {
>                 dev_err(&tp->intf->dev, "invalid fw_offset\n");
>                 goto out;
>         }
>
> -       length -= __le16_to_cpu(type1->fw_offset);
> +       length -= __le16_to_cpu(mac->fw_offset);
>         if (length < 4 || (length & 3)) {
>                 dev_err(&tp->intf->dev, "invalid block length\n");
>                 goto out;
>         }
>
> -       if (__le16_to_cpu(type1->fw_reg) != fw_reg) {
> +       if (__le16_to_cpu(mac->fw_reg) != fw_reg) {
>                 dev_err(&tp->intf->dev, "invalid register to load firmware\n");
>                 goto out;
>         }
>
> -       if (__le16_to_cpu(type1->bp_ba_addr) != bp_ba_addr) {
> +       if (__le16_to_cpu(mac->bp_ba_addr) != bp_ba_addr) {
>                 dev_err(&tp->intf->dev, "invalid base address register\n");
>                 goto out;
>         }
>
> -       if (__le16_to_cpu(type1->bp_en_addr) != bp_en_addr) {
> +       if (__le16_to_cpu(mac->bp_en_addr) != bp_en_addr) {
>                 dev_err(&tp->intf->dev, "invalid enabled mask register\n");
>                 goto out;
>         }
>
> -       if (__le16_to_cpu(type1->bp_start) != bp_start) {
> +       if (__le16_to_cpu(mac->bp_start) != bp_start) {
>                 dev_err(&tp->intf->dev,
>                         "invalid start register of break point\n");
>                 goto out;
>         }
>
> -       if (__le16_to_cpu(type1->bp_num) > max_bp) {
> +       if (__le16_to_cpu(mac->bp_num) > max_bp) {
>                 dev_err(&tp->intf->dev, "invalid break point number\n");
>                 goto out;
>         }
>
> -       for (i = __le16_to_cpu(type1->bp_num); i < max_bp; i++) {
> -               if (type1->bp[i]) {
> +       for (i = __le16_to_cpu(mac->bp_num); i < max_bp; i++) {
> +               if (mac->bp[i]) {
>                         dev_err(&tp->intf->dev, "unused bp%u is not zero\n", i);
>                         goto out;
>                 }
> @@ -3566,7 +3566,7 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
>  {
>         const struct firmware *fw = rtl_fw->fw;
>         struct fw_header *fw_hdr = (struct fw_header *)fw->data;
> -       struct fw_type_1 *pla = NULL, *usb = NULL;
> +       struct fw_mac *pla = NULL, *usb = NULL;
>         long ret = -EFAULT;
>         int i;
>
> @@ -3601,10 +3601,10 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
>                                 goto fail;
>                         }
>
> -                       pla = (struct fw_type_1 *)block;
> -                       if (!rtl8152_is_fw_type1_ok(tp, pla)) {
> +                       pla = (struct fw_mac *)block;
> +                       if (!rtl8152_is_fw_mac_ok(tp, pla)) {
>                                 dev_err(&tp->intf->dev,
> -                                       "load PLA firmware failed\n");
> +                                       "check PLA firmware failed\n");
>                                 goto fail;
>                         }
>                         break;
> @@ -3615,10 +3615,10 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
>                                 goto fail;
>                         }
>
> -                       usb = (struct fw_type_1 *)block;
> -                       if (!rtl8152_is_fw_type1_ok(tp, usb)) {
> +                       usb = (struct fw_mac *)block;
> +                       if (!rtl8152_is_fw_mac_ok(tp, usb)) {
>                                 dev_err(&tp->intf->dev,
> -                                       "load USB firmware failed\n");
> +                                       "check USB firmware failed\n");
>                                 goto fail;
>                         }
>                         break;
> @@ -3638,14 +3638,14 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
>         return ret;
>  }
>
> -static void rtl8152_fw_type_1_apply(struct r8152 *tp, struct fw_type_1 *type1)
> +static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
>  {
>         u16 bp_en_addr, bp_index, type, bp_num, fw_ver_reg;
>         u32 length;
>         u8 *data;
>         int i;
>
> -       switch (__le32_to_cpu(type1->blk_hdr.type)) {
> +       switch (__le32_to_cpu(mac->blk_hdr.type)) {
>         case RTL_FW_PLA:
>                 type = MCU_TYPE_PLA;
>                 break;
> @@ -3667,36 +3667,36 @@ static void rtl8152_fw_type_1_apply(struct r8152 *tp, struct fw_type_1 *type1)
>                 ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST, DEBUG_LTSSM);
>         }
>
> -       length = __le32_to_cpu(type1->blk_hdr.length);
> -       length -= __le16_to_cpu(type1->fw_offset);
> +       length = __le32_to_cpu(mac->blk_hdr.length);
> +       length -= __le16_to_cpu(mac->fw_offset);
>
> -       data = (u8 *)type1;
> -       data += __le16_to_cpu(type1->fw_offset);
> +       data = (u8 *)mac;
> +       data += __le16_to_cpu(mac->fw_offset);
>
> -       generic_ocp_write(tp, __le16_to_cpu(type1->fw_reg), 0xff, length, data,
> +       generic_ocp_write(tp, __le16_to_cpu(mac->fw_reg), 0xff, length, data,
>                           type);
>
> -       ocp_write_word(tp, type, __le16_to_cpu(type1->bp_ba_addr),
> -                      __le16_to_cpu(type1->bp_ba_value));
> +       ocp_write_word(tp, type, __le16_to_cpu(mac->bp_ba_addr),
> +                      __le16_to_cpu(mac->bp_ba_value));
>
> -       bp_index = __le16_to_cpu(type1->bp_start);
> -       bp_num = __le16_to_cpu(type1->bp_num);
> +       bp_index = __le16_to_cpu(mac->bp_start);
> +       bp_num = __le16_to_cpu(mac->bp_num);
>         for (i = 0; i < bp_num; i++) {
> -               ocp_write_word(tp, type, bp_index, __le16_to_cpu(type1->bp[i]));
> +               ocp_write_word(tp, type, bp_index, __le16_to_cpu(mac->bp[i]));
>                 bp_index += 2;
>         }
>
> -       bp_en_addr = __le16_to_cpu(type1->bp_en_addr);
> +       bp_en_addr = __le16_to_cpu(mac->bp_en_addr);
>         if (bp_en_addr)
>                 ocp_write_word(tp, type, bp_en_addr,
> -                              __le16_to_cpu(type1->bp_en_value));
> +                              __le16_to_cpu(mac->bp_en_value));
>
> -       fw_ver_reg = __le16_to_cpu(type1->fw_ver_reg);
> +       fw_ver_reg = __le16_to_cpu(mac->fw_ver_reg);
>         if (fw_ver_reg)
>                 ocp_write_byte(tp, MCU_TYPE_USB, fw_ver_reg,
> -                              type1->fw_ver_data);
> +                              mac->fw_ver_data);
>
> -       dev_dbg(&tp->intf->dev, "successfully applied %s\n", type1->info);
> +       dev_dbg(&tp->intf->dev, "successfully applied %s\n", mac->info);
>  }
>
>  static void rtl8152_apply_firmware(struct r8152 *tp)
> @@ -3720,7 +3720,7 @@ static void rtl8152_apply_firmware(struct r8152 *tp)
>                         goto post_fw;
>                 case RTL_FW_PLA:
>                 case RTL_FW_USB:
> -                       rtl8152_fw_type_1_apply(tp, (struct fw_type_1 *)block);
> +                       rtl8152_fw_mac_apply(tp, (struct fw_mac *)block);
>                         break;
>                 default:
>                         break;
> --
> 2.21.0
>
