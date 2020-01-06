Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3BB13118B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 12:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgAFLoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 06:44:21 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37137 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgAFLoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 06:44:21 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so36182863lfc.4;
        Mon, 06 Jan 2020 03:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYrgRkm0PZPCJxxGLNSZWfu1cDxBdCF0aL8SvR3R1J0=;
        b=gZQJuHr3Wb/5pyS8/zjjdvOL6sft08lp7keJa9ueYLyWUok+4bbFAeXB6itxLhxAKq
         aC4JPuqiO/d7PQ6EXG2Xzuh+CGGxS84/dnYJadO0xLxWvdKGocv+YM+4p321MCVhp0xC
         VMlQ3dm4AhLLW+cRn0WcEIzkenUUGRg6g/H8mNnL/Bi5hI8TV4rtH9/+s4w2c0Tkru+r
         0/tnscwtiIrZoPBUGlEiR8fntLKtYbHN+pn+M0vYlQ5M1/WZyt0dxfuX6M7tE5BKs56s
         WOD/zqvF0c3LsyhbQg/7tFsSzym5MfrMrxrfAxesefkca/z/ths9Bcyc9irohHWf8q6R
         WV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYrgRkm0PZPCJxxGLNSZWfu1cDxBdCF0aL8SvR3R1J0=;
        b=ZsH14NlNbEn7F2JeyQQ+FM7RhUgBHh5z1Xdu15I5Wq9aZok5F5+HjK1jNhGzhJzJNP
         1t/Yp95iaCqyT5x+M6rwZWk9zOeikDFx6gVjVCQfgSm+l4MwngYABI6IpAXefQ8eeeIZ
         fGPLTXiR77RGRczMnFxIRmmGj/KDKe+xIlJL4XuprPDYbvKz1ksCW/vOB1hzYTDLlds2
         dwsUDxnPq8mliBnCuyCdSHJPvRHp+BePheYcsF6HXIDnP/GGp8g9BPT9ZdFI5d2Ks+sU
         YkVujyHRsnMJrRS9m5zTL4Wtv10irp3ztvTVY1A/zvhR9wO+iwtRi0/VVGUfWX0o9zD5
         Ot/Q==
X-Gm-Message-State: APjAAAVeagf7DyXYMZ/JIDf2JJKd8tQZJYlpfj34uY9VZymGRYuWwlqd
        3OVFAnN9K9HMm823TKeBm8qKiKf4xS/estWi8Ri5neQn
X-Google-Smtp-Source: APXvYqxLq9AYASV1X43me3CXFHTkDnH1Hmd/uYAb4t9tiqLx7UDJD1PmQ27wwsvNBuv1g/6ou69WDH7k2VBZbrIQUMo=
X-Received: by 2002:ac2:508e:: with SMTP id f14mr52292900lfm.72.1578311057816;
 Mon, 06 Jan 2020 03:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20200106181425.Bluez.v1.1.I5ee1ea8e19d41c5bdffb4211aeb9cd9efa5e0a4a@changeid>
 <CAMCGoNzCvOgcg0hAhDO-wcFLgX75JL-G6q1KuGFEjrEz+oPTxA@mail.gmail.com>
In-Reply-To: <CAMCGoNzCvOgcg0hAhDO-wcFLgX75JL-G6q1KuGFEjrEz+oPTxA@mail.gmail.com>
From:   Matias Karhumaa <matias.karhumaa@gmail.com>
Date:   Mon, 6 Jan 2020 13:44:06 +0200
Message-ID: <CAMCGoNyzN17pK_4t6bWt4OLsWnFUEdn06dJwz=mhzxQLv0BbOA@mail.gmail.com>
Subject: Fwd: [Bluez PATCH v1] bluetooth: secure bluetooth stack from bluedump attack
To:     howardchung@google.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

Re-sending as plain text.

This same attack scenario works also against Ubuntu 18.04 at least.

ma 6. tammik. 2020 klo 12.17 howardchung@google.com
(howardchung@google.com) kirjoitti:
>
> From: howardchung <howardchung@google.com>
>
> Attack scenario:
> 1. A Chromebook (let's call this device A) is paired to a legitimate
>    Bluetooth classic device (e.g. a speaker) (let's call this device
>    B).
> 2. A malicious device (let's call this device C) pretends to be the
>    Bluetooth speaker by using the same BT address.
> 3. If device A is not currently connected to device B, device A will
>    be ready to accept connection from device B in the background
>    (technically, doing Page Scan).
> 4. Therefore, device C can initiate connection to device A
>    (because device A is doing Page Scan) and device A will accept the
>    connection because device A trusts device C's address which is the
>    same as device B's address.
> 5. Device C won't be able to communicate at any high level Bluetooth
>    profile with device A because device A enforces that device C is
>    encrypted with their common Link Key, which device C doesn't have.
>    But device C can initiate pairing with device A with just-works
>    model without requiring user interaction (there is only pairing
>    notification). After pairing, device A now trusts device C with a
>    new different link key, common between device A and C.
> 6. From now on, device A trusts device C, so device C can at anytime
>    connect to device A to do any kind of high-level hijacking, e.g.
>    speaker hijack or mouse/keyboard hijack.
>
> To fix this, reject the pairing if all the conditions below are met.
> - the pairing is initialized by peer
> - the authorization method is just-work
> - host already had the link key to the peer
>
> Also create a debugfs option to permit the pairing even the
> conditions above are met.
>
> Signed-off-by: howardchung <howardchung@google.com>
> ---
>
>  include/net/bluetooth/hci.h |  1 +
>  net/bluetooth/hci_core.c    | 47 +++++++++++++++++++++++++++++++++++++
>  net/bluetooth/hci_event.c   | 12 ++++++++++
>  3 files changed, 60 insertions(+)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 07b6ecedc6ce..4918b79baa41 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -283,6 +283,7 @@ enum {
>         HCI_FORCE_STATIC_ADDR,
>         HCI_LL_RPA_RESOLUTION,
>         HCI_CMD_PENDING,
> +       HCI_PERMIT_JUST_WORK_REPAIR,
>
>         __HCI_NUM_FLAGS,
>  };
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 9e19d5a3aac8..9014aa567e7b 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -172,10 +172,57 @@ static const struct file_operations vendor_diag_fops = {
>         .llseek         = default_llseek,
>  };
>
> +static ssize_t permit_just_work_repair_read(struct file *file,
> +                                           char __user *user_buf,
> +                                           size_t count, loff_t *ppos)
> +{
> +       struct hci_dev *hdev = file->private_data;
> +       char buf[3];
> +
> +       buf[0] = hci_dev_test_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR) ? 'Y'
> +                                                                     : 'N';
> +       buf[1] = '\n';
> +       buf[2] = '\0';
> +       return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> +}
> +
> +static ssize_t permit_just_work_repair_write(struct file *file,
> +                                            const char __user *user_buf,
> +                                            size_t count, loff_t *ppos)
> +{
> +       struct hci_dev *hdev = file->private_data;
> +       char buf[32];
> +       size_t buf_size = min(count, (sizeof(buf) - 1));
> +       bool enable;
> +
> +       if (copy_from_user(buf, user_buf, buf_size))
> +               return -EFAULT;
> +
> +       buf[buf_size] = '\0';
> +       if (strtobool(buf, &enable))
> +               return -EINVAL;
> +
> +       if (enable)
> +               hci_dev_set_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR);
> +       else
> +               hci_dev_clear_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR);
> +
> +       return count;
> +}
> +
> +static const struct file_operations permit_just_work_repair_fops = {
> +       .open           = simple_open,
> +       .read           = permit_just_work_repair_read,
> +       .write          = permit_just_work_repair_write,
> +       .llseek         = default_llseek,
> +};
> +
>  static void hci_debugfs_create_basic(struct hci_dev *hdev)
>  {
>         debugfs_create_file("dut_mode", 0644, hdev->debugfs, hdev,
>                             &dut_mode_fops);
> +       debugfs_create_file("permit_just_work_repair", 0644, hdev->debugfs,
> +                           hdev, &permit_just_work_repair_fops);
>
>         if (hdev->set_diag)
>                 debugfs_create_file("vendor_diag", 0644, hdev->debugfs, hdev,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6ddc4a74a5e4..898e347e19e0 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4539,6 +4539,18 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
>                 goto unlock;
>         }
>
> +       /* If there already exists link key in local host, terminate the
> +        * connection by default since the remote device could be malicious.
> +        * Permit the connection if permit_just_work_repair is enabled.
> +        */
> +       if (!hci_dev_test_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR) &&
> +           hci_find_link_key(hdev, &ev->bdaddr)) {
> +               BT_DBG("Rejecting request: local host already have link key");
> +               hci_send_cmd(hdev, HCI_OP_USER_CONFIRM_NEG_REPLY,

Why wouldn't we just request authorization from userspace in case we
already have link key? I think that is how it works on other
platforms.
>
> +                            sizeof(ev->bdaddr), &ev->bdaddr);
> +               goto unlock;
> +       }
> +
>         /* If no side requires MITM protection; auto-accept */
>         if ((!loc_mitm || conn->remote_cap == HCI_IO_NO_INPUT_OUTPUT) &&
>             (!rem_mitm || conn->io_capability == HCI_IO_NO_INPUT_OUTPUT)) {
> --
> 2.24.1.735.g03f4e72817-goog


Best regard,
Matias Karhumaa
