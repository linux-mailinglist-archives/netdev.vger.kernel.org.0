Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C110C06B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfK0W5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 17:57:00 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38671 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK0W5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:57:00 -0500
Received: from marcel-macpro.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id 95B0FCEC82;
        Thu, 28 Nov 2019 00:06:06 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH] dt-bindings: net: bluetooth: Minor fix in
 broadcom-bluetooth
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191127224509.3341-1-abhishekpandit@chromium.org>
Date:   Wed, 27 Nov 2019 23:56:58 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Mohammad Rasim <mohammad.rasim96@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <268BB19B-161A-4244-B460-E59E7C846632@holtmann.org>
References: <20191127224509.3341-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> The example for brcm,bt-pcm-int-params should be a bytestring and all
> values need to be two hex characters.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

