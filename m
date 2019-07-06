Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8816A60FF6
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfGFKva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 06:51:30 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42489 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGFKv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 06:51:28 -0400
Received: from [192.168.0.113] (CMPC-089-239-107-172.CNet.Gawex.PL [89.239.107.172])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0F854CF164;
        Sat,  6 Jul 2019 12:59:58 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v6 1/2] Bluetooth: hci_qca: Load customized NVM based on
 the device property
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1559814030-13833-1-git-send-email-rjliao@codeaurora.org>
Date:   Sat, 6 Jul 2019 12:51:26 +0200
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        thierry.escande@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bgodavar@codeaurora.org, c-hbandi@codeaurora.org
Content-Transfer-Encoding: 7bit
Message-Id: <AFA918FD-04AF-47C0-A6B4-6B53CF824054@holtmann.org>
References: <1557919161-11010-1-git-send-email-rjliao@codeaurora.org>
 <1559814030-13833-1-git-send-email-rjliao@codeaurora.org>
To:     Rocky Liao <rjliao@codeaurora.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rocky,

> QCA BTSOC NVM is a customized firmware file and different vendors may
> want to have different BTSOC configuration (e.g. Configure SCO over PCM
> or I2S, Setting Tx power, etc.) via this file. This patch will allow
> vendors to download different NVM firmware file by reading a device
> property "firmware-name".
> 
> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
> ---
> Changes in v6:
>  * Added read firmware-name property for both QCA6174 and WCN399X
> ---
> drivers/bluetooth/btqca.c   |  8 ++++++--
> drivers/bluetooth/btqca.h   |  6 ++++--
> drivers/bluetooth/hci_qca.c | 18 +++++++++++++++++-
> 3 files changed, 27 insertions(+), 5 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

