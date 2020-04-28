Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985581BB9EF
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgD1Jep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:34:45 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37972 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgD1Jeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:34:44 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 49A3CCECEA;
        Tue, 28 Apr 2020 11:44:22 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 0/3] Bluetooth: hci_qca: add support for QCA9377
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200423013430.21399-1-christianshewitt@gmail.com>
Date:   Tue, 28 Apr 2020 11:34:42 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Content-Transfer-Encoding: 7bit
Message-Id: <07968FAA-BEC1-4E76-A529-0A004110F437@holtmann.org>
References: <20200423013430.21399-1-christianshewitt@gmail.com>
To:     Christian Hewitt <christianshewitt@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

> This series adds a new compatible for the QCA9377 BT device that is found
> in many Android TV box devices, makes minor changes to allow max-speed
> values for the device to be read from device-tree, and updates bindings
> to reflect those changes.
> 
> v2 changes: rebase against bluetooth-next
> 
> Christian Hewitt (3):
>  dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
>  Bluetooth: hci_qca: add compatible for QCA9377
>  Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices
> 
> .../bindings/net/qualcomm-bluetooth.txt         |  5 +++++
> drivers/bluetooth/hci_qca.c                     | 17 ++++++++++-------
> 2 files changed, 15 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

