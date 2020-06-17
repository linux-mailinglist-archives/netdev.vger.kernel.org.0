Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352321FCB1F
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQKn1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jun 2020 06:43:27 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43942 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQKn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:43:27 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 01995CECD2;
        Wed, 17 Jun 2020 12:53:16 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2] bluetooth: Adding a configurable autoconnect timeout
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200615210638.132889-1-alainm@chromium.org>
Date:   Wed, 17 Jun 2020 12:43:25 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <268B042A-802E-4472-ACDA-8C74CE59FAED@holtmann.org>
References: <20200615210638.132889-1-alainm@chromium.org>
To:     Alain Michaud <alainm@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alain,

> This patch adds a configurable LE autoconnect timeout.
> 
> Signed-off-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> Changes in v1:
> Fixing longer than 80 char line.
> 
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_core.c         |  1 +
> net/bluetooth/hci_event.c        |  2 +-
> net/bluetooth/hci_request.c      |  4 ++--
> net/bluetooth/mgmt_config.c      | 13 +++++++++++++
> 5 files changed, 18 insertions(+), 3 deletions(-)

I created a local tree where I merged all pending patches together and then I send that out to the mailing list for review. This patch doesn’t apply cleanly anymore and thus I need you to resend it once we have that pending series merged into bluetooth-next tree.

Regards

Marcel

