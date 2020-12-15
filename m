Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E102DA6C8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgLOD2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgLOD1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:27:53 -0500
Date:   Mon, 14 Dec 2020 19:27:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608002833;
        bh=kHwLA/GnKkP/SrR83tgTK3OtDgIcQxKEhaqD5lZPNEo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=O5slQrYJgRaPxgALLKp+uWYkllptsfQFAgNYpnYuxg7yD2gvjfQn/ee0o3NOarHp5
         m5mJih65qoG12do5eTE3popRnFcePaoJ/BINtFUI9NBaMWjFaH51q99tLut9bGNzHi
         ipQffgv7sWuBq5B7dPpX1tTs9VbMn4lKNUPE74uw+U2Ji1qkNO0dLjGn4y01AJMueF
         +22Jt9HtaBuGaUpFPk7YWZN9I6/6HfLKlsiFs755FpCAdp31R0wlLoyt6DKKg2mAde
         3Zt42LEERd9jqxRipiqbolBHmRcdT4RAR3nPbCkfcMeyOieZ0X8Er7KBmTcQmyxXqe
         PeBKPgNqjUP2Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: avoid indirect calls in dst
 functions
Message-ID: <20201214192712.586f4ddd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211233340.1503242-1-brianvv@google.com>
References: <20201211233340.1503242-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 23:33:36 +0000 Brian Vazquez wrote:
> From: brianvv <brianvv@google.com>

We'd prefer you to use your normal name rather than just "brianvv".

> Use of the indirect call wrappers in some dst related functions for the
> ipv6/ipv4 case. This is a small improvent for CONFIG_RETPOLINE=y

Any numbers you can provide?

