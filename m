Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3321F81C
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfEOQEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:04:02 -0400
Received: from canardo.mork.no ([148.122.252.1]:39073 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfEOQEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 12:04:01 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x4FG3xGQ029126
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 15 May 2019 18:03:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1557936239; bh=CEhGt63r3bUpl88fvbMEnMJJ7GaDnh3h0szbCq2k8t8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Nn+rg1Apk4n42d117cW3USgr0GWAeazs7Ro0q1EVS+R/rm3HZIXrIdbJO5+8e22cP
         +Py0oEFPPw+2ZpY2ShzIVwa6HDu1fSmioe3iQXZF3y/XagmMvtNjC829c9MFN5WjK5
         gKsU/OAlX/C1xXdAwYS4f5o46Nvu1KM+V9/DkiJo=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@mork.no>)
        id 1hQwNr-0008WB-CK; Wed, 15 May 2019 18:03:59 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions
Organization: m
References: <1557934183-8469-1-git-send-email-dnlplm@gmail.com>
Date:   Wed, 15 May 2019 18:03:59 +0200
In-Reply-To: <1557934183-8469-1-git-send-email-dnlplm@gmail.com> (Daniele
        Palmas's message of "Wed, 15 May 2019 17:29:43 +0200")
Message-ID: <87ftpfd7rk.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Added support for Telit LE910Cx 0x1260 and 0x1261 compositions.

Thanks.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
