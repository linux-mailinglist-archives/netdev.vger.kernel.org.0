Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA936909F4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBINaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBINaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:30:10 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453CB23C66;
        Thu,  9 Feb 2023 05:30:09 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 86672A6D;
        Thu,  9 Feb 2023 14:30:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1675949407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SrOqtqMRVL+oUjt6m967e0yB5Ie1KW5qjLlv8Lsn4MQ=;
        b=zjTSBKcw28bY1+E69FBghoDKyAhMrFOmoK7q9eKOZGm2mhVtD2dnwivWiYpM4d7FS10UwF
        8e8672LcOmfq4uSzhjhaVld2+1gIhh6EoLTzjMaZLVbeK9Hha0RDhTn3T2hv94sPhMFJE/
        eFok+nSRanJXVul+Q3ENcWHqb6Ge7HaHRoEGtd7dFVq0PzzzJdoHgBCk9v+3zoYRX8U0Bd
        S72wPuo9euYWMWHqbj7kBDY05y5CUCwMKHzvie+DpW+sek3Rb6LqSh52I17P5juLLAGbtT
        Qzw43BM4XegX21QNArAaegaPRefUHznH/+gZEaOUEfdT6wcTJ+rj3h9eGKq1Xg==
From:   Michael Walle <michael@walle.cc>
To:     oliver.graute@kococonnector.com
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH RFC] linux: net: phy: realtek: changing LED behaviour for RTL8211F
Date:   Thu,  9 Feb 2023 14:30:02 +0100
Message-Id: <20230209133002.180178-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230209123917.GA1550@optiplex>
References: <20230209123917.GA1550@optiplex>
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

> is this the right place to turn on the realtek phy LEDs for RTL8211F?

Probably not. There are a few issues. This will only work one particular
board. Therefore, you'd need some kind of runtime configuration to also
support other boards. But lately any LED related patches for PHYs were
NAK'd because they need to integrate with the LED subsystem. See [1].

-michael

[1] https://lore.kernel.org/r/YyxOTKJ8OTxXgWcA@lunn.ch/
