Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AFCE1B20
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403789AbfJWMpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403753AbfJWMpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 08:45:31 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACCF621929
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 12:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571834730;
        bh=v8xwOn31STsJftXdqockqMY2KIiIniWkhz+XoIn91vk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e0BVBRU2h+t2mMWvNg0dTfOz6oEnX3GJLRTgIpUF9KnBrFQWjLo0dAMqx+95Zns9E
         dourU0g2L5ToRLyW29VLgmP80aSW9w5r4+VjDSET1BxO4nc+nzVEmjJqHhH/vHmZqy
         Zd5ZN4VwGlJ7TaoUXwgJxeVN0MBjzgdFKK00S/7s=
Received: by mail-qk1-f177.google.com with SMTP id e66so19570227qkf.13
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 05:45:30 -0700 (PDT)
X-Gm-Message-State: APjAAAVxi2eGv4l+ASHN4F+y2AV1hcxDsIRymNM5R5GPvAa+3peO7ans
        FW7K3/uujvdNJH5SKapDHpIRvlZNV8HI7NthleE=
X-Google-Smtp-Source: APXvYqwC5EmAdjIQhmFtXqA3sbyDBugMYwggrx0HkA1q8Rq7JbXP0FeM2d5OmXV5bKgcrI3XEsPg7lknQHdhLD2nXC4=
X-Received: by 2002:a37:6ec3:: with SMTP id j186mr4390643qkc.224.1571834729790;
 Wed, 23 Oct 2019 05:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <1394712342-15778-335-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-335-Taiwan-albertk@realtek.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Wed, 23 Oct 2019 08:45:18 -0400
X-Gmail-Original-Message-ID: <CA+5PVA63LaeTQ8QmU6-GLsoe+D84vD-OqwH3eArCtuq8B-8qwQ@mail.gmail.com>
Message-ID: <CA+5PVA63LaeTQ8QmU6-GLsoe+D84vD-OqwH3eArCtuq8B-8qwQ@mail.gmail.com>
Subject: Re: [PATCH firmware] rtl_nic: add firmware files for RTL8153
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        netdev <netdev@vger.kernel.org>, pmalani@chromium.org,
        grundler@chromium.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 11:40 PM Hayes Wang <hayeswang@realtek.com> wrote:
>
> This adds the firmware for Realtek RTL8153 Based USB Ethernet Adapters.
>
> 1. Fix compatible issue for Asmedia hub.
> 2. Fix compatible issue for Compal platform.
> 3. Fix sometimes the device is lost after rebooting.
> 4. Improve the compatibility for EEE.
>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  WHENCE                |  11 +++++++++++
>  rtl_nic/rtl8153a-2.fw | Bin 0 -> 1768 bytes
>  rtl_nic/rtl8153a-3.fw | Bin 0 -> 1440 bytes
>  rtl_nic/rtl8153a-4.fw | Bin 0 -> 712 bytes
>  rtl_nic/rtl8153b-2.fw | Bin 0 -> 1088 bytes
>  5 files changed, 11 insertions(+)
>  create mode 100644 rtl_nic/rtl8153a-2.fw
>  create mode 100644 rtl_nic/rtl8153a-3.fw
>  create mode 100644 rtl_nic/rtl8153a-4.fw
>  create mode 100644 rtl_nic/rtl8153b-2.fw

Applied and pushed out.

josh
