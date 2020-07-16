Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF97222824
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgGPQRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGPQRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:17:02 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93913C061755;
        Thu, 16 Jul 2020 09:17:02 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id e4so5546551oib.1;
        Thu, 16 Jul 2020 09:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X40K+wu84kv/mAn7oQZlyEv2lZtROdjFfXssqudkZyk=;
        b=CzQ7XtUl+MF8GX6TDg0e7SD3lj/qAvD2KStC71O3eWB9OfCW1BzsVvv/1iL8Y/mCQU
         fN4joOmmJ/0uBygZJGef06IoX4h0ZNXifm3VHogUnAyZF+JcP3a1A2oE0fy2dFP4kvGP
         xFwmr+MQ4KPFtF164bEtu/G5WF0V2aacWYR1UIw9DG6B9wXrAAKRf8fZMioRBck37MTT
         xDfVdarzCWeHMa0Mcm8G0uKITIWQrHyEZzqO/otpqo8m1gPlhSBO+cYLrrDuNmAXIUFr
         7PyR6Ypsa5VwoAihahqLjZVDJJOgD0mwVwE889vQFE/8GYrGcOFoobKSzHwwFrV7pbIR
         o9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X40K+wu84kv/mAn7oQZlyEv2lZtROdjFfXssqudkZyk=;
        b=CykDlEcmT1kC2H2aWyojyiVqPNLX4xGvnAWSj6ivw4caP+btFOqHpOk7SZF0PtQMWG
         sheJrM6/xt7VAFOUAxRCfKcm6Wiau5JGQqoEeKjIUSPYoOBb1MlbLwzx2JDUifBnv7m/
         1kbb0SiI/9H1T644Q1oi2oKq/Y/1acXwOjwHpTkC4DBtzDgE8LmVqqNjwUL2XAdhNWJO
         mI0ESsGnUI2dHnvnINkMmhaEoz7fvRuL0uv4dA5URN9ZQUkqixJjYoHepmkjlgjfP+Rj
         n/cn09D4bb0AZbrsNerRFabWI0bRgSsa+AzjGPwU8t++HeLRC3/boYFNk7+aY8chbRu9
         TfbQ==
X-Gm-Message-State: AOAM533UAvdZIP7ou/bfURfOfdmI2I3BgZL4on2LjmFbbGWjkIZJel1X
        Ip4EDAkrcRN30O+zjhMMSqp+ErqpBjSHBJMxcug5waNjv+M=
X-Google-Smtp-Source: ABdhPJyMB5in8yNJ9qyfWT0teHY8MlwUvugWwOfShB8Gk0BOZqaBFWTvfCAz9fPqJKDu2FcmeWO5eTMrRY/82Sq3lYQ=
X-Received: by 2002:aca:cf81:: with SMTP id f123mr4528403oig.137.1594916221887;
 Thu, 16 Jul 2020 09:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <3635193ecd8c6034731387404825e998df2fd788.camel@redhat.com>
In-Reply-To: <3635193ecd8c6034731387404825e998df2fd788.camel@redhat.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 16 Jul 2020 09:16:50 -0700
Message-ID: <CABBYNZ+YOJQi9a=pU2cc9czH1VoL04SdaXfnDksakCCfxx-skA@mail.gmail.com>
Subject: Re: Commit 'Bluetooth: Consolidate encryption handling in
 hci_encrypt_cfm' broke my JBL TUNE500BT headphones
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

On Thu, Jul 16, 2020 at 1:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> Hi,
>
> Few days ago I bisected a recent regression in the 5.8 kernel:
>
> git bisect start
> # good: [3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162] Linux 5.7
> git bisect good 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
> # bad: [dcde237b9b0eb1d19306e6f48c0a4e058907619f] Merge tag 'perf-tools-fixes-2020-07-07' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
> git bisect bad dcde237b9b0eb1d19306e6f48c0a4e058907619f
> # bad: [a0a4d17e02a80a74a63c7cbb7bc8cea2f0b7d8b1] Merge branch 'pcmcia-next' of git://git.kernel.org/pub/scm/linux/kernel/git/brodo/linux
> git bisect bad a0a4d17e02a80a74a63c7cbb7bc8cea2f0b7d8b1
> # good: [09587a09ada2ed7c39aedfa2681152b5ac5641ee] arm64: mm: use ARCH_HAS_DEBUG_WX instead of arch defined
> git bisect good 09587a09ada2ed7c39aedfa2681152b5ac5641ee
> # good: [3248044ecf9f91900be5678919966715f1fb8834] Merge tag 'wireless-drivers-next-2020-05-25' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
> git bisect good 3248044ecf9f91900be5678919966715f1fb8834
> # bad: [cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> git bisect bad cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2
> # bad: [b8215dce7dfd817ca38807f55165bf502146cd68] selftests/bpf, flow_dissector: Close TAP device FD after the test
> git bisect bad b8215dce7dfd817ca38807f55165bf502146cd68
> # good: [b8ded9de8db34dd209a3dece94cf54fc414e78f7] net/smc: pre-fetch send buffer outside of send_lock
> git bisect good b8ded9de8db34dd209a3dece94cf54fc414e78f7
> # good: [1079a34c56c535c3e27df8def0d3c5069d2de129] Merge tag 'mac80211-next-for-davem-2020-05-31' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
> git bisect good 1079a34c56c535c3e27df8def0d3c5069d2de129
> # bad: [f395b69f40f580491ef56f2395a98e3189baa53c] dpaa2-eth: Add PFC support through DCB ops
> git bisect bad f395b69f40f580491ef56f2395a98e3189baa53c
> # bad: [a74d19ba7c41b6c1e424ef4fb7d4600f43ff75e5] net: fec: disable correct clk in the err path of fec_enet_clk_enable
> git bisect bad a74d19ba7c41b6c1e424ef4fb7d4600f43ff75e5
> # bad: [dafe2078a75af1abe4780313ef8dd8491ba8598f] ipv4: nexthop: Fix deadcode issue by performing a proper NULL check
> git bisect bad dafe2078a75af1abe4780313ef8dd8491ba8598f
> # bad: [feac90d756c03b03b83fabe83571bd88ecc96b78] Bluetooth: hci_qca: Fix suspend/resume functionality failure
> git bisect bad feac90d756c03b03b83fabe83571bd88ecc96b78
> # good: [a228f7a410290d836f3a9f9b1ed5aef1aab25cc7] Bluetooth: hci_qca: Enable WBS support for wcn3991
> git bisect good a228f7a410290d836f3a9f9b1ed5aef1aab25cc7
> # bad: [755dfcbca83710fa967d0efa7c5bb601f871a747] Bluetooth: Fix assuming EIR flags can result in SSP authentication
> git bisect bad 755dfcbca83710fa967d0efa7c5bb601f871a747
> # bad: [3ca44c16b0dcc764b641ee4ac226909f5c421aa3] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
> git bisect bad 3ca44c16b0dcc764b641ee4ac226909f5c421aa3
> # first bad commit: [3ca44c16b0dcc764b641ee4ac226909f5c421aa3] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm

We just merged a fix for that:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=339ddaa626995bc6218972ca241471f3717cc5f4

> The sympthoms are that I am unable to pair the headphones, and even if I use an older kernel
> to pair them, and then switch to the new kernel, the connection is established only sometimes.
>
> Without this commit, I can pair the headphones 100% of the time.
>
> I am not familiar with bluetooth debugging but I am willing to provide
> any logs, do tests and try patches.
>
> I am running fedora 32 on the affected system which has built-in intel wireless/bluetooth card,
>
> PCI (wifi) part:
> 47:00.0 Network controller: Intel Corporation Wi-Fi 6 AX200 (rev 1a)
>
> USB (bluetooth) parrt:
> Bus 011 Device 004: ID 8087:0029 Intel Corp.
>
> My .config attached (custom built kernel)
>
> Best regards,
>         Maxim Levitsky
>


-- 
Luiz Augusto von Dentz
