Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA721691A23
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjBJIkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjBJIkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:40:11 -0500
Received: from smtp-out-04.comm2000.it (smtp-out-04.comm2000.it [212.97.32.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853E55ACF3;
        Fri, 10 Feb 2023 00:40:08 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-04.comm2000.it (Postfix) with ESMTPSA id 5235ABC6B45;
        Fri, 10 Feb 2023 09:40:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676018404;
        bh=4UpF8Pn1q1I0tcFzeuQhYJlQ8+wjIOWIRLiTAiSB454=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=2CVJ2Ay3nnYUbS7LEq0BrMXq+NOLDGszrLClmBDaBm9vuCYYdIDfO7+EALBC39431
         B54t0xKUt1c4DBt2M3xPiocbG2aWANflT23ZvAgBC0A3xPlrBeOK5ObM85nFjU1wJo
         Z3EnVzRvooWwe8PzVWYhY5/vtbUReCkYT+Wyd2uvLG+GMQBVdulsky1Rq6GTtHblQ4
         caUNGjtr6IHf/hQLKjEsGoXqaY8JJ848lRbcVUTGZcl3cZ90TYgLS5+e8b3MVft38e
         1qGRO1vTmsKO60K/CQN05gkJAZfDTX7vg0H7nfxE+mrBAyEyzFMrtpaRMnvyVsWQa3
         WR9pnLNs+39Cg==
Date:   Fri, 10 Feb 2023 09:39:56 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 0/5] Bluetooth: hci_mrvl: Add serdev support for
 88W8997
Message-ID: <Y+YC3Pka42SmtyvI@francesco-nb.int.toradex.com>
References: <20230126074356.431306-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126074356.431306-1-francesco@dolcini.it>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

On Thu, Jan 26, 2023 at 08:43:51AM +0100, Francesco Dolcini wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> support for changing the baud rate. The command to change the baud rate is
> taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> interfaces) from NXP.

Just a gently ping on this series, patches 1,2 with DT binding changes
are reviewed/acked, patch 5 with the DTS change should just be on hold
till patches 1-4 are merged.

No feedback on patches 4 (and 3), with the BT serdev driver code
changes, any plan on those?

Thanks a lot!
Francesco

