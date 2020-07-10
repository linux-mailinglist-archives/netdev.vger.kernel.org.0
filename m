Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2603621BBF2
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGJRLE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 13:11:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:58642 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJRK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:10:59 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0C750CED27;
        Fri, 10 Jul 2020 19:20:55 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: RFCOMM: Use fallthrough pseudo-keyword
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200708202505.GA1733@embeddedor>
Date:   Fri, 10 Jul 2020 19:10:57 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1DB804F8-B14A-4A27-BB33-8622929F20CF@holtmann.org>
References: <20200708202505.GA1733@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1].
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> net/bluetooth/rfcomm/core.c | 2 +-
> net/bluetooth/rfcomm/sock.c | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

