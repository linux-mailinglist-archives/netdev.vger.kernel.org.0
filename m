Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C2A29C0DE
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818515AbgJ0RUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:20:53 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46598 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1818196AbgJ0RSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 13:18:07 -0400
Received: by mail-ot1-f66.google.com with SMTP id j21so1786693ota.13;
        Tue, 27 Oct 2020 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7H+Lg0qir4fBM/+Ge4cbBHa1JZjzTa4EjScqkxv75EI=;
        b=KzyV1rtFBY0FsDlMAcdbe1mlCFW2yUgg+t5Ggq0mdbbIAOs4NqSAZspO8AW009/Sf+
         DCYedEujAbhwbvKdWYIzFJM7IN8EucnSNiwT9hkuYTRiC3mxADH90V+JWbdPvkO6O8gq
         +wbkiVJ66G+/CX2ojuhgLaoLyeGP1d5Q5/t/vJ7Ae1mRNkCm9QtVLd3WlSdPaPSLU1Ah
         feHRFfmFIk2nuFBuxXoCJdna8nfE3AUSE2ikQHM3GKScKU9lbWTWJqNwL1wT7JdN6E4z
         bARsvNv+Zhn5WIgNrd5KYOom6emyQQ39seFr/zHq7wObI2z6kMqPuQrUuGuGv6yw24yr
         TrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7H+Lg0qir4fBM/+Ge4cbBHa1JZjzTa4EjScqkxv75EI=;
        b=PEo6r5dCFxyV9ChE1RpRzK8cMqKSblpPiz8ZBnOhSEoV3RTo3+8RRFtiHSy2DCga3q
         AzfWuPwI3SCIbDQ/kzlE5mDHNCdH7dUB1c4PFwjczOeSCWUjDu7PbS/gGxuwXYdJT6DS
         DofLHn/+oPs1jXF6x2k0B/XiHz70ie8Hu+SdtUPEz2uVpQ54WwMRc/1znQl9qG7N+g0r
         ohHWEhcutImFvgO4DBZ1sYntJwbu30aUu4iO6TmRJ+Ezvfks7wFPBZNdM3Qf63agIt2Y
         /B38VTfS6HJqJi+1D4SO2QDd2CiBodWZKlcW39Vw3nGp6G3eZPW3mgUBewxgDQ/olHB0
         wdbg==
X-Gm-Message-State: AOAM530kaB/M6FmLb4Zkph2POg/WzVqCYuPI4+bdAiItHjiWX/q2RUKE
        jNB0smvh+yaYCnHf9pBQaxh8Eg+oVHENO7vhu34=
X-Google-Smtp-Source: ABdhPJwzWyVfYKukORY4wKtLu0o3+DLLOeIXp59ba2ugDU+wHNUy1vC9oR1e5a7sL4gNc54GOjUkySZjCY5HbpGJIkI=
X-Received: by 2002:a05:6830:134c:: with SMTP id r12mr2138684otq.240.1603819085680;
 Tue, 27 Oct 2020 10:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200929080324.632523-1-tientzu@chromium.org> <CALiNf28k5C48_ivAeRW7sSEEXp0gd-h_1n03YH6jQhYhaCXUDA@mail.gmail.com>
 <CALWDO_UqPS2eETieKHN_enJ-x+6C0Y8C7A0Jjg=a+L=of7Fz1w@mail.gmail.com>
In-Reply-To: <CALWDO_UqPS2eETieKHN_enJ-x+6C0Y8C7A0Jjg=a+L=of7Fz1w@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 27 Oct 2020 10:17:54 -0700
Message-ID: <CABBYNZJd2hGhNreNWwVzghHsjycGo+a9h5s5cOY+dJx3pNJ-0A@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Move force_bredr_smp debugfs into hci_debugfs_create_bredr
To:     Alain Michaud <alainmichaud@google.com>
Cc:     Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 10:12 AM Alain Michaud <alainmichaud@google.com> wrote:
>
> Friendly ping and adding my review-by tag.
>
>
> On Wed, Oct 7, 2020 at 12:38 AM Claire Chang <tientzu@chromium.org> wrote:
> >
> > Hi,
> >
> > This patch is to fix the kernel error
> > [   46.271811] debugfs: File 'force_bredr_smp' in directory 'hci0'
> > already present!
> >
> > When powering off and on the bluetooth, the smp_register will try to create the
> > force_bredr_smp entry again.
> > Move the creation to hci_debugfs_create_bredr so the force_bredr_smp entry will
> > only be created when HCI_SETUP and HCI_CONFIG are not set.
> >
> > Thanks,
> > Claire
> >
> > On Tue, Sep 29, 2020 at 4:03 PM Claire Chang <tientzu@chromium.org> wrote:
> > >
> > > Avoid multiple attempts to create the debugfs entry, force_bredr_smp,
> > > by moving it from the SMP registration to the BR/EDR controller init
> > > section. hci_debugfs_create_bredr is only called when HCI_SETUP and
> > > HCI_CONFIG is not set.
> > >
> > > Signed-off-by: Claire Chang <tientzu@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>

Reviewed-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

> > > ---
> > > v2: correct a typo in commit message
> > >
> > >  net/bluetooth/hci_debugfs.c | 50 +++++++++++++++++++++++++++++++++++++
> > >  net/bluetooth/smp.c         | 44 ++------------------------------
> > >  net/bluetooth/smp.h         |  2 ++
> > >  3 files changed, 54 insertions(+), 42 deletions(-)
> > >
> > > diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> > > index 5e8af2658e44..4626e0289a97 100644
> > > --- a/net/bluetooth/hci_debugfs.c
> > > +++ b/net/bluetooth/hci_debugfs.c
> > > @@ -494,6 +494,45 @@ static int auto_accept_delay_get(void *data, u64 *val)
> > >  DEFINE_SIMPLE_ATTRIBUTE(auto_accept_delay_fops, auto_accept_delay_get,
> > >                         auto_accept_delay_set, "%llu\n");
> > >
> > > +static ssize_t force_bredr_smp_read(struct file *file,
> > > +                                   char __user *user_buf,
> > > +                                   size_t count, loff_t *ppos)
> > > +{
> > > +       struct hci_dev *hdev = file->private_data;
> > > +       char buf[3];
> > > +
> > > +       buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y' : 'N';
> > > +       buf[1] = '\n';
> > > +       buf[2] = '\0';
> > > +       return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> > > +}
> > > +
> > > +static ssize_t force_bredr_smp_write(struct file *file,
> > > +                                    const char __user *user_buf,
> > > +                                    size_t count, loff_t *ppos)
> > > +{
> > > +       struct hci_dev *hdev = file->private_data;
> > > +       bool enable;
> > > +       int err;
> > > +
> > > +       err = kstrtobool_from_user(user_buf, count, &enable);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       err = smp_force_bredr(hdev, enable);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       return count;
> > > +}
> > > +
> > > +static const struct file_operations force_bredr_smp_fops = {
> > > +       .open           = simple_open,
> > > +       .read           = force_bredr_smp_read,
> > > +       .write          = force_bredr_smp_write,
> > > +       .llseek         = default_llseek,
> > > +};
> > > +
> > >  static int idle_timeout_set(void *data, u64 val)
> > >  {
> > >         struct hci_dev *hdev = data;
> > > @@ -589,6 +628,17 @@ void hci_debugfs_create_bredr(struct hci_dev *hdev)
> > >         debugfs_create_file("voice_setting", 0444, hdev->debugfs, hdev,
> > >                             &voice_setting_fops);
> > >
> > > +       /* If the controller does not support BR/EDR Secure Connections
> > > +        * feature, then the BR/EDR SMP channel shall not be present.
> > > +        *
> > > +        * To test this with Bluetooth 4.0 controllers, create a debugfs
> > > +        * switch that allows forcing BR/EDR SMP support and accepting
> > > +        * cross-transport pairing on non-AES encrypted connections.
> > > +        */
> > > +       if (!lmp_sc_capable(hdev))
> > > +               debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
> > > +                                   hdev, &force_bredr_smp_fops);
> > > +
> > >         if (lmp_ssp_capable(hdev)) {
> > >                 debugfs_create_file("ssp_debug_mode", 0444, hdev->debugfs,
> > >                                     hdev, &ssp_debug_mode_fops);
> > > diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> > > index 433227f96c73..8b817e4358fd 100644
> > > --- a/net/bluetooth/smp.c
> > > +++ b/net/bluetooth/smp.c
> > > @@ -3353,31 +3353,8 @@ static void smp_del_chan(struct l2cap_chan *chan)
> > >         l2cap_chan_put(chan);
> > >  }
> > >
> > > -static ssize_t force_bredr_smp_read(struct file *file,
> > > -                                   char __user *user_buf,
> > > -                                   size_t count, loff_t *ppos)
> > > +int smp_force_bredr(struct hci_dev *hdev, bool enable)
> > >  {
> > > -       struct hci_dev *hdev = file->private_data;
> > > -       char buf[3];
> > > -
> > > -       buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y': 'N';
> > > -       buf[1] = '\n';
> > > -       buf[2] = '\0';
> > > -       return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> > > -}
> > > -
> > > -static ssize_t force_bredr_smp_write(struct file *file,
> > > -                                    const char __user *user_buf,
> > > -                                    size_t count, loff_t *ppos)
> > > -{
> > > -       struct hci_dev *hdev = file->private_data;
> > > -       bool enable;
> > > -       int err;
> > > -
> > > -       err = kstrtobool_from_user(user_buf, count, &enable);
> > > -       if (err)
> > > -               return err;
> > > -
> > >         if (enable == hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
> > >                 return -EALREADY;
> > >
> > > @@ -3399,16 +3376,9 @@ static ssize_t force_bredr_smp_write(struct file *file,
> > >
> > >         hci_dev_change_flag(hdev, HCI_FORCE_BREDR_SMP);
> > >
> > > -       return count;
> > > +       return 0;
> > >  }
> > >
> > > -static const struct file_operations force_bredr_smp_fops = {
> > > -       .open           = simple_open,
> > > -       .read           = force_bredr_smp_read,
> > > -       .write          = force_bredr_smp_write,
> > > -       .llseek         = default_llseek,
> > > -};
> > > -
> > >  int smp_register(struct hci_dev *hdev)
> > >  {
> > >         struct l2cap_chan *chan;
> > > @@ -3433,17 +3403,7 @@ int smp_register(struct hci_dev *hdev)
> > >
> > >         hdev->smp_data = chan;
> > >
> > > -       /* If the controller does not support BR/EDR Secure Connections
> > > -        * feature, then the BR/EDR SMP channel shall not be present.
> > > -        *
> > > -        * To test this with Bluetooth 4.0 controllers, create a debugfs
> > > -        * switch that allows forcing BR/EDR SMP support and accepting
> > > -        * cross-transport pairing on non-AES encrypted connections.
> > > -        */
> > >         if (!lmp_sc_capable(hdev)) {
> > > -               debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
> > > -                                   hdev, &force_bredr_smp_fops);
> > > -
> > >                 /* Flag can be already set here (due to power toggle) */
> > >                 if (!hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
> > >                         return 0;
> > > diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
> > > index 121edadd5f8d..fc35a8bf358e 100644
> > > --- a/net/bluetooth/smp.h
> > > +++ b/net/bluetooth/smp.h
> > > @@ -193,6 +193,8 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
> > >  int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa);
> > >  int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16]);
> > >
> > > +int smp_force_bredr(struct hci_dev *hdev, bool enable);
> > > +
> > >  int smp_register(struct hci_dev *hdev);
> > >  void smp_unregister(struct hci_dev *hdev);
> > >
> > > --
> > > 2.28.0.618.gf4bc123cb7-goog
> > >



-- 
Luiz Augusto von Dentz
