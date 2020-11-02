Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE392A350A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKBUWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKBUWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:22:38 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264EFC0617A6;
        Mon,  2 Nov 2020 12:22:37 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 0A2KMXKQ014540
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 2 Nov 2020 21:22:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1604348553; bh=uojg2NR0ohBut5/6/moKQi4nEIE4JiYjkuOK+bu/p80=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=ft/Cg5xPBVQWOb7YzZuZZzI4SgDnk6rjfUAXcZi6jJ/ApdVNjMOpWz0+GZpzILtto
         bDXA26kOdJgvQSm97gCZkOmsW/+OMTPyvYu0+o0Zid4Ld2Or1S4GARlbVdz4arlJKl
         9OQn5yBLBGAaV5xplIEoavLT8WjbtMWyArH6pSUE=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kZgLY-000QL5-13; Mon, 02 Nov 2020 21:22:32 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
Organization: m
References: <20201102110108.17244-1-dnlplm@gmail.com>
Date:   Mon, 02 Nov 2020 21:22:31 +0100
In-Reply-To: <20201102110108.17244-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Mon, 2 Nov 2020 12:01:08 +0100")
Message-ID: <87blgf5x14.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> dd support for Telit LE910Cx 0x1230 composition:
>
> 0x1230: tty, adb, rmnet, audio, tty, tty, tty, tty
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
