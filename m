Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6C399436
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFBUGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:06:36 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:51743 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhFBUGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:06:33 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5BA0ACED09;
        Wed,  2 Jun 2021 22:12:46 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2 0/8] Bluetooth: use inclusive language
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210531083726.1949001-1-apusaka@google.com>
Date:   Wed, 2 Jun 2021 22:04:48 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        =?utf-8?B?T2xlIEJqw7hybiBNaWR0YsO4?= <omidtbo@cisco.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DC06C6FE-5631-4842-BA38-3BF44B8CC5F8@holtmann.org>
References: <20210531083726.1949001-1-apusaka@google.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> This series contains inclusive language patches, to promote usage of
> central, peripheral, reject list, and accept list. I tried to divide
> the change to several smaller patches to ease downstreamers to make
> gradual change.
> 
> There are still some occurences in debugfs in which the
> original less inclusive terms is still left as-is since it is a
> file name, and I afraid replacing them will cause instability to
> other systems depending on that file name.
> 
> Changes in v2:
> * Add details in commit message
> * SMP: Use initiator/responder instead of central/peripheral
> * reject/accept list: Was actually two patches, squashed together
> * Drop patches in L2CAP, RFCOMM, and debugfs
> 
> Archie Pusaka (8):
>  Bluetooth: use inclusive language in HCI role
>  Bluetooth: use inclusive language in hci_core.h
>  Bluetooth: use inclusive language to describe CPB
>  Bluetooth: use inclusive language in HCI LE features
>  Bluetooth: use inclusive language when tracking connections
>  Bluetooth: use inclusive language in SMP
>  Bluetooth: use inclusive language when filtering devices
>  Bluetooth: use inclusive language in comments
> 
> include/net/bluetooth/hci.h      |  98 +++++++++++++-------------
> include/net/bluetooth/hci_core.h |  22 +++---
> include/net/bluetooth/mgmt.h     |   2 +-
> net/bluetooth/amp.c              |   2 +-
> net/bluetooth/hci_conn.c         |  32 ++++-----
> net/bluetooth/hci_core.c         |  46 ++++++-------
> net/bluetooth/hci_debugfs.c      |   8 +--
> net/bluetooth/hci_event.c        | 114 +++++++++++++++----------------
> net/bluetooth/hci_request.c      | 106 ++++++++++++++--------------
> net/bluetooth/hci_sock.c         |  12 ++--
> net/bluetooth/hidp/core.c        |   2 +-
> net/bluetooth/l2cap_core.c       |  16 ++---
> net/bluetooth/mgmt.c             |  36 +++++-----
> net/bluetooth/smp.c              |  86 +++++++++++------------
> net/bluetooth/smp.h              |   6 +-
> 15 files changed, 297 insertions(+), 291 deletions(-)

patches 2,3,4,6,8 have been applied to bluetooth-next tree.

Regards

Marcel

