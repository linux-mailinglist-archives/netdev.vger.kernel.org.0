Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E821BBED
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGJRLF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 13:11:05 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:38531 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgGJRLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:11:01 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 455FBCED28;
        Fri, 10 Jul 2020 19:20:57 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: core: Use fallthrough pseudo-keyword
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200708201823.GA400@embeddedor>
Date:   Fri, 10 Jul 2020 19:11:00 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <506A63D3-4B3E-4148-B862-2CB5418FF84A@holtmann.org>
References: <20200708201823.GA400@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> fall-through markings when it is the case.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> net/bluetooth/hci_event.c  |  4 ++--
> net/bluetooth/hci_sock.c   |  3 +--
> net/bluetooth/l2cap_core.c | 19 +++++++++----------
> net/bluetooth/l2cap_sock.c |  4 ++--
> net/bluetooth/mgmt.c       |  4 ++--
> net/bluetooth/smp.c        |  2 +-
> 6 files changed, 17 insertions(+), 19 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

