Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F237C117307
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfLIRn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:43:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLIRn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:43:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07E3915436C4C;
        Mon,  9 Dec 2019 09:43:57 -0800 (PST)
Date:   Mon, 09 Dec 2019 09:43:56 -0800 (PST)
Message-Id: <20191209.094356.813138131056263064.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        bunk@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com, robh@kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: Convert fifo-depth to common
 fifo-depth and make optional
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206164516.2702-1-dmurphy@ti.com>
References: <20191206164516.2702-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 09:43:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


These patches don't apply cleanly to my networking trees.

Please also properly supply an appropriate "[PATCH 0/N]" header posting
and clearly indicate the target GIT tree as in "[PATCH net-next 0/N]"
as well as the patch series version "[PATCH v2 net-next 0/N]" when you
repsin this.

Thanks.
