Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2B69A585
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 04:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390794AbfHWC20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 22:28:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390502AbfHWC2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 22:28:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF187153AC223;
        Thu, 22 Aug 2019 19:28:24 -0700 (PDT)
Date:   Thu, 22 Aug 2019 19:28:24 -0700 (PDT)
Message-Id: <20190822.192824.2273357204230762835.davem@davemloft.net>
To:     benwei@fb.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next] net/ncsi: update response packet length for
 GCPS/GNS/GNPTS commands
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CH2PR15MB3686567EBCBE71B41C5F079AA3AA0@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB3686567EBCBE71B41C5F079AA3AA0@CH2PR15MB3686.namprd15.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 19:28:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Wei <benwei@fb.com>
Date: Wed, 21 Aug 2019 22:08:49 +0000

> Update response packet length for the following commands per NC-SI spec
> - Get Controller Packet Statistics
> - Get NC-SI Statistics
> - Get NC-SI Pass-through Statistics command
> 
> Signed-off-by: Ben Wei <benwei@fb.com>

Applied, thanks Ben.
