Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4DC6569A4
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 11:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiL0K4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 05:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0K4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 05:56:49 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676E060E1
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 02:56:46 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D27634F;
        Tue, 27 Dec 2022 11:56:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672138604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLRNUOkTgVrve/zgRSKVe7VHYtbhvim3j7Sigh3kaSY=;
        b=IRMrAmP3cc0O30GcUlJZXRoy6UnhUVJvq8JtqnW+HNStKrnLCpJYyxUKgvFcDkd9cCrK9I
        qPbnle1AGZ7a6QiWEnjM8hezB3gRPf9NhsQsFytJCc+Pl/whRJhxCo90EODObKAi+jq/IP
        YASoStPjQUAjvOzD87PychIj2NP6JH++oRrxJQ2Nl7UFaQzlERSY4xZxvkEaxmQQcXMyyC
        1IXbdObmvtHnjt1yMJToj9ad9lN8iWPf/ODgdw+xyrahkxXPjzVjpHOEXHqvuDbVuMTVPd
        grsPYcXFnBjrLbxOlfPyufmsoILfzBr6N0RcK7YDo1e+JL8TVU7mQrAz4kc2cg==
From:   Michael Walle <michael@walle.cc>
To:     lxu@maxlinear.com
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, hmehrtens@maxlinear.com, kuba@kernel.org,
        linux@armlinux.org.uk, mohammad.athari.ismail@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com, tmohren@maxlinear.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net v2] net: phy: mxl-gpy: fix delay time required by loopback disable function
Date:   Tue, 27 Dec 2022 11:56:38 +0100
Message-Id: <20221227105638.1214358-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221094358.29639-1-lxu@maxlinear.com>
References: <20221221094358.29639-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> GPY2xx devices need 3 seconds to fully switch out of loopback mode
> before it can safely re-enter loopback mode.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Again, no Fixes tag?

Changelog is missing, what has changes since v1? Also it is good
practice to CC the ones which made comments on the previous versions.

-michael
