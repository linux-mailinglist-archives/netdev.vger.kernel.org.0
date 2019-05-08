Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF417E5C
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfEHQoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:44:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfEHQoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:44:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E77BE1405214E;
        Wed,  8 May 2019 09:44:13 -0700 (PDT)
Date:   Wed, 08 May 2019 09:44:13 -0700 (PDT)
Message-Id: <20190508.094413.936255759105140490.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lantiq: fix spelling mistake "brigde" ->
 "bridge"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508102209.6830-1-colin.king@canonical.com>
References: <20190508102209.6830-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:44:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed,  8 May 2019 11:22:09 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are several spelling mistakes in dev_err messages. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
