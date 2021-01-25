Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69244302A1E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 19:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbhAYSYA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Jan 2021 13:24:00 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38210 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbhAYSXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:23:52 -0500
Received: from marcel-macbook.holtmann.net (p4ff9f11c.dip0.t-ipconnect.de [79.249.241.28])
        by mail.holtmann.org (Postfix) with ESMTPSA id B026DCECCA;
        Mon, 25 Jan 2021 19:30:06 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v5 trivial/resend] dt-bindings: net: btusb: DT fix
 s/interrupt-name/interrupt-names/
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210114131333.2234932-1-geert+renesas@glider.be>
Date:   Mon, 25 Jan 2021 19:22:41 +0100
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Rajat Jain <rajatja@google.com>,
        netdev <netdev@vger.kernel.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>, devicetree@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <26F0654A-4430-4354-A38B-FBDB8993061F@holtmann.org>
References: <20210114131333.2234932-1-geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

> The standard DT property name is "interrupt-names".
> 
> Fixes: fd913ef7ce619467 ("Bluetooth: btusb: Add out-of-band wakeup support")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Rajat Jain <rajatja@google.com>
> ---
> Who takes this patch, before it celebrates its 4th birthday?
> 
> v5:
>  - Add Reviewed-by, Acked-by,
> 
> v4:
>  - Add Acked-by,
> 
> v3:
>  - New.
> ---
> Documentation/devicetree/bindings/net/btusb.txt | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

