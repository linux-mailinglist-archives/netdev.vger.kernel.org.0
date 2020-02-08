Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457721564A1
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgBHN7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 08:59:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgBHN7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 08:59:19 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 670BB14DB876E;
        Sat,  8 Feb 2020 05:59:17 -0800 (PST)
Date:   Sat, 08 Feb 2020 14:59:13 +0100 (CET)
Message-Id: <20200208.145913.1361458871736145995.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: ptp: Add device tree
 binding for IDT 82P33 based PTP clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581114255-6415-1-git-send-email-min.li.xe@renesas.com>
References: <1581114255-6415-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Feb 2020 05:59:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is closed, please resubmit this when it opens back up
