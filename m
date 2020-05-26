Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17771E1C6B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgEZHnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 03:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgEZHnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 03:43:52 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0172DC061A0E
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 00:43:51 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 04Q7hkjb032744
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 26 May 2020 09:43:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1590479026; bh=R8KKjUWgapLl4auxe9lG2Om3IouPth+S2fKVt+6G16E=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Psfo51O8nOfTz581Wf7r+4Ydk2aDwsea02BozZ1SjuhqORt/m0yD2pUg3crczRZOF
         ypbFc5QtOcpABeEaFqp/KxuFp5G5zC/MENwGvK4ldhadnZMW/wlrb8ZsVhlR0Axr+O
         RFXWXD1yiFW999WJmie3DbJZLcoJEbnveGc04lWA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jdUFW-0007sO-2e; Tue, 26 May 2020 09:43:46 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit LE910C1-EUX composition
Organization: m
References: <20200525212537.2227-1-dnlplm@gmail.com>
Date:   Tue, 26 May 2020 09:43:46 +0200
In-Reply-To: <20200525212537.2227-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Mon, 25 May 2020 23:25:37 +0200")
Message-ID: <87o8qbcf9p.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Add support for Telit LE910C1-EUX composition
>
> 0x1031: tty, tty, tty, rmnet
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
