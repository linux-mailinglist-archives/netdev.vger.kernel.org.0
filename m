Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB57535B3E9
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 13:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhDKLy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 07:54:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:49642 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhDKLy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 07:54:59 -0400
Received: from marcel-macbook.holtmann.net (p5b3d235a.dip0.t-ipconnect.de [91.61.35.90])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0E770CECF3;
        Sun, 11 Apr 2021 14:02:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v2] Bluetooth: Return whether a connection is outbound
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210409150356.v2.1.Id5ee0a2edda8f0902498aaeb1b6c78d062579b75@changeid>
Date:   Sun, 11 Apr 2021 13:54:40 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8E072277-ED4D-408F-BE6B-A3C6E17A7BA6@holtmann.org>
References: <20210409150356.v2.1.Id5ee0a2edda8f0902498aaeb1b6c78d062579b75@changeid>
To:     Yu Liu <yudiliu@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,

> When an MGMT_EV_DEVICE_CONNECTED event is reported back to the user
> space we will set the flags to tell if the established connection is
> outbound or not. This is useful for the user space to log better metrics
> and error messages.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Signed-off-by: Yu Liu <yudiliu@google.com>
> ---
> 
> Changes in v2:
> - Defined the bit as MGMT_DEV_FOUND_INITIATED_CONN
> 
> Changes in v1:
> - Initial change
> 
> include/net/bluetooth/hci_core.h | 2 +-
> include/net/bluetooth/mgmt.h     | 1 +
> net/bluetooth/hci_event.c        | 8 ++++----
> net/bluetooth/l2cap_core.c       | 2 +-
> net/bluetooth/mgmt.c             | 6 +++++-
> 5 files changed, 12 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

