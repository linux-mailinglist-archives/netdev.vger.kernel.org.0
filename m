Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F206461B0
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiLGTZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 14:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLGTZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 14:25:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30A5663E8;
        Wed,  7 Dec 2022 11:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wZtdxwI4LjZHFy3E5eNmHsdGICjjQlspmL/cBjqKplQ=; b=ta5aM73PoDuZbwM8uI50eSi02j
        MsbTEnGK9oZUpFAq/oreFRZuu+tfAMlfFuHEOqPHJMJfxjCfzTvkUBasDxalgIvzrf21wZejZ+4X9
        xgKnWfAoBCKY0oWL90t1rOkPYnbyfBAP/47+UE2vjKECpBvrf6LhuFTMCsByrlVD+1Ng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p302S-004gJh-7g; Wed, 07 Dec 2022 20:25:04 +0100
Date:   Wed, 7 Dec 2022 20:25:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5DokI3lm8U2eW+G@lunn.ch>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
 <Y5C8mIQWpWmfmkJ0@gvm01>
 <Y5DR01UWeWRDaLdS@lunn.ch>
 <Y5DfDYr2egl/dZoy@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5DfDYr2egl/dZoy@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 4.1.1 IDM
> Constant field indicating that the address space is defined by this document.
> These bits shall read as 0x0A (Open Alliance).

So it is local to this document. It has no global meaning within Open
Alliance, so some other working group could use the same value in the
same location, and it has a totally different meaning.

Also, 'by this document' means any future changes need to be in this
document. Except when they are in another document, and decide to
reuse the value 0x0a because it is local to the document....

So it actually looks like 0x0a does not have much meaning. 

So why return it?

Does Open Alliance have any sort of global registry of magic numbers
which are unique across specifications? Maybe you want to add another
register whos value is not defined by this document, but something
with bigger scope?

   Andrew
