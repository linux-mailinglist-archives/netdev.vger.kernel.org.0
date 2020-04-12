Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB3F1A5D52
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 09:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDLHoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 03:44:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35137 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgDLHoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 03:44:04 -0400
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id CD3BFCED27;
        Sun, 12 Apr 2020 09:53:38 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v3 1/3] dt-bindings: net: bluetooth: Add
 rtl8723bs-bluetooth
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200412020644.355142-1-alistair@alistair23.me>
Date:   Sun, 12 Apr 2020 09:44:02 +0200
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org,
        anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <AE147CB3-B2A4-4AF4-AE16-1C24F278B0BA@holtmann.org>
References: <20200412020644.355142-1-alistair@alistair23.me>
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
> .../bindings/net/realtek,rtl8723bs-bt.yaml    | 52 +++++++++++++++++++

follow the current names and use net/realtek-bluetooth.yaml.

Regards

Marcel

