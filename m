Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185952CD9FF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgLCPRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:17:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbgLCPRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:17:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkqLI-00A3WH-Tg; Thu, 03 Dec 2020 16:16:24 +0100
Date:   Thu, 3 Dec 2020 16:16:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     michael alayev <mic.al.linux@gmail.com>
Cc:     netdev@vger.kernel.org, adror@iai.co.il,
        Alayev Michael <malayev@iai.co.il>
Subject: Re: net: dsa: mv88e6xxx : linux v5.4 crash
Message-ID: <20201203151624.GN2324545@lunn.ch>
References: <CANBsoP=hFM1q1vu6FsMEYdAO1Kg+ghCLp2LbKuJGA-S12gmCSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANBsoP=hFM1q1vu6FsMEYdAO1Kg+ghCLp2LbKuJGA-S12gmCSw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  > Also, note that this code has changed a lot since v5.4. You might want
> to try v5.9, or v5.10-rc2.
> I'm using Xilinx's kernel. Its last version is based on v5.4.

Please try mainline anyway. In order to get something fixed on old
kernels, you need to reproduce and fix it in the current mainline
kernel first, and then back port it.

       Andrew
