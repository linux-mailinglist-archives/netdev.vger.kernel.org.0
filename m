Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF5942D8E3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJNML5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:11:57 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:40577 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhJNML4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:11:56 -0400
Received: by mail-oi1-f172.google.com with SMTP id n63so8177740oif.7;
        Thu, 14 Oct 2021 05:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3z60rehR7ZVtst9ELJ9rSkUSBJLTKGRibeWcRwMSZgk=;
        b=WrtiYALbzERDBcUDwA2hyIAU41A5HXYRW6cFdvAfOLDDF88FrXgCEGkpLcm0O7DdL6
         +eEMyP3G3HjkMHCnLlJ8YrtHft6nPH5vBHAcYJj+WXbNHawY55KZWOG0HTxf0ugpdUOw
         vjVqriKX8RdcUHrRrSnQbXMyQvgzMgGUznBC5IGPGoSag3oeDvhzqMpkvPA5TVz4k9uB
         pcrHYFxBzD0SAyXQuPqUpCwlX62K9NFvFO056n34XWyEwdqdY9MtVXYeXwYDfuX9NeVM
         OykruAota2g2+CuYmo1cHfY6U0muxK0hFkwc+pc6FBvg3JFZxlzPRJxFj1r+/qhY8k0C
         phKQ==
X-Gm-Message-State: AOAM533Z9eWnAbkewBU86uMTA/kH4ChYJ16cYz2oqih0UrQnO9hWYoUd
        xSyrZhLni/lYwv8YDJiMWqEldalhyjF+9uDahn0=
X-Google-Smtp-Source: ABdhPJxGAKTqMZdcGrmTBxMlNXrs3khgKNdNraJU8W3NnLPs+6KomixExRjU+vkSjfTKzdLZsQ1cbMQoQpDPjctKKZ8=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr12931946oif.51.1634213391218;
 Thu, 14 Oct 2021 05:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <1823864.tdWV9SEqCh@kailua> <6faf4b92-78d5-47a4-63df-cc2bab7769d0@molgen.mpg.de>
 <CAJZ5v0gf0y6qDHUJOsvLFctqn8tgKeuTYn5S9rb6+T0Sj26aKw@mail.gmail.com> <9965462.DAOxP5AVGn@pinacolada>
In-Reply-To: <9965462.DAOxP5AVGn@pinacolada>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 14 Oct 2021 14:09:39 +0200
Message-ID: <CAJZ5v0icUwksYVjKW0H5G0DNpfVHSyfm4oC782+Fsy56mQ330A@mail.gmail.com>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14
 ("The NVM Checksum Is Not Valid") [8086:1521]
To:     "Andreas K. Huettel" <andreas.huettel@ur.de>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kubakici@wp.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000abd39305ce4ef4db"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000abd39305ce4ef4db
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 12, 2021 at 9:36 PM Andreas K. Huettel
<andreas.huettel@ur.de> wrote:
>
> Am Dienstag, 12. Oktober 2021, 19:58:47 CEST schrieb Rafael J. Wysocki:
> > On Tue, Oct 12, 2021 at 7:42 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> > >
> > > [Cc: +ACPI maintainers]
> > >
> > > Am 12.10.21 um 18:34 schrieb Andreas K. Huettel:
> > > >>> The messages easily identifiable are:
> > > >>>
> > > >>> huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
> > > >>> Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethernet Network Driver
> > > >>> Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-2014 Intel Corporation.
> > > >>> Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling device (0000 -> 0002)
> > > >>
> > > >> This line is missing below, it indicates that the kernel couldn't or
> > > >> didn't power up the PCIe for some reason. We're looking for something
> > > >> like ACPI or PCI patches (possibly PCI-Power management) to be the
> > > >> culprit here.
> > > >
> > > > So I did a git bisect from linux-v5.10 (good) to linux-v5.14.11 (bad).
> > > >
> > > > The result was:
> > > >
> > > > dilfridge /usr/src/linux-git # git bisect bad
> > > > 6381195ad7d06ef979528c7452f3ff93659f86b1 is the first bad commit
> > > > commit 6381195ad7d06ef979528c7452f3ff93659f86b1
> > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Date:   Mon May 24 17:26:16 2021 +0200
> > > >
> > > >      ACPI: power: Rework turning off unused power resources
> > > > [...]
> > > >
> > > > I tried naive reverting of this commit on top of 5.14.11. That applies nearly cleanly,
> > > > and after a reboot the additional ethernet interfaces show up with their MAC in the
> > > > boot messages.
> > > >
> > > > (Not knowing how safe that experiment was, I did not go further than single mode and
> > > > immediately rebooted into 5.10 afterwards.)
> >
> > Reverting this is rather not an option, because the code before it was
> > a one-off fix of an earlier issue, but it should be fixable given some
> > more information.
> >
> > Basically, I need a boot log from both the good and bad cases and the
> > acpidump output from the affected machine.
> >
>
> https://dev.gentoo.org/~dilfridge/igb/
>
> ^ Should all be here now.
>
> 5.10 -> "good" log (the errors are caused by missing support for my i915 graphics and hopefully unrelated)
> 5.14 -> "bad" log
>
> Thank you for looking at this. If you need anything else, just ask.

You're welcome.

Please test the attached patch and let me know if it helps.

--000000000000abd39305ce4ef4db
Content-Type: text/x-patch; charset="US-ASCII"; name="acpi-power-turn-off-fixup.patch"
Content-Disposition: attachment; filename="acpi-power-turn-off-fixup.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kuqwejst0>
X-Attachment-Id: f_kuqwejst0

LS0tCiBkcml2ZXJzL2FjcGkvcG93ZXIuYyB8ICAgIDcgKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCA2IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LXBtL2RyaXZlcnMv
YWNwaS9wb3dlci5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LXBtLm9yaWcvZHJpdmVycy9hY3BpL3Bv
d2VyLmMKKysrIGxpbnV4LXBtL2RyaXZlcnMvYWNwaS9wb3dlci5jCkBAIC0xMDM1LDEzICsxMDM1
LDggQEAgdm9pZCBhY3BpX3R1cm5fb2ZmX3VudXNlZF9wb3dlcl9yZXNvdXJjZQogCWxpc3RfZm9y
X2VhY2hfZW50cnlfcmV2ZXJzZShyZXNvdXJjZSwgJmFjcGlfcG93ZXJfcmVzb3VyY2VfbGlzdCwg
bGlzdF9ub2RlKSB7CiAJCW11dGV4X2xvY2soJnJlc291cmNlLT5yZXNvdXJjZV9sb2NrKTsKIAot
CQkvKgotCQkgKiBUdXJuIG9mZiBwb3dlciByZXNvdXJjZXMgaW4gYW4gdW5rbm93biBzdGF0ZSB0
b28sIGJlY2F1c2UgdGhlCi0JCSAqIHBsYXRmb3JtIGZpcm13YXJlIG9uIHNvbWUgc3lzdGVtIGV4
cGVjdHMgdGhlIE9TIHRvIHR1cm4gb2ZmCi0JCSAqIHBvd2VyIHJlc291cmNlcyB3aXRob3V0IGFu
eSB1c2VycyB1bmNvbmRpdGlvbmFsbHkuCi0JCSAqLwogCQlpZiAoIXJlc291cmNlLT5yZWZfY291
bnQgJiYKLQkJICAgIHJlc291cmNlLT5zdGF0ZSAhPSBBQ1BJX1BPV0VSX1JFU09VUkNFX1NUQVRF
X09GRikgeworCQkgICAgcmVzb3VyY2UtPnN0YXRlID09IEFDUElfUE9XRVJfUkVTT1VSQ0VfU1RB
VEVfT04pIHsKIAkJCWFjcGlfaGFuZGxlX2RlYnVnKHJlc291cmNlLT5kZXZpY2UuaGFuZGxlLCAi
VHVybmluZyBPRkZcbiIpOwogCQkJX19hY3BpX3Bvd2VyX29mZihyZXNvdXJjZSk7CiAJCX0K
--000000000000abd39305ce4ef4db--
