Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC621BBA5A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgD1Jv2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Apr 2020 05:51:28 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:49320 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgD1Jv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:51:27 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id B4A75CECEB;
        Tue, 28 Apr 2020 12:01:04 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [DO-NOT-MERGE][PATCH v4 3/3] arm64: allwinner: Enable Bluetooth
 and WiFi on sopine baseboard
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200425155531.2816584-3-alistair@alistair23.me>
Date:   Tue, 28 Apr 2020 11:51:24 +0200
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        mripard@kernel.org, wens@csie.org, anarsoul@gmail.com,
        devicetree@vger.kernel.org, alistair23@gmail.com,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <417EB5CB-F57F-4B7E-A81E-9ECE166BE217@holtmann.org>
References: <20200425155531.2816584-1-alistair@alistair23.me>
 <20200425155531.2816584-3-alistair@alistair23.me>
To:     Alistair Francis <alistair@alistair23.me>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alistair,

> The sopine board has an optional RTL8723BS WiFi + BT module that can be
> connected to UART1. Add this to the device tree so that it will work
> for users if connected.
> 
> Signed-off-by: Alistair Francis <alistair@alistair23.me>
> ---
> .../allwinner/sun50i-a64-sopine-baseboard.dts | 29 +++++++++++++++++++
> 1 file changed, 29 insertions(+)

so I am bit confused on what to do with this series? Do you want me to apply a subset of patches or do you require specific reviews or acks?

Regards

Marcel

