Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64ED06ADD2F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjCGLX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCGLXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:23:25 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E0C7AB7;
        Tue,  7 Mar 2023 03:23:21 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 949B9124;
        Tue,  7 Mar 2023 12:23:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678188199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kud8FCW1ncszCFeh5qTG1mhzpHCc7GzCG2rxLsiGAhY=;
        b=H4FCz/nMZ9ruMes/cxEYykWsvOY/SGBcSLKM2RZEnKt+zdrPDUFwRPJFpX9HHZuuWMjzly
        /BtzTZqvUbh3mu3tOd9qL/yjDJq6HTfe7MEYO968G9O8bd+bkjDoEWX01rY/M4ZPChjNyl
        1NxZxMFrzg/oMDb/Z8GX82F2PjcKgqLQpInVq+jY1RMIViRHy/T34gbS7szg6kfarh3cQk
        sltmJPa47tjbWHAdBCnz9U7lhmWlW170i9NtV7KrIg0hHRHf+bkcbKoNp5hzjxqvFbZWCS
        4H+2GGeQullyfejVHc97WmHrGnWgIszD6pvnNVyWxD9mLnmKvTxa87xGqFRsDg==
From:   Michael Walle <michael@walle.cc>
To:     sean.anderson@seco.com
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com,
        tobias@waldekranz.com, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Date:   Tue,  7 Mar 2023 12:23:07 +0100
Message-Id: <20230307112307.777207-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230306204517.1953122-1-sean.anderson@seco.com>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> To prevent userspace phy drivers, writes are disabled by default, and can
> only be enabled by editing the source.

Maybe we can just taint the kernel using add_taint()? I'm not sure if
that will prevent vendors writing user space drivers. Thoughts?

-michael
