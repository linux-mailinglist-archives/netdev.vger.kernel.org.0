Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532EB131A91
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgAFVfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgAFVfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 16:35:30 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930BE2146E
        for <netdev@vger.kernel.org>; Mon,  6 Jan 2020 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578346529;
        bh=3klmo43vWaZ8zqoPrQyOi7XPXZ4dEBC+uYpSOaUPegQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pBVnPKl8KQF/q2tzKYwP0DiVv5oPEZgbnxq/OCLe8pfgnlgFbNVW3MbsPVHoIKRWg
         Sb9apPTHEbkej9D4+WcfZs5VhGPjp8NVw2iogjobuy0iMWXj2/dHvM8BVXPzK1GFv/
         5WuiOd9jBxGWj0GCaxMnyHWpZaiPD3CsVk9ozBZI=
Received: by mail-qt1-f180.google.com with SMTP id q20so43669189qtp.3
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 13:35:29 -0800 (PST)
X-Gm-Message-State: APjAAAXkMW4JZcp1EOXfe55P/5umv31zHNViaKkrcHUWvHhoZ1K9Jw4v
        JR+/8uyf+RO7vHrlREjHtiQE0alOO/2nuBunZnQ=
X-Google-Smtp-Source: APXvYqxUhna8vC/QhED/hk+20u6I2fWVXtd3AFGBtjDg5h56YK39NE3POMtwk5bA71oAlZJspFOU65wjCyXoiK4u8as=
X-Received: by 2002:aed:24c7:: with SMTP id u7mr76187079qtc.335.1578346528807;
 Mon, 06 Jan 2020 13:35:28 -0800 (PST)
MIME-Version: 1.0
References: <20200106124908.3784-1-michal.kalderon@marvell.com>
In-Reply-To: <20200106124908.3784-1-michal.kalderon@marvell.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 6 Jan 2020 16:35:06 -0500
X-Gmail-Original-Message-ID: <CA+5PVA5rmLVdUV90uAStAMg5wczoK_W2PJJNY045c1=nJXKSTw@mail.gmail.com>
Message-ID: <CA+5PVA5rmLVdUV90uAStAMg5wczoK_W2PJJNY045c1=nJXKSTw@mail.gmail.com>
Subject: Re: [PATCH linux-firmware] qed: Add firmware 8.42.2.0
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ariel Elior <Ariel.Elior@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 6, 2020 at 7:52 AM Michal Kalderon
<michal.kalderon@marvell.com> wrote:
>
> This FW contains several fixes and features, main ones listed below.
>
> - RoCE
>         - SRIOV support
>         - Fixes in following flows:
>                 - latency optimization flow for inline WQEs
>                 - iwarp OOO packed DDPs flow
>                 - tx-dif workaround calculations flow
>                 - XRC-SRQ exceed cache num
>
> - iSCSI
>         - Fixes:
>                 - iSCSI TCP out-of-order handling.
>                 - iscsi retransmit flow
>
> - Fcoe
>         - Fixes:
>                 - upload + cleanup flows
>
> - Eth
>         - Support USO for non-tunneled UDP packets
>
> - Debug
>         - Better handling of extracting data during traffic
>
> Signed-off-by: Ariel Elior <Ariel.Elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> ---
>  WHENCE                                  |   1 +
>  qed/qed_init_values_zipped-8.42.2.0.bin | Bin 0 -> 890336 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100755 qed/qed_init_values_zipped-8.42.2.0.bin

Applied and pushed out.

josh
