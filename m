Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B0B32D8F7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 18:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhCDRtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 12:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbhCDRtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 12:49:03 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DCFC061756;
        Thu,  4 Mar 2021 09:48:23 -0800 (PST)
Received: from miraculix.mork.no (fwa152.mork.no [192.168.9.152])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 124Hm75L029873
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 4 Mar 2021 18:48:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1614880088; bh=k8lipC/E54Rd/FqQsV+Pc4PWUTaqSq6y7rRIFcTRNak=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=FHU1uGMg4/ZpI4VMybQTKbXaUyEUWip1IMfgsqfRqsH+nsmLbEw9HGuJdQj4eApIO
         sUD2EPMVYgATBIScJRPja5kPKB9t5agXRMXiw6PUHs1lPxIty8drp5jVUOki6pVsZy
         GXOum921HBnFgn1SPmEJYVVXdURsHuEDqIFWCyWg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1lHs50-0002Mi-HM; Thu, 04 Mar 2021 18:48:06 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: allow qmimux add/del with
 master up
Organization: m
References: <20210304131513.3052-1-dnlplm@gmail.com>
Date:   Thu, 04 Mar 2021 18:48:06 +0100
In-Reply-To: <20210304131513.3052-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Thu, 4 Mar 2021 14:15:13 +0100")
Message-ID: <87lfb2kdyh.fsf@miraculix.mork.no>
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

> There's no reason for preventing the creation and removal
> of qmimux network interfaces when the underlying interface
> is up.
>
> This makes qmi_wwan mux implementation more similar to the
> rmnet one, simplifying userspace management of the same
> logical interfaces.
>
> Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
> Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
