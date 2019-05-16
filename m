Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139CE20F1E
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfEPTQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:16:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfEPTQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:16:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D28D1133E977F;
        Thu, 16 May 2019 12:16:25 -0700 (PDT)
Date:   Thu, 16 May 2019 12:16:25 -0700 (PDT)
Message-Id: <20190516.121625.1047167884061690279.davem@davemloft.net>
To:     dnlplm@gmail.com
Cc:     bjorn@mork.no, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1260 and 0x1261
 compositions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557934183-8469-1-git-send-email-dnlplm@gmail.com>
References: <1557934183-8469-1-git-send-email-dnlplm@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:16:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>
Date: Wed, 15 May 2019 17:29:43 +0200

> Added support for Telit LE910Cx 0x1260 and 0x1261 compositions.
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Applied, thank you.
