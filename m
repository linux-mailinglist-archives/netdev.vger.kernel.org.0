Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE951EC73D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgFCCTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFCCTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 22:19:45 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A869C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 19:19:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c8so534305iob.6
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 19:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqxoe4F+zar4p5ZPzPMm/CW9UltSPhroVL3v+waWLjM=;
        b=XYzSXCsCtHFy5tsgJus/ezzPY8QyLdDabXx6qT1o59Gb6QxsXNXqDIwTRnFiSipDfd
         sV7n2d2cPIER9WIvNv8KJoaGNOlZnxwg6LirCJYEAq6poBoEMxbKDfoYwVkRU7kJjHsC
         PYCVL/H1Pq62FO92wYAK+hjoEXm60adZbrPpFGGMKqP+H3UQI/5nRUsF8P9lO6Eb/Jy7
         Ir8nXt0eE52e3t8d7/zrEEbKMjE3Z51/xrTByB51xO3JZaAdd6PJDJsK2/a1ueL4Q6T9
         eGGMKb3ynQJuI7UQOsFo85GOt/YLITRTXzRJ7eEXhbbqcxRbzbxqDbs0An0xLp4ZhEP5
         H2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqxoe4F+zar4p5ZPzPMm/CW9UltSPhroVL3v+waWLjM=;
        b=JfeHmxiwUP6R11J0pwfrxhVgl7/KBkX7K4NEpk2sNGLKLJNNG4PWt62KEt1X7Sexkj
         gr8Jttjxd0vMnVELljwOk1ZZHcdDixLKcKbSj966NxrdctFXBNCB9GIou4MFWTqZxVd8
         A0dkt/ftLyPEJnG9KhBwSTkPNpRzuHkzdBmGTNtJ/mf/yPJTRF5Oj5cr8cM9ZrLH8gLk
         sPvFRDgSq8EWR6o0BQmjnCyF6JHBSfBbCjoozWkjzdsGeJYJde3kV6OgIlR9+wZ/TGjB
         gmfGF+sY7RNSJQgRY7xIL6+pb3S4E5mEzni/Xzb76e0p1tPlkBst0bzennmx6YO4tO/G
         89ZA==
X-Gm-Message-State: AOAM531+1BTVEDh4x3ZVj7LBPcxE8qT4zys/hd13dNEpP39+AjyMWdei
        g50JxOVuwXz/30+oZBhvkrcpjvBSgLmjgGO011I=
X-Google-Smtp-Source: ABdhPJypFUSjZBHf/cAH+mDhTTaHl5Z5lXb6pKIZdF/CvuqOCvcuQDvZ9Pox69mu8g382iwVGZpIxvrQhn+ZgL6nSWY=
X-Received: by 2002:a02:9a03:: with SMTP id b3mr8400895jal.76.1591150784550;
 Tue, 02 Jun 2020 19:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org> <20200602205456.2392024-5-linus.walleij@linaro.org>
In-Reply-To: <20200602205456.2392024-5-linus.walleij@linaro.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 3 Jun 2020 10:19:37 +0800
Message-ID: <CALW65jZT+_qoAtJx4ABKcWGS2V7CQvhwMGF1=acQZHhzHMzhbg@mail.gmail.com>
Subject: Re: [net-next PATCH 5/5] net: dsa: rtl8366: Use top VLANs for default
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus

On Wed, Jun 3, 2020 at 4:55 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> The RTL8366 DSA switches will not work unless we set
> up a default VLAN for each port. We are currently using
> e.g. VLAN 1..6 for a 5-port switch as default VLANs.
>
> This is not very helpful for users, move it to allocate
> the top VLANs for default instead, for example on
> RTL8366RB there are 16 VLANs so instead of using

RTL8366RB has full 4K vlan entry but you have to enable it manually.
https://github.com/openwrt/openwrt/blob/e73c61a978c56d41a2cdae4b5a2ca660aec4931b/target/linux/generic/files/drivers/net/phy/rtl8366rb.c#L43

> VLAN 1..6 as default use VLAN 10..15 so VLAN 1
> thru VLAN 9 is available for users.
>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/net/dsa/rtl8366.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> index 7f0691a6da13..4e7562b41598 100644
> --- a/drivers/net/dsa/rtl8366.c
> +++ b/drivers/net/dsa/rtl8366.c
> @@ -260,8 +260,8 @@ static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
>         u16 vid;
>         int ret;
>
> -       /* This is the reserved default VLAN for this port */
> -       vid = port + 1;
> +       /* Use the top VLANs for per-port default VLAN */
> +       vid = smi->num_vlan_mc - smi->num_ports + port;
>
>         if (port == smi->cpu_port)
>                 /* For the CPU port, make all ports members of this
> --
> 2.26.2
>
