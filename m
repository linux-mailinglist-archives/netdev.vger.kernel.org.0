Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F1D41F97B
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 05:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhJBDNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 23:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232369AbhJBDNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 23:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B06761A51;
        Sat,  2 Oct 2021 03:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633144289;
        bh=uBQm4PdYue+g3LvWMUsXNvAqCgy2vcF91jpTuExKEp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tpv2R6dU/E3gpZH2KloIWck6KFpiQ4Ta8xPUCXMOinzM+xhnYOwXUdYjWVq4iyfNl
         K2jvfqdiYXuig8oyY9saXtoLwvx2gitP0cH5Gh/8Fqxr3L9Ut4pzq6jSThYF2FgkzF
         TQSJuBmDNrjeZBQwvLA09NkMpcMQ+8Ed/IF8aIy63ALJWiyGYsqWGVw9fUatGuqjLj
         UZI/SSzs8IbgkSE3PyfutkjkKTpy9yDdtYVeJIxJN3cEw8H0Hk79qBy1I3f+m9oWpp
         8C5JMWvbzK+wgYesRsf+g33daUiLwIEPKlAOFPdaOHF/lCty2lZbMQdKY62Lcl/kCD
         IYX9ykxmdrumQ==
Date:   Fri, 1 Oct 2021 20:11:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2021-10-01
Message-ID: <20211001201128.7737a4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001230850.3635543-1-luiz.dentz@gmail.com>
References: <20211001230850.3635543-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Oct 2021 16:08:50 -0700 Luiz Augusto von Dentz wrote:
> bluetooth-next pull request for net-next:
> 
>  - Add support for MediaTek MT7922 and MT7921
>  - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
>    8822C/8852A.
>  - Add initial support for link quality and audio/codec offload.
>  - Rework of sockets sendmsg to avoid locking issues.
>  - Add vhci suspend/resume emulation.

Lots of missing sign-offs from Marcel:

Commit 927ac8da35db ("Bluetooth: set quality report callback for Intel")
	committer Signed-off-by missing
	author email:    josephsih@chromium.org
	committer email: marcel@holtmann.org
	Signed-off-by: Joseph Hwang <josephsih@chromium.org>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Commit ae7d925b5c04 ("Bluetooth: Support the quality report events")
	committer Signed-off-by missing
	author email:    josephsih@chromium.org
	committer email: marcel@holtmann.org
	Signed-off-by: Joseph Hwang <josephsih@chromium.org>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Commit 93fb70bc112e ("Bluetooth: refactor set_exp_feature with a feature table")
	committer Signed-off-by missing
	author email:    josephsih@chromium.org
	committer email: marcel@holtmann.org
	Signed-off-by: Joseph Hwang <josephsih@chromium.org>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Commit 76a56bbd810d ("Bluetooth: btintel: support link statistics telemetry events")
	committer Signed-off-by missing
	author email:    chethan.tumkur.narayan@intel.com
	committer email: marcel@holtmann.org
	Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
	Signed-off-by: Kiran K <kiran.k@intel.com>
	Signed-off-by: Joseph Hwang <josephsih@chromium.org>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Commit 0331b8e990ed ("Bluetooth: btusb: disable Intel link statistics telemetry events")
	committer Signed-off-by missing
	author email:    josephsih@chromium.org
	committer email: marcel@holtmann.org
	Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
	Signed-off-by: Kiran K <kiran.k@intel.com>
	Signed-off-by: Joseph Hwang <josephsih@chromium.org>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Commit 81218cbee980 ("Bluetooth: mgmt: Disallow legacy MGMT_OP_READ_LOCAL_OOB_EXT_DATA")
	committer Signed-off-by missing
	author email:    brian.gix@intel.com
	committer email: marcel@holtmann.org
	Signed-off-by: Brian Gix <brian.gix@intel.com>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Commit 0b59e272f932 ("Bluetooth: reorganize functions from hci_sock_sendmsg()")
	committer Signed-off-by missing
	author email:    penguin-kernel@I-love.SAKURA.ne.jp
	committer email: marcel@holtmann.org
	Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
	Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>


Can this be fixed?
