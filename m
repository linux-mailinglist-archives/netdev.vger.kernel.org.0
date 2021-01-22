Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E39300086
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbhAVKmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbhAVKkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:40:13 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C56C0617A7
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 02:39:23 -0800 (PST)
Received: from miraculix.mork.no (fwa142.mork.no [192.168.9.142])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10MAdDUE010017
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 22 Jan 2021 11:39:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611311953; bh=Y5C2YkoUXFWHTkktIYy2NvpjZAoSl9Lv5eCh7/wqzwg=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=KyRCAkwmw/nTmaI64iU2iS+Lwyf0nkCFkwr1U4fYwIAlUkqMwqmQulmI1oXkxczCO
         OTbx0UkS0AVG5zweacysCxyjNSEm9RQW37W/deY7rAzl74SM4SYBkMaklIuwnvvamh
         CIMOH5TcDJYPKSEmc33t+mBMkPAmig+aqhF2YDpg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l2tqT-00340q-3s; Fri, 22 Jan 2021 11:39:13 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giacinto Cifelli <gciofono@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: qmi_wwan: added support for Thales
 Cinterion PLSx3 modem family
Organization: m
References: <20210120045650.10855-1-gciofono@gmail.com>
        <20210121170957.49ed2513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 22 Jan 2021 11:39:12 +0100
In-Reply-To: <20210121170957.49ed2513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Thu, 21 Jan 2021 17:09:57 -0800")
Message-ID: <877do51cj3.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Bjorn, I think this was posted before you pointed out the missing CCs
> and Giacinto didn't repost.
>
> Looks good?

Yes, LGTM

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
