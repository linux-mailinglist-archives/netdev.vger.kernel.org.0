Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D31586451
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbfHHO1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:27:09 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38113 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387769AbfHHO1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:27:09 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so119430132oth.5;
        Thu, 08 Aug 2019 07:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kfupe5BCBY7jnSL0f7BIF2NQvyUM9IcPYdq/C0xPwjo=;
        b=eBsLf4ymJd4TN1TmmVtWpS+ZvLVOln2SBpbkeYigaEHwcMXuaQS7D2/LjueqTfbWJR
         uWoLzYhviUsYYdPGq0kl5qd0B29UvdUgSxXehrB8HTSCE1XXN5vMabO4qNVsJAOIx6YC
         2/dvgD0CXyXpnV/ZTxm8prArw2a/H673BzmsI1odR9EnWnnI+kLBm4C+2X/rzaTl4fdT
         3g+tod2Jcs8Vg2u8K+ZHR0vHDjc8X80Fx8fM1GUHPmWMhdP3MZziOSdRED9LCM5DxJ/b
         qCHRQ2hqg7A687ZVzLS1JPWGYuTtMPU7IcI0Dp4wjCalaySQFsR9yYCxqgR9mlDSmJNw
         oecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kfupe5BCBY7jnSL0f7BIF2NQvyUM9IcPYdq/C0xPwjo=;
        b=jvgNY3CmzBwn+SMAGj5/tPuAsi1mP+/QQBzLvomC2iA4w3/LWcu910rc9aRTAMtIxk
         gwFEbcDS3khsxVM9PgPZ1/JhNxWrO0QYSLzCw22s+pnY5bePEZ0ZmBaFIl9OC7vNfU6K
         bR5ej2P5NDa2cQKeGVEyFydl36obJlCU7lWdjJl1qvYUGIjT2SBUEvzxz1TCukC6wpNK
         PJSsgnV/ay3IBXPMlUNnsyqnnDj+tLtYbZBVstzYvP20oDQNPLwqZtGqUWwAjCUGo0No
         s/JxAo4WzYv+WNRexiBqAmobQM3p4k6eteMH16UXEuaVpalA5hykCGW7McHVPP5RBp1X
         ZfJw==
X-Gm-Message-State: APjAAAW1/IJyfJ3ocpoXiLxxrWqhf5+oKA/2Bj6ASSjlYJLQrafHGPln
        paAqr9S31e4F85mUmMuLgsfZ/8NrOz/d4p7bgw==
X-Google-Smtp-Source: APXvYqyP1vcNnOqVtrNubvfjYGUmAcMf8O4IxgdBNXI6d0ODggbbZLLe1p7Z2PNdNyzA/kns9Rz4xd6na7idgKhgl2g=
X-Received: by 2002:a9d:27e2:: with SMTP id c89mr13553083otb.302.1565274428280;
 Thu, 08 Aug 2019 07:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAH040W7fdd-ND4-QG3DwGpFAPTMGB4zzuXYohMdfoSejV6XE_Q@mail.gmail.com>
 <CA+ASDXM6Jz7YY9XUj6QKv5VJCED-BnQ5K1UZHNApB9p6qTWtgg@mail.gmail.com> <F7CD281DE3E379468C6D07993EA72F84D1889B04@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1889B04@RTITMBSVM04.realtek.com.tw>
From:   =?UTF-8?B?6rOg7KSA?= <gojun077@gmail.com>
Date:   Thu, 8 Aug 2019 23:26:57 +0900
Message-ID: <CAH040W7x92Bb_zOh=g+B+j7sUnsUFh_O2+SXwqcymyjbyNHuXg@mail.gmail.com>
Subject: Re: Realtek r8822be wireless card fails to work with new rtw88 kernel module
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thanks for sharing the patch, Brian. I am seeing some progress when
building 5.3.0-rc1+ with
the wireless-drivers-next patch for the rtw88 kernel module. Before
the patch, my realtek r8822be
was not recognized at all.

After the patch, Realtek ethernet as well as wireless card r8822be are
recognized and I can see
a list of wireless access points. But for some reason, ping to my
local gateway servers (both
Ethernet and wireless) fail. Running tcpdump on my wireless and
ethernet interfaces shows
that ARP requests are showing up, but dns resolution doesn't work. I
can associate with a
wireless access point with wpa_supplicant and my ethernet port is
getting a DHCP lease from
my dhcp server, however.

And for YH~
Here is a dropbox link to debug info containing the output of dmesg,
lsmod, and journalctl -b0 zipped
up into a tarball:

https://www.dropbox.com/s/pl85ob09y6q2qky/debug_5.3.0-rc1%2B_with_rtw88_pat=
ch.tar.gz?dl=3D0

Thanks for your help!
Jun


Link to GPG Public Key:
https://keybase.io/gojun077#show-public


Backup link:
https://keys.openpgp.org/vks/v1/by-fingerprint/79F173A93EB3623D32F86309A569=
30CF7235138D


Link to GPG Public Key:

https://keybase.io/gojun077#show-public


Backup link:

https://keys.openpgp.org/vks/v1/by-fingerprint/79F173A93EB3623D32F86309A569=
30CF7235138D



On Wed, Aug 7, 2019 at 11:33 AM Tony Chuang <yhchuang@realtek.com> wrote:
>
> > + yhchuang
> >
> > On Tue, Aug 6, 2019 at 7:32 AM =EA=B3=A0=EC=A4=80 <gojun077@gmail.com> =
wrote:
> > >
> > > Hello,
> > >
> > > I recently reported a bug to Ubuntu regarding a regression in wireles=
s
> > > driver support for the Realtek r8822be wireless chipset. The issue
> > > link on launchpad is:
> > >
> > > https://bugs.launchpad.net/bugs/1838133
> > >
> > > After Canonical developers triaged the bug they determined that the
> > > problem lies upstream, and instructed me to send mails to the relevan=
t
> > > kernel module maintainers at Realtek and to the general kernel.org
> > > mailing list.
> > >
> > > I built kernel 5.3.0-rc1+ with the latest realtek drivers from
> > > wireless-drivers-next but my Realtek r8822be doesn't work with
> > > rtw88/rtwpci kernel modules.
> > >
> > > Please let me know if there is any additional information I can
> > > provide that would help in debugging this issue.
> >
> > Any chance this would help you?
> >
> > https://patchwork.kernel.org/patch/11065631/
> >
> > Somebody else was complaining about 8822be regressions that were fixed
> > with that.
> >
>
> I hope it could fix it.
>
> And as "r8822be" was dropped, it is preferred to use "rtw88" instead.
> I have received two kinds of failures that cause driver stop working.
> One is the MSI interrupt should be enabled on certain platforms.
> Another is the RFE type of the card, could you send more dmesg to me?
>
> Yan-Hsuan
>
>
