Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE9A391B4A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhEZPMx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 May 2021 11:12:53 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45032 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbhEZPMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:12:46 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 75FFBCED1D;
        Wed, 26 May 2021 17:19:05 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH 10/12] Bluetooth: use inclusive language when filtering
 devices out
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210525182900.10.I014436e29e9c804a3f7583db6264214cad746a7d@changeid>
Date:   Wed, 26 May 2021 17:11:09 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <09973DDA-1441-4881-9B3C-55FA6F983BA8@holtmann.org>
References: <20210525102941.3958649-1-apusaka@google.com>
 <20210525182900.10.I014436e29e9c804a3f7583db6264214cad746a7d@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Use "reject list".

I really think you need to write a bit of a commit message for these patches.

> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> 
> include/net/bluetooth/hci_core.h |  2 +-
> net/bluetooth/hci_core.c         |  4 ++--
> net/bluetooth/hci_debugfs.c      |  2 +-
> net/bluetooth/hci_event.c        |  6 +++---
> net/bluetooth/hci_sock.c         | 12 ++++++------
> net/bluetooth/l2cap_core.c       |  4 ++--
> net/bluetooth/mgmt.c             |  4 ++--
> 7 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index cfe2ada49ca2..9c8cdc4fe3c5 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -522,7 +522,7 @@ struct hci_dev {
> 	struct hci_conn_hash	conn_hash;
> 
> 	struct list_head	mgmt_pending;
> -	struct list_head	blacklist;
> +	struct list_head	reject_list;
> 	struct list_head	whitelist;

Can we change these two in the same patch please.

Regards

Marcel

