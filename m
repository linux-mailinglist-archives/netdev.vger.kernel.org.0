Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0BE1D4285
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgEOA6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727991AbgEOA6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:58:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F83C061A0C;
        Thu, 14 May 2020 17:58:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D508A14DD3D94;
        Thu, 14 May 2020 17:58:13 -0700 (PDT)
Date:   Thu, 14 May 2020 17:58:13 -0700 (PDT)
Message-Id: <20200514.175813.1889260919070432221.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: dp83867: Convert DP83867 to yaml
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514155905.26845-1-dmurphy@ti.com>
References: <20200514155905.26845-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:58:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Thu, 14 May 2020 10:59:05 -0500

> Convert the dp83867 binding to yaml.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Applied.
