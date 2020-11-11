Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A762AF050
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgKKMNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgKKMMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:12:38 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D61BC0613D1;
        Wed, 11 Nov 2020 04:12:36 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 0ABCBmFH011523
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 11 Nov 2020 13:11:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1605096711; bh=PzblEsfSrO3GtY84kjQdy9Rw04qGLrrzC+BWsQIpWfY=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=eFMBfQiNoiiVyQZD0560zXKiefHBxBlsAraEdNM4ZrrJ9FLmFpbTnjVs9wh2tHT67
         /LWCr6e4/VNId8uyT7zwYBBRAB4JwA5Ph7/YQc7yXpehoSzaGBhCfbOGlwX8YnPmhK
         ZGYPD1wqvv5ZdeoeuycVdBouvoyHjbDvwDuXHkn4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kcoyZ-002900-Og; Wed, 11 Nov 2020 13:11:47 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] qmi_wwan: switch to core handling of rx/tx byte/packet counters
Organization: m
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
        <c3eb3707-cac8-5db2-545d-8a3b4de39dad@gmail.com>
Date:   Wed, 11 Nov 2020 13:11:47 +0100
In-Reply-To: <c3eb3707-cac8-5db2-545d-8a3b4de39dad@gmail.com> (Heiner
        Kallweit's message of "Tue, 10 Nov 2020 20:48:14 +0100")
Message-ID: <87r1p0qeik.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> Use netdev->tstats instead of a member of qmimux_priv for storing
> a pointer to the per-cpu counters. This allows us to use core
> functionality for statistics handling.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
