Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926D23D0F17
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 15:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhGUMMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 08:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbhGUMMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 08:12:14 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23803C061574;
        Wed, 21 Jul 2021 05:52:51 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h2so2258330edt.3;
        Wed, 21 Jul 2021 05:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lopkcsr4P+MdAdY820YUCByo+p9D0uTSe24WA3N0bWE=;
        b=eqzyhtcaAHP6aZcni9mHwPJxWtbeDz+Y1LSAg/gBXGXsnYroQ1CDNYas06RC6x8gz4
         AE7SI/LWG+UkCIl1k65Z1c3qoXRlRjK8Q2wqh0knG9TO/cpGi7+0WXbXojrir3mFiTBT
         ebKzOEca4jjH5MtwWDJSD2BNpfwYTmZ7Xt1y+W3o+pfz3dkenvMKn//hYhjxZOvtsc0m
         IiJOpoPmXDWMUlZMzB1zGdGtTU/QPMGxDV+O9YcWY0ZbY5/e+VVVcQthn6JMy6YRRpdx
         6Nr+HJerBayJTOL5yARXbKxGrOm9OZo4D7iG8gPH/EddB4DtdRqZh2RNP+tQ4/Hah6qW
         KZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lopkcsr4P+MdAdY820YUCByo+p9D0uTSe24WA3N0bWE=;
        b=Qb1HWtcof95ltYIsKLidqYFo9apLzV9JTxK7N4sgkwAksxkrOlBJggtmTnVM2QmZA8
         prtaeQtNHWW/34/ZOd9ZndSPEtwkwP8+agupbEwp772qV+d1nPpdT8Vc2lPfkw5JMnm6
         27e0dD3lvCJxYOEebTgm2JPqn27by9rgOl/gNkuett9Z+XSHzHEtMALlAllLayA108a+
         UWwHHPlCjBk3vPdSuxODVx4QMCv+tFQnDlIgjuaMMObtJlGzGw2vP34f7cLYzsQ2JzDj
         sQtrWzGRBX+cKFyTEUeYzhxOk+0FoAVOc1MPFNRVaUuHVECrq9dmqSuw9zf6j9IM0qIw
         DChQ==
X-Gm-Message-State: AOAM530W7rfBUemoP/rnS0uZRr/xzDyu1uvb+WEmFzAkMMouWQwIU00L
        xgVvUPoVTFrhZ4De5uKX8Jc=
X-Google-Smtp-Source: ABdhPJyd4UBuTyZI4wZ4XjGR/XQCh5kjnHnFE7/PkvfsXgb2wlYwibfbXuty+872Yyk7495IaRIMEw==
X-Received: by 2002:a50:875d:: with SMTP id 29mr47512294edv.340.1626871969738;
        Wed, 21 Jul 2021 05:52:49 -0700 (PDT)
Received: from localhost.localdomain ([176.30.109.247])
        by smtp.gmail.com with ESMTPSA id g8sm10769279edv.84.2021.07.21.05.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 05:52:49 -0700 (PDT)
Date:   Wed, 21 Jul 2021 15:52:40 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Andre Naujoks <nautsch2@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Expose Peak USB device id in sysfs via phys_port_name.
Message-ID: <20210721155240.57887e6c@gmail.com>
In-Reply-To: <20210721124048.590426-1-nautsch2@gmail.com>
References: <20210721124048.590426-1-nautsch2@gmail.com>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 14:40:47 +0200
Andre Naujoks <nautsch2@gmail.com> wrote:

> The Peak USB CAN adapters can be assigned a device id via the Peak
> provided tools (pcan-settings). This id can currently not be set by
> the upstream kernel drivers, but some devices expose this id already.
> 
> The id can be used for consistent naming of CAN interfaces regardless
> of order of attachment or recognition on the system. The classical
> CAN Peak USB adapters expose this id via bcdDevice (combined with
> another value) on USB-level in the sysfs tree and this value is then
> available in ID_REVISION from udev. This is not a feasible approach,
> when a single USB device offers more than one CAN-interface, like
> e.g. the PCAN-USB Pro FD devices.
> 
> This patch exposes those ids via the, up to now unused, netdevice
> sysfs attribute phys_port_name as a simple decimal ASCII
> representation of the id. phys_port_id was not used, since the
> default print functions from net/core/net-sysfs.c output a
> hex-encoded binary value, which is overkill for a one-byte device id,
> like this one.


Hi, Andre!

You should add Signed-off-by tag to the patch


With regards,
Pavel Skripkin
