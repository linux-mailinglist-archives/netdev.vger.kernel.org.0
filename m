Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D982B198648
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgC3VSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:18:20 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37270 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgC3VST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:18:19 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9EBACCECBE;
        Mon, 30 Mar 2020 23:27:49 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 2/2] dt-bindings: net: bluetooth: Add device tree
 bindings for QCA chip QCA6390
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200325022638.14325-2-rjliao@codeaurora.org>
Date:   Mon, 30 Mar 2020 23:18:16 +0200
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        thierry.escande@linaro.org, netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bgodavar@codeaurora.org, c-hbandi@codeaurora.org,
        hemantg@codeaurora.org, mka@chromium.org
Content-Transfer-Encoding: 7bit
Message-Id: <934C5E65-B7B2-4410-986D-77B8B7120180@holtmann.org>
References: <20200314094328.3331-1-rjliao@codeaurora.org>
 <20200325022638.14325-1-rjliao@codeaurora.org>
 <20200325022638.14325-2-rjliao@codeaurora.org>
To:     Rocky Liao <rjliao@codeaurora.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rocky,

> This patch adds compatible string for the QCA chip QCA6390.
> 
> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
> ---
> 
> Changes in v2: None
> 
> Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 1 +
> 1 file changed, 1 insertion(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

