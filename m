Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6F330279C
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbhAYQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730166AbhAYQPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:15:25 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2578C06174A;
        Mon, 25 Jan 2021 08:14:44 -0800 (PST)
Received: from miraculix.mork.no (fwa142.mork.no [192.168.9.142])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10PGESLM030953
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 25 Jan 2021 17:14:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611591269; bh=4po88yvHbN9rDf0HPUyJazR4ASJjS2C7cpaiWNQFHOE=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=KKcJlqjGS7oNljmGoi9CTNd3zye+M2uHYf0I1PvHgpePYXLSNJ38r/HdIxE3G60l0
         HE3DItOMqyUNxyMckyu0oVrJlV5ohDIHqw6b2ULD1tZ8Zs4IAXFmLxvl1yMFvZHcEO
         e1RF6yh4ufHp74U73f0l8/4Sm2nArxBmuRUVrUaw=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l44VY-000ERq-5U; Mon, 25 Jan 2021 17:14:28 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next 1/2] net: usb: qmi_wwan: add qmap id sysfs file
 for qmimux interfaces
Organization: m
References: <20210125152235.2942-1-dnlplm@gmail.com>
        <20210125152235.2942-2-dnlplm@gmail.com>
Date:   Mon, 25 Jan 2021 17:14:28 +0100
In-Reply-To: <20210125152235.2942-2-dnlplm@gmail.com> (Daniele Palmas's
        message of "Mon, 25 Jan 2021 16:22:34 +0100")
Message-ID: <87wnw1f0yj.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Add qmimux interface sysfs file qmap/mux_id to show qmap id set
> during the interface creation, in order to provide a method for
> userspace to associate QMI control channels to network interfaces.
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

