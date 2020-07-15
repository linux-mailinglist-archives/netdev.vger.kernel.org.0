Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C46220DCF
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbgGONPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:15:24 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54968 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgGONPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:15:23 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1FBF5CECEE;
        Wed, 15 Jul 2020 15:25:19 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v1] Bluetooth: Add per-instance adv disable/remove
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200714141547.v1.1.Icd35ad65fb4136d45dd701ef9022fa8f7c9e5d65@changeid>
Date:   Wed, 15 Jul 2020 15:15:20 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Shyh-In Hwang <josephsih@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <89CE3AFF-C04F-420A-9303-B3BA7A2C5F6E@holtmann.org>
References: <20200714141547.v1.1.Icd35ad65fb4136d45dd701ef9022fa8f7c9e5d65@changeid>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> Add functionality to disable and remove advertising instances,
> and use that functionality in MGMT add/remove advertising calls.
> 
> Signed-off-by: Daniel Winkler <danielwinkler@google.com>
> Reviewed-by: Shyh-In Hwang <josephsih@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> net/bluetooth/hci_conn.c    |  2 +-
> net/bluetooth/hci_request.c | 59 +++++++++++++++++++++++++++++++------
> net/bluetooth/hci_request.h |  2 ++
> net/bluetooth/mgmt.c        |  6 ++++
> 4 files changed, 59 insertions(+), 10 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

