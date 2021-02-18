Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E964831F083
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhBRTyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:54:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhBRTvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:51:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCpJc-007AO5-TG; Thu, 18 Feb 2021 20:50:20 +0100
Date:   Thu, 18 Feb 2021 20:50:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, netdev <netdev@vger.kernel.org>,
        davem@devemloft.org, Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCHv3 1/3] usbnet: specify naming of
 usbnet_set/get_link_ksettings
Message-ID: <YC7E/LvO8+k83lIL@lunn.ch>
References: <20210218102038.2996-1-oneukum@suse.com>
 <20210218102038.2996-2-oneukum@suse.com>
 <CANEJEGu+fqkgu6whO_1BXFpnf5K6BG8Z7nUmHcJaYU9_tc7svg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGu+fqkgu6whO_1BXFpnf5K6BG8Z7nUmHcJaYU9_tc7svg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 07:31:41PM +0000, Grant Grundler wrote:
> Oliver, Jakub,
> Can I post v4 and deal with the issues below?

You should probably wait for two weeks. We are far enough into the
merge window that i doubt it will get picked up. So please wait,
rebase, and then post.

> Nit: The v2/v3 lines should be included BELOW the '---' line since
> they don't belong in the commit message.

netdev actually prefers them above, so we see the history of how a
patched changed during review.

	Andrew
