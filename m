Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864F61B4BEA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgDVRkJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 13:40:09 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:38210 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgDVRkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:40:09 -0400
Received: from [192.168.1.91] (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id D0B23CECFD;
        Wed, 22 Apr 2020 19:49:44 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 0/3] Bluetooth: hci_qca: add support for QCA9377
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200421081656.9067-1-christianshewitt@gmail.com>
Date:   Wed, 22 Apr 2020 19:39:36 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D965D634-A881-43E0-B9F8-DF4679BB9C6D@holtmann.org>
References: <20200421081656.9067-1-christianshewitt@gmail.com>
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
> Christian Hewitt (3):
>  dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
>  Bluetooth: hci_qca: add compatible for QCA9377
>  Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices
> 
> .../bindings/net/qualcomm-bluetooth.txt         |  5 +++++
> drivers/bluetooth/hci_qca.c                     | 17 ++++++++++-------
> 2 files changed, 15 insertions(+), 7 deletions(-)

the series doesn’t apply cleanly against bluetooth-next tree. Can you please respin it.

Regards

Marcel

