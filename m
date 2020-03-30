Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DB119864E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgC3VST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:18:19 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57108 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbgC3VSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:18:16 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 4D472CECA3;
        Mon, 30 Mar 2020 23:27:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 1/2] Bluetooth: hci_qca: Add support for Qualcomm
 Bluetooth SoC QCA6390
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200325022638.14325-1-rjliao@codeaurora.org>
Date:   Mon, 30 Mar 2020 23:18:14 +0200
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        thierry.escande@linaro.org, netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        c-hbandi@codeaurora.org, Hemantg <hemantg@codeaurora.org>,
        mka@chromium.org
Content-Transfer-Encoding: 7bit
Message-Id: <AAAA8547-5298-476C-8BB6-54957E896F51@holtmann.org>
References: <20200314094328.3331-1-rjliao@codeaurora.org>
 <20200325022638.14325-1-rjliao@codeaurora.org>
To:     Rocky Liao <rjliao@codeaurora.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rocky,

> This patch adds support for QCA6390, including the devicetree and acpi
> compatible hwid matching, and patch/nvm downloading.
> 
> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
> ---
> 
> Changes in v2:
>  -removed the use of macro QCA_IS_3991_6390
>  -removed the qca_send_enhancelog_enable_cmd()
> 
> drivers/bluetooth/btqca.c   | 18 ++++++++++++-----
> drivers/bluetooth/btqca.h   |  3 ++-
> drivers/bluetooth/hci_qca.c | 40 ++++++++++++++++++++++++++++++-------
> 3 files changed, 48 insertions(+), 13 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

