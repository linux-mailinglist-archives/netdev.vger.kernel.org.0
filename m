Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E600D265A6C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgIKHUk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Sep 2020 03:20:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35767 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgIKHUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 03:20:32 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 45DA4CED19;
        Fri, 11 Sep 2020 09:27:26 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 0/3] Bluetooth: Emit events for suspend/resume
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200729014225.1842177-1-abhishekpandit@chromium.org>
Date:   Fri, 11 Sep 2020 09:20:30 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5A859E7E-5BD4-4DBD-A44A-AD6E4950DB81@holtmann.org>
References: <20200729014225.1842177-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> This series adds the suspend/resume events suggested in
> https://patchwork.kernel.org/patch/11663455/.
> 
> I have tested it with some userspace changes that monitors the
> controller resumed event to trigger audio device reconnection and
> verified that the events are correctly emitted.
> 
> Please take a look.
> Abhishek
> 
> 
> Abhishek Pandit-Subedi (3):
>  Bluetooth: Add mgmt suspend and resume events
>  Bluetooth: Add suspend reason for device disconnect
>  Bluetooth: Emit controller suspend and resume events
> 
> include/net/bluetooth/hci_core.h |  6 +++
> include/net/bluetooth/mgmt.h     | 16 +++++++
> net/bluetooth/hci_core.c         | 26 +++++++++++-
> net/bluetooth/hci_event.c        | 73 ++++++++++++++++++++++++++++++++
> net/bluetooth/mgmt.c             | 28 ++++++++++++
> 5 files changed, 148 insertions(+), 1 deletion(-)

can you please re-send this series. Unfortunately it seems I only have the cover letter, but lost the patches.

Regards

Marcel

