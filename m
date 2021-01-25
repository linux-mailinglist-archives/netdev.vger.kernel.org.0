Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD904303419
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbhAZFPF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:15:05 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:46631 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbhAYPeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:34:01 -0500
Received: from marcel-macbook.holtmann.net (p4ff9f11c.dip0.t-ipconnect.de [79.249.241.28])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0218BCECCD;
        Mon, 25 Jan 2021 16:24:55 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH] net/bluetooth:  Fix the follow coccicheck warnings
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1611126764-34416-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Date:   Mon, 25 Jan 2021 16:17:30 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5BC89712-55D8-407F-B4EC-C4BB04EB910C@holtmann.org>
References: <1611126764-34416-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiapeng,

> ./net/bluetooth/hci_debugfs.c: WARNING: sniff_min_interval_fops
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> 
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> ---
> net/bluetooth/hci_debugfs.c | 38 +++++++++++++++++++-------------------
> 1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> index 4626e02..65cad9f 100644
> --- a/net/bluetooth/hci_debugfs.c
> +++ b/net/bluetooth/hci_debugfs.c
> @@ -237,7 +237,7 @@ static int conn_info_min_age_get(void *data, u64 *val)
> 	return 0;
> }
> 
> -DEFINE_SIMPLE_ATTRIBUTE(conn_info_min_age_fops, conn_info_min_age_get,
> +DEFINE_DEBUGFS_ATTRIBUTE(conn_info_min_age_fops, conn_info_min_age_get,
> 			conn_info_min_age_set, "%llu\n");

while I am fine with the patch, put please make sure the indentation alignment of the second line is also correct.

Regards

Marcel

