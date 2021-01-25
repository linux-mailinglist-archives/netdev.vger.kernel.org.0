Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A92B302796
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbhAYQPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbhAYQP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:15:27 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31985C061786;
        Mon, 25 Jan 2021 08:14:47 -0800 (PST)
Received: from miraculix.mork.no (fwa142.mork.no [192.168.9.142])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10PGEdiJ030958
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 25 Jan 2021 17:14:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611591279; bh=UN3uOc7FebGzkt3Gvm088yaxFp7SRgBakJvkISXvozw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=gR+OmekVkJHD1dXGIxEKP6IkVlwgoP4VALDWx8mf0Akb2/qOBaGxypGCpkUiZ8kb/
         hYCQV/5l8u5kd/lhH17BbC7nrDhQIm+xABJ5hg+AaUjeoH3xiGeRZaBWkSTw7j6m74
         lS+77ooVLyFI/XGtt4ODgY4ScxzJ3IyN+ExPvUBU=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l44Vi-000ERv-NM; Mon, 25 Jan 2021 17:14:38 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next 2/2] net: qmi_wwan: document qmap/mux_id sysfs
 file
Organization: m
References: <20210125152235.2942-1-dnlplm@gmail.com>
        <20210125152235.2942-3-dnlplm@gmail.com>
Date:   Mon, 25 Jan 2021 17:14:38 +0100
In-Reply-To: <20210125152235.2942-3-dnlplm@gmail.com> (Daniele Palmas's
        message of "Mon, 25 Jan 2021 16:22:35 +0100")
Message-ID: <87sg6pf0y9.fsf@miraculix.mork.no>
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

> Document qmap/mux_id sysfs file showing qmimux interface id
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
