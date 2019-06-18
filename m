Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE114A7CD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfFRRDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:03:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRRDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:03:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AC02150AFBC3;
        Tue, 18 Jun 2019 10:03:00 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:02:59 -0700 (PDT)
Message-Id: <20190618.100259.875895132949121974.davem@davemloft.net>
To:     maurosr@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: Re: [PATCH net] bnx2x: Check if transceiver implements DDM before
 access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613192540.15645-1-maurosr@linux.vnet.ibm.com>
References: <20190613192540.15645-1-maurosr@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:03:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Date: Thu, 13 Jun 2019 16:25:40 -0300

> Some transceivers may comply with SFF-8472 even though they do not
> implement the Digital Diagnostic Monitoring (DDM) interface described in
> the spec. The existence of such area is specified by the 6th bit of byte
> 92, set to 1 if implemented.
> 
> Currently, without checking this bit, bnx2x fails trying to read sfp
> module's EEPROM with the follow message:
> 
> ethtool -m enP5p1s0f1
> Cannot get Module EEPROM data: Input/output error
> 
> Because it fails to read the additional 256 bytes in which it is assumed
> to exist the DDM data.
> 
> This issue was noticed using a Mellanox Passive DAC PN 01FT738. The EEPROM
> data was confirmed by Mellanox as correct and similar to other Passive
> DACs from other manufacturers.
> 
> Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>

Applied, thank you.
