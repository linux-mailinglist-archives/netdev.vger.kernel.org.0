Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E275129BC6C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809961AbgJ0Qc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:32:27 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45718 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1802506AbgJ0Ptv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 11:49:51 -0400
Received: by mail-lj1-f196.google.com with SMTP id t13so2171454ljk.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 08:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ke5nGbA4clAxIjt0JUhDX3ZTydTBVBs4rEWy4zdTpU=;
        b=K5xdihYBzdmUdNJQ2LLnUYlVrlt+QfwqeoklnM2hogn92aLb8d3vyflsafRufchaeZ
         CA7MOtlZBygfC8YYTcXvdHyg3H4Uc9aYpFEVh+8Gj/tAroF4BtXrBxUvz4AM/8XZlHHA
         Zmb9DdL4GELqH5gfrCkRyujlf/GGo8woHmmRa9QWuuIUUJbP+wQZyR9yMlFiys4T0i8A
         4hN2ipTGzA2WV6CzmbUbf/8AhBTplnO3NMNTMqFlNqilp4nIaexXKzqov+8pb8EnVwqb
         9imjsPRhep6QFj4/KoNQX9Y8gqUEJUh+gRwDUdG+SKp336qZzHh2M2GTo/x8mSQca1p+
         KX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ke5nGbA4clAxIjt0JUhDX3ZTydTBVBs4rEWy4zdTpU=;
        b=fvcSfKSh6MHk2nz0tuVeOfl21VhdQW4lJ89Re+LC2Z2m5US/Jynr1l261eklkVd5Os
         o1IaVn929Qj7yHbJnbBjC0zZQctHjWXFnM6oVOVP4wIxanHER+8IM0WP7t0T855FAWw/
         V3WuChv0Vi0WFqSWZsK7p5nQHc77O34xQ69TroJzkA8+szvd7AjlJ5n4e8pLndfPeTP0
         P/vRmOJ7cH/zM0FawdMgalVaGWLYGVJ/iI3zFZ0GU48QM9krejmAx1fVG63JKMcX5X9W
         V+6IFB6VoSo62rlrXN7N6RyzsROwwmJo7qUWucst4QM0xi6Lz9Kk8m2u2IgsfQ0VZbfO
         yjfQ==
X-Gm-Message-State: AOAM532vNwUOmw54h5DaQ68Yu3gEjCe0Ye+MMAn0npmP2hTblz1YoetJ
        /ILchCqOOxDUEbDPsXRXmeWP9szwLOnLHVZ9JedLbA==
X-Google-Smtp-Source: ABdhPJwfbeBJF996cAg1thYPCBkpc2GrcJEDHl23TWiE+xUY606hyiNlVhgw1Yb5IR3kgXwZnK/aLsWQ8YU0KFRB1M8=
X-Received: by 2002:a2e:351a:: with SMTP id z26mr1407846ljz.3.1603813786899;
 Tue, 27 Oct 2020 08:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200929080324.632523-1-tientzu@chromium.org> <CALiNf28k5C48_ivAeRW7sSEEXp0gd-h_1n03YH6jQhYhaCXUDA@mail.gmail.com>
In-Reply-To: <CALiNf28k5C48_ivAeRW7sSEEXp0gd-h_1n03YH6jQhYhaCXUDA@mail.gmail.com>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Tue, 27 Oct 2020 11:49:35 -0400
Message-ID: <CALWDO_UqPS2eETieKHN_enJ-x+6C0Y8C7A0Jjg=a+L=of7Fz1w@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Move force_bredr_smp debugfs into hci_debugfs_create_bredr
To:     Claire Chang <tientzu@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
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

Friendly ping and adding my review-by tag.


On Wed, Oct 7, 2020 at 12:38 AM Claire Chang <tientzu@chromium.org> wrote:
>
> Hi,
>
> This patch is to fix the kernel error
> [   46.271811] debugfs: File 'force_bredr_smp' in directory 'hci0'
> already present!
>
> When powering off and on the bluetooth, the smp_register will try to create the
> force_bredr_smp entry again.
> Move the creation to hci_debugfs_create_bredr so the force_bredr_smp entry will
> only be created when HCI_SETUP and HCI_CONFIG are not set.
>
> Thanks,
> Claire
>
> On Tue, Sep 29, 2020 at 4:03 PM Claire Chang <tientzu@chromium.org> wrote:
> >
> > Avoid multiple attempts to create the debugfs entry, force_bredr_smp,
> > by moving it from the SMP registration to the BR/EDR controller init
> > section. hci_debugfs_create_bredr is only called when HCI_SETUP and
> > HCI_CONFIG is not set.
> >
> > Signed-off-by: Claire Chang <tientzu@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
> > ---
> > v2: correct a typo in commit message
> >
> >  net/bluetooth/hci_debugfs.c | 50 +++++++++++++++++++++++++++++++++++++
> >  net/bluetooth/smp.c         | 44 ++------------------------------
> >  net/bluetooth/smp.h         |  2 ++
> >  3 files changed, 54 insertions(+), 42 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> > index 5e8af2658e44..4626e0289a97 100644
> > --- a/net/bluetooth/hci_debugfs.c
> > +++ b/net/bluetooth/hci_debugfs.c
> > @@ -494,6 +494,45 @@ static int auto_accept_delay_get(void *data, u64 *val)
> >  DEFINE_SIMPLE_ATTRIBUTE(auto_accept_delay_fops, auto_accept_delay_get,
> >                         auto_accept_delay_set, "%llu\n");
> >
> > +static ssize_t force_bredr_smp_read(struct file *file,
> > +                                   char __user *user_buf,
> > +                                   size_t count, loff_t *ppos)
> > +{
> > +       struct hci_dev *hdev = file->private_data;
> > +       char buf[3];
> > +
> > +       buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y' : 'N';
> > +       buf[1] = '\n';
> > +       buf[2] = '\0';
> > +       return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> > +}
> > +
> > +static ssize_t force_bredr_smp_write(struct file *file,
> > +                                    const char __user *user_buf,
> > +                                    size_t count, loff_t *ppos)
> > +{
> > +       struct hci_dev *hdev = file->private_data;
> > +       bool enable;
> > +       int err;
> > +
> > +       err = kstrtobool_from_user(user_buf, count, &enable);
> > +       if (err)
> > +               return err;
> > +
> > +       err = smp_force_bredr(hdev, enable);
> > +       if (err)
> > +               return err;
> > +
> > +       return count;
> > +}
> > +
> > +static const struct file_operations force_bredr_smp_fops = {
> > +       .open           = simple_open,
> > +       .read           = force_bredr_smp_read,
> > +       .write          = force_bredr_smp_write,
> > +       .llseek         = default_llseek,
> > +};
> > +
> >  static int idle_timeout_set(void *data, u64 val)
> >  {
> >         struct hci_dev *hdev = data;
> > @@ -589,6 +628,17 @@ void hci_debugfs_create_bredr(struct hci_dev *hdev)
> >         debugfs_create_file("voice_setting", 0444, hdev->debugfs, hdev,
> >                             &voice_setting_fops);
> >
> > +       /* If the controller does not support BR/EDR Secure Connections
> > +        * feature, then the BR/EDR SMP channel shall not be present.
> > +        *
> > +        * To test this with Bluetooth 4.0 controllers, create a debugfs
> > +        * switch that allows forcing BR/EDR SMP support and accepting
> > +        * cross-transport pairing on non-AES encrypted connections.
> > +        */
> > +       if (!lmp_sc_capable(hdev))
> > +               debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
> > +                                   hdev, &force_bredr_smp_fops);
> > +
> >         if (lmp_ssp_capable(hdev)) {
> >                 debugfs_create_file("ssp_debug_mode", 0444, hdev->debugfs,
> >                                     hdev, &ssp_debug_mode_fops);
> > diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> > index 433227f96c73..8b817e4358fd 100644
> > --- a/net/bluetooth/smp.c
> > +++ b/net/bluetooth/smp.c
> > @@ -3353,31 +3353,8 @@ static void smp_del_chan(struct l2cap_chan *chan)
> >         l2cap_chan_put(chan);
> >  }
> >
> > -static ssize_t force_bredr_smp_read(struct file *file,
> > -                                   char __user *user_buf,
> > -                                   size_t count, loff_t *ppos)
> > +int smp_force_bredr(struct hci_dev *hdev, bool enable)
> >  {
> > -       struct hci_dev *hdev = file->private_data;
> > -       char buf[3];
> > -
> > -       buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y': 'N';
> > -       buf[1] = '\n';
> > -       buf[2] = '\0';
> > -       return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> > -}
> > -
> > -static ssize_t force_bredr_smp_write(struct file *file,
> > -                                    const char __user *user_buf,
> > -                                    size_t count, loff_t *ppos)
> > -{
> > -       struct hci_dev *hdev = file->private_data;
> > -       bool enable;
> > -       int err;
> > -
> > -       err = kstrtobool_from_user(user_buf, count, &enable);
> > -       if (err)
> > -               return err;
> > -
> >         if (enable == hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
> >                 return -EALREADY;
> >
> > @@ -3399,16 +3376,9 @@ static ssize_t force_bredr_smp_write(struct file *file,
> >
> >         hci_dev_change_flag(hdev, HCI_FORCE_BREDR_SMP);
> >
> > -       return count;
> > +       return 0;
> >  }
> >
> > -static const struct file_operations force_bredr_smp_fops = {
> > -       .open           = simple_open,
> > -       .read           = force_bredr_smp_read,
> > -       .write          = force_bredr_smp_write,
> > -       .llseek         = default_llseek,
> > -};
> > -
> >  int smp_register(struct hci_dev *hdev)
> >  {
> >         struct l2cap_chan *chan;
> > @@ -3433,17 +3403,7 @@ int smp_register(struct hci_dev *hdev)
> >
> >         hdev->smp_data = chan;
> >
> > -       /* If the controller does not support BR/EDR Secure Connections
> > -        * feature, then the BR/EDR SMP channel shall not be present.
> > -        *
> > -        * To test this with Bluetooth 4.0 controllers, create a debugfs
> > -        * switch that allows forcing BR/EDR SMP support and accepting
> > -        * cross-transport pairing on non-AES encrypted connections.
> > -        */
> >         if (!lmp_sc_capable(hdev)) {
> > -               debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
> > -                                   hdev, &force_bredr_smp_fops);
> > -
> >                 /* Flag can be already set here (due to power toggle) */
> >                 if (!hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
> >                         return 0;
> > diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
> > index 121edadd5f8d..fc35a8bf358e 100644
> > --- a/net/bluetooth/smp.h
> > +++ b/net/bluetooth/smp.h
> > @@ -193,6 +193,8 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
> >  int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa);
> >  int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16]);
> >
> > +int smp_force_bredr(struct hci_dev *hdev, bool enable);
> > +
> >  int smp_register(struct hci_dev *hdev);
> >  void smp_unregister(struct hci_dev *hdev);
> >
> > --
> > 2.28.0.618.gf4bc123cb7-goog
> >
