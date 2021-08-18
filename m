Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A823EFDFE
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 09:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbhHRHmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 03:42:03 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:49101 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239353AbhHRHly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 03:41:54 -0400
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BA30C2224D;
        Wed, 18 Aug 2021 09:41:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1629272476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sviCE7Nk4SvcxLXf1DRlG4q2kwZO+beBUoqIvifXVA4=;
        b=Xwrn1X66xf+iyn0u9b54ed4pQyvVbVjH0MJKfnySOyk5PFCNk7w9oPje62Sn/UStGDyJmD
        xhakOkuE06gznIu7Cy1KxiRSlVbVi1r6AmhOeJhRJ1y+2XMIfENYAy9Jl7qC4ll9znkdYc
        TAP6avggXnHarsDFGLJGTqgClXF//Vo=
From:   Michael Walle <michael@walle.cc>
To:     luoj@codeaurora.org
Cc:     andrew@lunn.ch, davem@davemloft.net, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        sricharan@codeaurora.org, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
Date:   Wed, 18 Aug 2021 09:41:02 +0200
Message-Id: <20210818074102.78006-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
References: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> qca8081 supports IEEE1588 feature, the IEEE1588 code may be submitted in 
> the near future,
> 
> so it may be a good idea to keep it out from at803x code.

The AR8031 also supports PTP. Unfortunately, there is no public datasheet
for the QCA8081, so I can't have a look if both are similar.

See also,
https://lore.kernel.org/netdev/20200228180226.22986-1-michael@walle.cc/

-michael
