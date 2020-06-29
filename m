Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2C520E383
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390298AbgF2VPB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 17:15:01 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:55692 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgF2S4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:56:47 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 23289CECDA;
        Mon, 29 Jun 2020 21:06:40 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] dt-bindings: net: bluetooth: realtek: Fix uart-has-rtscts
 example
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200629180545.2879272-1-martin.blumenstingl@googlemail.com>
Date:   Mon, 29 Jun 2020 20:56:45 +0200
Cc:     devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alistair Francis <alistair@alistair23.me>, anarsoul@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <8BBD6F0B-DE92-4241-999E-ED26040E891B@holtmann.org>
References: <20200629180545.2879272-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

> uart-has-rtscts is a boolean property. These are defined as present
> (which means that this property evaluates to "true") or absent (which
> means that this property evaluates to "false"). Remove the numeric value
> from the example to make it comply with the boolean property bindings.
> 
> Fixes: 1cc2d0e021f867 ("dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

