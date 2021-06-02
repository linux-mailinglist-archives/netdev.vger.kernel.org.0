Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D954839940F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 21:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhFBT5I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Jun 2021 15:57:08 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:44320 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhFBT5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 15:57:06 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0D41FCED09;
        Wed,  2 Jun 2021 22:03:19 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2 1/8] Bluetooth: use inclusive language in HCI role
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210531163500.v2.1.I55a28f07420d96b60332def9a579d27f4a4cf4cb@changeid>
Date:   Wed, 2 Jun 2021 21:55:20 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AF991D82-2984-450B-A522-54F8F4E850F8@holtmann.org>
References: <20210531083726.1949001-1-apusaka@google.com>
 <20210531163500.v2.1.I55a28f07420d96b60332def9a579d27f4a4cf4cb@changeid>
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
> master -> central
> slave  -> peripheral
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> 
> Changes in v2:
> * Add details in commit message
> 
> include/net/bluetooth/hci.h      |  6 +++---
> include/net/bluetooth/hci_core.h |  4 ++--
> net/bluetooth/amp.c              |  2 +-
> net/bluetooth/hci_conn.c         | 30 +++++++++++++++---------------
> net/bluetooth/hci_core.c         |  6 +++---
> net/bluetooth/hci_event.c        | 20 ++++++++++----------
> net/bluetooth/l2cap_core.c       | 12 ++++++------
> net/bluetooth/smp.c              | 20 ++++++++++----------
> 8 files changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index c4b0650fb9ae..18742f4471ff 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -515,7 +515,7 @@ enum {
> 
> /* Link modes */
> #define HCI_LM_ACCEPT	0x8000
> -#define HCI_LM_MASTER	0x0001
> +#define HCI_LM_CENTRAL	0x0001
> #define HCI_LM_AUTH	0x0002
> #define HCI_LM_ENCRYPT	0x0004
> #define HCI_LM_TRUSTED	0x0008

this is my fault since I overlooked this one. This is also API. Lets skip this for now.

Regards

Marcel

