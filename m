Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B83391B39
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbhEZPLM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 May 2021 11:11:12 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45671 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbhEZPLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:11:11 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6EEA5CED1D;
        Wed, 26 May 2021 17:17:33 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH 09/12] Bluetooth: use inclusive language in debugfs
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210525182900.9.I3e7a04aaf5320cdfcf3457536e7d4f33eb6d26fa@changeid>
Date:   Wed, 26 May 2021 17:09:37 +0200
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
Message-Id: <6BDB11E1-DB4D-4F44-827F-CCED6D876395@holtmann.org>
References: <20210525102941.3958649-1-apusaka@google.com>
 <20210525182900.9.I3e7a04aaf5320cdfcf3457536e7d4f33eb6d26fa@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Use "accept list" and "reject list".
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> 
> net/bluetooth/hci_debugfs.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> index 47f4f21fbc1a..3352e831af3d 100644
> --- a/net/bluetooth/hci_debugfs.c
> +++ b/net/bluetooth/hci_debugfs.c
> @@ -138,7 +138,7 @@ static int device_list_show(struct seq_file *f, void *ptr)
> 
> DEFINE_SHOW_ATTRIBUTE(device_list);
> 
> -static int blacklist_show(struct seq_file *f, void *p)
> +static int reject_list_show(struct seq_file *f, void *p)
> {
> 	struct hci_dev *hdev = f->private;
> 	struct bdaddr_list *b;
> @@ -151,7 +151,7 @@ static int blacklist_show(struct seq_file *f, void *p)
> 	return 0;
> }
> 
> -DEFINE_SHOW_ATTRIBUTE(blacklist);
> +DEFINE_SHOW_ATTRIBUTE(reject_list);
> 
> static int blocked_keys_show(struct seq_file *f, void *p)
> {
> @@ -323,7 +323,7 @@ void hci_debugfs_create_common(struct hci_dev *hdev)
> 	debugfs_create_file("device_list", 0444, hdev->debugfs, hdev,
> 			    &device_list_fops);
> 	debugfs_create_file("blacklist", 0444, hdev->debugfs, hdev,
> -			    &blacklist_fops);
> +			    &reject_list_fops);

NAK. We are not changing the file names just yet and so there is no point in changing partial function and ops structure names.

This needs to go in as complete patch if we decide to change the debugfs file name.

Regards

Marcel

