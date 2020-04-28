Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7961BBAE2
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgD1KNr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Apr 2020 06:13:47 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45841 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgD1KNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:13:47 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id BB7EFCECEB;
        Tue, 28 Apr 2020 12:23:22 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v4 1/3] dt-bindings: net: bluetooth: Add
 rtl8723bs-bluetooth
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200425155531.2816584-1-alistair@alistair23.me>
Date:   Tue, 28 Apr 2020 12:13:42 +0200
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        mripard@kernel.org, wens@csie.org, anarsoul@gmail.com,
        devicetree <devicetree@vger.kernel.org>, alistair23@gmail.com,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1DC07D5C-825B-43C6-B601-B1DC5CD07F46@holtmann.org>
References: <20200425155531.2816584-1-alistair@alistair23.me>
To:     Alistair Francis <alistair@alistair23.me>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alistair,

> Add binding document for bluetooth part of RTL8723BS/RTL8723CS
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> Signed-off-by: Alistair Francis <alistair@alistair23.me>
> ---
> .../bindings/net/realtek-bluetooth.yaml       | 54 +++++++++++++++++++
> 1 file changed, 54 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml

patches 1 and 2 have been applied to bluetooth-next tree.

Regards

Marcel

