Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2C380BA3
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhENOTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhENOTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C73C61408;
        Fri, 14 May 2021 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621001918;
        bh=c7dfcDSUedN/VQoQv/XM8fRZG2HhOOW57vq4i3XI37w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OQ+w8jq41p/pK8QPzt383K43rnWDvG9IebEZzoZj7WKu0EgpEM3a4OB9pZnDV5/lC
         MxVWpkmQpp2inFtKTGn6bM1fAR+gA+04aBXFsHrR34k+VM9wQUFTEenWCHNxw8mV5S
         Rr3kzMIGVT+KJ8CgQJfj5jt0KJvZQg0gfBfD7ImGjDrz6TXEWqjpD0nn1NC8t6bBSV
         Y2m7PBzQCXheFvsYF9jZqx3chr66nJXcElBiHfvACPcxjY0VNJoiSeft4M6sPjRp9i
         /15Ta8qfh6z3LjSIBpnNeZl0hFKEsFjvWWGKfF/qxDT0jcgdTLCyifuXI2D1S1QhIL
         whK9i7cORQs2g==
Date:   Fri, 14 May 2021 16:18:25 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
Message-ID: <20210514161825.4e4c0d3e@coco.lan>
In-Reply-To: <8b8bc929-2f07-049d-f24c-cb1f1d85bbaa@gmail.com>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
        <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
        <20210514102118.1b71bec3@coco.lan>
        <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
        <8b8bc929-2f07-049d-f24c-cb1f1d85bbaa@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 14 May 2021 12:08:36 +0100
Edward Cree <ecree.xilinx@gmail.com> escreveu:

> For anyone who doesn't know about it: X has this wonderful thing called
>  the Compose key[1].  For instance, type =E2=8E=84--- to get =E2=80=94, o=
r =E2=8E=84<" for =E2=80=9C.
> Much more mnemonic than Unicode codepoints; and you can extend it with
>  user-defined sequences in your ~/.XCompose file.

Good tip. I haven't use composite for years, as US-intl with dead keys is
enough for 99.999% of my needs.=20

Btw, at least on Fedora with Mate, Composite is disabled by default. It has
to be enabled first using the same tool that allows changing the Keyboard
layout[1].

Yet, typing an EN DASH for example, would be "<composite>--.", with is 4
keystrokes instead of just two ('--'). It means twice the effort ;-)

[1] KDE, GNome, Mate, ... have different ways to enable it and to=20
    select what key would be considered <composite>:

	https://dry.sailingissues.com/us-international-keyboard-layout.html
	https://help.ubuntu.com/community/ComposeKey

Thanks,
Mauro
