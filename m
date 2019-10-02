Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED52C8E41
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfJBQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:25:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfJBQZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:25:30 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09D8D1540C17C;
        Wed,  2 Oct 2019 09:25:28 -0700 (PDT)
Date:   Wed, 02 Oct 2019 12:25:25 -0400 (EDT)
Message-Id: <20191002.122525.268614882710746078.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] SJA1105 DSA coding style cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001191801.9130-1-olteanv@gmail.com>
References: <20191001191801.9130-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 09:25:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  1 Oct 2019 22:17:58 +0300

> This series provides some mechanical cleanup patches related to function
> names and prototypes.

Series applied.
