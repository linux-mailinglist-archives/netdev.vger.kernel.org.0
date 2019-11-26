Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83060109985
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 08:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfKZHTg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 02:19:36 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:52950 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfKZHTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 02:19:36 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id EFBD6CECF6;
        Tue, 26 Nov 2019 08:28:41 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v6 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354
 support
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CANFp7mXNPsmfC_dDcxP1N9weiEFdogOvgSjuBLJSd+4-ONsoOQ@mail.gmail.com>
Date:   Tue, 26 Nov 2019 08:19:33 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1CEB6B69-09AA-47AA-BC43-BD17C00249E7@holtmann.org>
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <1CEDCBDC-221C-4E5F-90E9-898B02304562@holtmann.org>
 <CANFp7mXNPsmfC_dDcxP1N9weiEFdogOvgSjuBLJSd+4-ONsoOQ@mail.gmail.com>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> It looks about the same as one of my earlier patch series. Outside a
> few nitpicks, I'm ok with merging this.

I fixed the nitpicks up and send a v2.

However we should still work towards a generic description of Bluetooth PCM settings for all vendors. Any ideas are welcome.

Regards

Marcel

