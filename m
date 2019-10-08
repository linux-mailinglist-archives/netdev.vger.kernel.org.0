Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E1D00F8
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfJHTKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:10:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33983 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfJHTKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:10:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id q203so17890484qke.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ePSlhooqChX4fVVIbFvScvsQAbfEIxryil+whkE9JE8=;
        b=WMDKc4NV//mdrbyntOgFVtgJY7BauL/5Yb/+3kvhq+deCGOkF1hxa8tYpVCvPHmfgj
         iK0t6lcZWzfipPa0TbKXtzTbOAu88Lh/Ij+n7p3VYB8urbLMBdWtqmqxVmpd35ydVyVg
         Vc7KEwV4UlR/T+g0K5D+1nLKO5hC/Ggcygw6PLV41qRpOY3ziyfe2zEBSDO+Jnz2jOjO
         V3vhnB2uwgUdDMELYJhrUZtjp668nlId9WoZATQsUtQBJvgaGkNEoZZwSb84nreygSer
         3MGwy6YFJsCRq2EGQzRf8T2/aYyzTw6y8M3uKZQXZ46fYt/gFi1JzRla45gYQ5pKOXXP
         eqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ePSlhooqChX4fVVIbFvScvsQAbfEIxryil+whkE9JE8=;
        b=P6jJ/ZDhfLIly5e4PyQ4j+L69G/w16jiTA110FrkOaiHthYVXJJSKyH/7QTYDoxv+S
         3moZhOJIuQiccYBbdIy/XE64DZyvzxqQZLHGQOLuCKPJ2YeV00WiLG7Mumg4ToaTcBL7
         EjtelKt19I6SBNpBcuQmICZAzyUcy0L9YWU2x/5Ij36wgVCWj5+QbF7DiQw2oBq9d5lh
         sgsZWDUGTnnAWWhuCoMlDT/rEgc7TAy9G8vaab8w2B668B6hnnOG2U4JGVVmuoD2expN
         iW3sbTO2pViIoBKmNsbv8rEmO4EAOLYYRT3jiKuv8V3DUOsT7tvs4kx59iRf51Cig019
         PIdg==
X-Gm-Message-State: APjAAAUsu8OU8Z4BdXpYq7gNIOKfiVRK745zHvxVHnBrI+c1dVUUN7Be
        6JbjmOUdiSTJXJiamaUvaAymjw==
X-Google-Smtp-Source: APXvYqxzITZfdOYKiUbNU0krG9XG5T4pWjHcTizU+O9Abn0BrQX+V9IPHR1h/8P8sKrRcO80sluImg==
X-Received: by 2002:a37:65d2:: with SMTP id z201mr3093983qkb.355.1570561806647;
        Tue, 08 Oct 2019 12:10:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q44sm9020770qtk.16.2019.10.08.12.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 12:10:06 -0700 (PDT)
Date:   Tue, 8 Oct 2019 12:09:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Bastian Stender <bst@pengutronix.de>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <ore@pengutronix.de>,
        David Jander <david@protonic.nl>
Subject: Re: pull-request: can-next 2019-10-07
Message-ID: <20191008120953.515a3dbd@cakuba.netronome.com>
In-Reply-To: <2ffa00e7-d447-9216-587d-30396a47ca64@pengutronix.de>
References: <2ffa00e7-d447-9216-587d-30396a47ca64@pengutronix.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 16:38:14 +0200, Marc Kleine-Budde wrote:
> Hello David,
> 
> this is a pull request for net-next/master consisting of 12 patches.
> 
> The first patch is by Andy Shevchenko for the mcp251x driver and removes
> the legacy platform data from all in-tree users and the driver.
> 
> The next two patches target the peak_canfd driver, the first one is by
> me and fixes several checkpatch warnings, the second one is by Stephane
> Grosjean and adds hardware timestamps to the rx skbs.
> 
> Followed by two patches for the xilinx_can driver. Again the first is by
> me and fixes checkpatch warnings, the second one is by Anssi Hannula and
> avoids non-requested bus error frames, which improves performance.
> 
> Pankaj Sharma's patch for the m_can driver adds support for the one shot
> mode.
> 
> YueHaibing provides a patch for the grcan driver to use
> devm_platform_ioremap_resource() to simplify code.
> 
> Joakim Zhang provides a similar patch for the flexcan driver.
> 
> The last 4 patches are by me and target the rx-offload infrastructure.
> The first 3 fix checkpatch warnings, the last one removes a no-op
> function.

Hi Marc,

I think the correction should have been s/Substract/Subtract/,
sorry for the nit pick.

Would you be able to fix that up or do you prefer to do a follow up?

commit 8e7f9a874626a1aec191b34c2b983f76275d0448
Author: Marc Kleine-Budde <mkl@pengutronix.de>
Date:   Mon Oct 7 10:00:25 2019 +0200

    can: rx-offload: can_rx_offload_compare(): fix typo
    
    This patch fixes a typo found by checkpatch.
    
    Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 0daa8c7fe83b..8db07587ce3c 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -109,7 +109,7 @@ static int can_rx_offload_compare(struct sk_buff *a, struct sk_buff *b)
        cb_a = can_rx_offload_get_cb(a);
        cb_b = can_rx_offload_get_cb(b);
 
-       /* Substract two u32 and return result as int, to keep
+       /* Substact two u32 and return result as int, to keep
         * difference steady around the u32 overflow.
         */
        return cb_b->timestamp - cb_a->timestamp;
