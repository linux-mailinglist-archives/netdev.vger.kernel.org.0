Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB6939BBDB
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFDP3f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Jun 2021 11:29:35 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37298 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhFDP3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 11:29:34 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 99C0BCED39;
        Fri,  4 Jun 2021 17:35:44 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3 1/3] Bluetooth: use inclusive language in HCI role
 comments
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
Date:   Fri, 4 Jun 2021 17:27:46 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <14572D7E-ACE8-4CD5-9A43-024CD8C42F0B@holtmann.org>
References: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> This patch replaces some non-inclusive terms based on the appropriate
> language mapping table compiled by the Bluetooth SIG:
> https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf
> 
> Specifically, these terms are replaced:
> master -> initiator (for smp) or central (everything else)
> slave  -> responder (for smp) or peripheral (everything else)
> 
> The #define preprocessor terms are unchanged for now to not disturb
> dependent APIs.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> 
> ---
> 
> Changes in v3:
> * Remove the #define terms from change
> 
> net/bluetooth/hci_conn.c   | 8 ++++----
> net/bluetooth/hci_event.c  | 6 +++---
> net/bluetooth/l2cap_core.c | 2 +-
> net/bluetooth/smp.c        | 6 +++---
> 4 files changed, 11 insertions(+), 11 deletions(-)

all 3 patches have been applied to bluetooth-next tree.

Regards

Marcel

