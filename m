Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB275303380
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 05:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbhAZE4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbhAYKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 05:40:18 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A745BC0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:17:46 -0800 (PST)
Received: from miraculix.mork.no (fwa142.mork.no [192.168.9.142])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10P8HQIN002354
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 25 Jan 2021 09:17:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611562646; bh=R7aulhCCO9sOx8R198iunkSx8yr8OXmBUyFDbNWK+ZA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=JXfX2u1rBjz4z6yykatnfF1MNf+b9D+14eTnf/rJaGHRQcV3XNpex0LCbH1lQh/NO
         hYorUPPwpdeDZ26e6MLg0VOysLEILiBTEd7m4cQB0NdrloUIA3Mr5PVXedD6RUjCgC
         GVTF4jq+9QDmR31dzisqRoB51zEYtIGY5ycHgvWc=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l3x3t-000ChL-BW; Mon, 25 Jan 2021 09:17:25 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org, aleksander@aleksander.es,
        dnlplm@gmail.com, stephan@gerhold.net, ejcaruso@google.com,
        andrewlassalle@google.com
Subject: Re: [PATCH net-next v2] net: qmi_wwan: Add pass through mode
Organization: m
References: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
Date:   Mon, 25 Jan 2021 09:17:25 +0100
In-Reply-To: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
        (Subash Abhinov Kasiviswanathan's message of "Mon, 25 Jan 2021
        00:33:35 -0700")
Message-ID: <87pn1tjuqy.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> writes:

> Pass through mode is to allow packets in MAP format to be passed
> on to the stack. rmnet driver can be used to process and demultiplex
> these packets.
>
> Pass through mode can be enabled when the device is in raw ip mode only.
> Conversely, raw ip mode cannot be disabled when pass through mode is
> enabled.
>
> Userspace can use pass through mode in conjunction with rmnet driver
> through the following steps-
>
> 1. Enable raw ip mode on qmi_wwan device
> 2. Enable pass through mode on qmi_wwan device
> 3. Create a rmnet device with qmi_wwan device as real device using netlink
>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Thanks!  Looks good, and takes us at least one small step closer to a
shared wwan userspace ABI

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
