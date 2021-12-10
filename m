Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAAA46FF06
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhLJKyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbhLJKyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:54:20 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52715C061746;
        Fri, 10 Dec 2021 02:50:45 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1BAAoOd72262583
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 10 Dec 2021 11:50:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1639133425; bh=9IETmGmOqkXosvhm5TAL9lHkV0QlddDMQBQe1qr0tn0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=lflJp8B7hnNNzWkN5S2ntKfPRqfPUlw676mc3SFr/JQ0j+zbruHEcfKofloHn0PBx
         /IFbSs6TdMsGk8sTGxacqscRRRcjcutBB+SEYhKQjy4pW71nl4AVUPHb6WaW94y3TG
         26+r7xEeenibRv6+5tAy1DjtIN+0naxdNjPTA3TM=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mvdTr-000FLx-Lp; Fri, 10 Dec 2021 11:50:23 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1070 composition
Organization: m
References: <20211210095722.22269-1-dnlplm@gmail.com>
Date:   Fri, 10 Dec 2021 11:50:23 +0100
In-Reply-To: <20211210095722.22269-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Fri, 10 Dec 2021 10:57:22 +0100")
Message-ID: <87r1akraxc.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Add the following Telit FN990 composition:
>
> 0x1070: tty, adb, rmnet, tty, tty, tty, tty
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
