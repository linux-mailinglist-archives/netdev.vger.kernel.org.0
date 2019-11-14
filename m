Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16204FCAC3
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 17:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfKNQbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 11:31:33 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:34434 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfKNQbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 11:31:33 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Nov 2019 11:31:33 EST
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47DRdZ2MZxzVw;
        Thu, 14 Nov 2019 17:24:33 +0100 (CET)
Date:   Thu, 14 Nov 2019 18:24:32 +0200
From:   Adrian Bunk <bunk@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: dp83867: Why does ti,fifo-depth set only TX, and why is it mandatory?
Message-ID: <20191114162431.GA21979@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

looking at the ti,fifo-depth property to set the TX FIFO Depth in the 
dp83867 driver I was wondering:

1. Why does it set only TX?
Is there a reason why TX needs setting but RX does not?
(RX FIFO Depth is SGMII-only, but that's what I am using)

2. Why is it a mandatory property?
Perhaps I am missing something obvious, but why can't the driver either
leave the value untouched or set the maximum when nothing is configured?

Thanks in advance
Adrian

