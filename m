Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA96A12736D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLTCUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:20:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLTCUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 21:20:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D55A154193D2;
        Thu, 19 Dec 2019 18:14:12 -0800 (PST)
Date:   Thu, 19 Dec 2019 18:14:12 -0800 (PST)
Message-Id: <20191219.181412.1944669600075288939.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] NFC: pn544: Adjust indentation in
 pn544_hci_check_presence
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218012152.15570-1-natechancellor@gmail.com>
References: <20191218012152.15570-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 18:14:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Tue, 17 Dec 2019 18:21:52 -0700

> Clang warns
> 
> ../drivers/nfc/pn544/pn544.c:696:4: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>                  return nfc_hci_send_cmd(hdev, NFC_HCI_RF_READER_A_GATE,
>                  ^
> ../drivers/nfc/pn544/pn544.c:692:3: note: previous statement is here
>                 if (target->nfcid1_len != 4 && target->nfcid1_len != 7 &&
>                 ^
> 1 warning generated.
> 
> This warning occurs because there is a space after the tab on this line.
> Remove it so that the indentation is consistent with the Linux kernel
> coding style and clang no longer warns.
> 
> Fixes: da052850b911 ("NFC: Add pn544 presence check for different targets")
> Link: https://github.com/ClangBuiltLinux/linux/issues/814
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to net-next, thanks.
