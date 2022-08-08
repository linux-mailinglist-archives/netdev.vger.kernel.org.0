Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A5258CF88
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiHHVPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbiHHVPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:15:33 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5248918B09
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 14:15:31 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id h22so7488561qta.3
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 14:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VWKYbqcm/zkrBcBzoLS3ZTYJbY0tUU+EcrNkjCdj7S0=;
        b=nGmDOiCn314TP/pVmtD+j8Y5FoAnmN4zBDQEpRs8YX5r/QVGn4HP2B+1LR+VyvxONJ
         TOr5lOBgRXsybaArJDbacDDtsfiSAw+TE4YhFcLgUp5zroer9zcXfyiINiAwkWLUmyPL
         1AwWAFp6tf+RsQxqegsRmhbTEgcxE12zyjK0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VWKYbqcm/zkrBcBzoLS3ZTYJbY0tUU+EcrNkjCdj7S0=;
        b=XOepdKG1enjJ8ftQruf0rusRBZRxPU8/6TuYXehUfa8aZNDi4OnoPa1slLEKASUOfn
         HZgYwEf46XO21MwWpd9BB9ISV0J7c7/TFZQ//y7ES0NYJVolV5zCmuVYyiEPZXF9fbLu
         SwSXdGEWYuCbuxvtcieTXQp71hJcARAUWqLXiWNIph+nm33e97xvlWjH0aYxPL9VU0U2
         BFCjlcRm8+7mcR/j0kLTGgxT8eCkmduiaaaUmZ4haDKbwdecZSBnzkpz2I7D49XzEx1F
         CTxolmJHTushwyQrsPDeNyxrkE7NzttL6HdxtmLFXgzK7p7aFJRP9jRszsomOfxy2DIF
         LomQ==
X-Gm-Message-State: ACgBeo0mTuT3gLzLdk7cWQXdeY6XEBJgZOnyfhHmJWHboYuFti29NBTU
        fkOhmbMhVGYcg6iS3HyLNxfeEse25y/IYSXXSs2Dxg==
X-Google-Smtp-Source: AA6agR5sewPOGNHWjiSoW/6wGiHTZHHUJSKNA99Rq4EnGsi95IuluLbvqgw4PQh3p9Eb9KFLiVh1/uETXfrsHPJ9Mms=
X-Received: by 2002:a05:622a:190a:b0:342:f8d9:b1dc with SMTP id
 w10-20020a05622a190a00b00342f8d9b1dcmr5914468qtc.656.1659993330432; Mon, 08
 Aug 2022 14:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220808110315.1.I5a39052e33f6f3c7406f53b0304a32ccf9f340fa@changeid>
 <CABBYNZJf_6SmRD0tUUUfxfpZOksL-=5jLN8+5c4cZcQB6J-xbg@mail.gmail.com>
In-Reply-To: <CABBYNZJf_6SmRD0tUUUfxfpZOksL-=5jLN8+5c4cZcQB6J-xbg@mail.gmail.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 8 Aug 2022 14:15:19 -0700
Message-ID: <CANFp7mW_OBb3rc-6tpYvAPA8f=J_tRN+HJc875Dyr3HjzDAQ8A@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Ignore cmd_timeout with HCI_USER_CHANNEL
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 8, 2022 at 1:31 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Abhishek,
>
> On Mon, Aug 8, 2022 at 11:04 AM Abhishek Pandit-Subedi
> <abhishekpandit@google.com> wrote:
> >
> > From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >
> > When using HCI_USER_CHANNEL, hci traffic is expected to be handled by
> > userspace entirely. However, it is still possible (and sometimes
> > desirable) to be able to send commands to the controller directly. In
> > such cases, the kernel command timeout shouldn't do any error handling.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> > This was tested by running a userchannel stack and sending commands via
> > hcitool cmd on an Intel AX200 controller. Without this change, each
> > command sent via hcitool would result in hci_cmd_timeout being called
> > and after 5 commands, the controller would reset.
> >
> > Hcitool continues working here because it marks the socket as
> > promiscuous and gets a copy of all traffic while the socket is open (and
> > does filtering in userspace).
>
> There is something not quite right here, if you have a controller
> using user_channel (addr.hci_channel = HCI_CHANNEL_USER) it probably
> shouldn't even accept to be opened again by the likes of hcitool which
> uses HCI_CHANNEL_RAW as it can cause conflicts. If you really need a
> test tool that does send the command while in HCI_CHANNEL_USER then it
> must be send on that mode but I wouldn't do it with hcitool anyway as
> that is deprecated and this exercise seem to revolve to a entire stack
> on top of HCI_USER_CHANNEL then you shall use tools of that stack and
> mix with BlueZ userspace tools.

Our goal is eventually consistent with that aim (not having multiple
users to the socket when using HCI_CHANNEL_USER).

In the interim however, we have existing tooling that expects to be
able to write raw hci to the controller, get responses and not expect
any crashes (Intel Wireless Reporting Tools for example). hcitool is
just an easy test tool here and the real behavior being tested is RAW
channel injections not triggering the cmd timeout.

>
> > Tested on Chromebook with 5.4 kernel with patch (and applied cleanly on
> > bluetooth-next).
> >
> >  net/bluetooth/hci_core.c | 26 +++++++++++++++++---------
> >  1 file changed, 17 insertions(+), 9 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index b3a5a3cc9372..c9a15f6633f7 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1481,17 +1481,25 @@ static void hci_cmd_timeout(struct work_struct *work)
> >         struct hci_dev *hdev = container_of(work, struct hci_dev,
> >                                             cmd_timer.work);
> >
> > -       if (hdev->sent_cmd) {
> > -               struct hci_command_hdr *sent = (void *) hdev->sent_cmd->data;
> > -               u16 opcode = __le16_to_cpu(sent->opcode);
> > +       /* Don't trigger the timeout behavior if it happens while we're in
> > +        * userchannel mode. Userspace is responsible for handling any command
> > +        * timeouts.
> > +        */
> > +       if (!(hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > +             test_bit(HCI_UP, &hdev->flags))) {
> > +               if (hdev->sent_cmd) {
> > +                       struct hci_command_hdr *sent =
> > +                               (void *)hdev->sent_cmd->data;
> > +                       u16 opcode = __le16_to_cpu(sent->opcode);
> >
> > -               bt_dev_err(hdev, "command 0x%4.4x tx timeout", opcode);
> > -       } else {
> > -               bt_dev_err(hdev, "command tx timeout");
> > -       }
> > +                       bt_dev_err(hdev, "command 0x%4.4x tx timeout", opcode);
> > +               } else {
> > +                       bt_dev_err(hdev, "command tx timeout");
> > +               }
> >
> > -       if (hdev->cmd_timeout)
> > -               hdev->cmd_timeout(hdev);
> > +               if (hdev->cmd_timeout)
> > +                       hdev->cmd_timeout(hdev);
> > +       }
>
> I wonder why hci_cmd_timeout is even active if the controller is in
> HCI_USER_CHANNEL mode, that sounds like a bug already.

This gets scheduled in hci_cmd_work. I tried not scheduling
hci_cmd_timeout in the first place but that caused the event stream to
hang (I think because subsequent tx work wasn't being scheduled). I
didn't dive very deep here and fix looked complex for a scenario that
we will migrate away from.

>
> >         atomic_set(&hdev->cmd_cnt, 1);
> >         queue_work(hdev->workqueue, &hdev->cmd_work);
> > --
> > 2.37.1.559.g78731f0fdb-goog
> >
>
>
> --
> Luiz Augusto von Dentz
