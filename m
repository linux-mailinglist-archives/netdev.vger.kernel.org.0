Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA513A88B3
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFOSjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:39:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46644 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhFOSjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 14:39:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E679C4D2CF713;
        Tue, 15 Jun 2021 11:37:08 -0700 (PDT)
Date:   Tue, 15 Jun 2021 11:37:08 -0700 (PDT)
Message-Id: <20210615.113708.152174495455770132.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     kuba@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        olteanv@gmail.com, tchornyi@marvell.com,
        linux-kernel@vger.kernel.org, mickeyr@marvell.com,
        vkochan@marvell.com
Subject: Re: [PATCH net-next 0/2] Marvell Prestera add flower and match all
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210615125444.31538-1-vadym.kochan@plvision.eu>
References: <20210615125444.31538-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 15 Jun 2021 11:37:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Tue, 15 Jun 2021 15:54:42 +0300

> From: Vadym Kochan <vkochan@marvell.com>
> 
> Add ACL infrastructure for Prestera Switch ASICs family devices to
> offload cls_flower rules to be processed in the HW.

Please fix this and resubmit, thank you:

Applying: net: marvell: Implement TC flower offload
.git/rebase-apply/patch:805: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: net: marvell: prestera: Add matchall support
.git/rebase-apply/patch:538: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
hint: Waiting for your editor to close the file...
