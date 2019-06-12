Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1F542CBC
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502249AbfFLQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502234AbfFLQwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 13537152788A2;
        Wed, 12 Jun 2019 09:52:47 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:46 -0700 (PDT)
Message-Id: <20190612.095246.756053477343455375.davem@davemloft.net>
To:     nsaenzjulienne@suse.de
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dt-bindings: net: wiznet: add w5x00 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612122526.14332-2-nsaenzjulienne@suse.de>
References: <20190612122526.14332-1-nsaenzjulienne@suse.de>
        <20190612122526.14332-2-nsaenzjulienne@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:52:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Date: Wed, 12 Jun 2019 14:25:27 +0200

> Add bindings for Wiznet's w5x00 series of SPI interfaced Ethernet chips.
> 
> Based on the bindings for microchip,enc28j60.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

Applied to net-next.
