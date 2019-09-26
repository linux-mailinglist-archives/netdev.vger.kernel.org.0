Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE16DBEC3C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 08:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfIZG4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 02:56:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfIZG4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 02:56:09 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C396F1264DCC8;
        Wed, 25 Sep 2019 23:56:03 -0700 (PDT)
Date:   Thu, 26 Sep 2019 08:56:02 +0200 (CEST)
Message-Id: <20190926.085602.2172736725970238315.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     m.grzeschik@pengutronix.de, wg@grandegger.com, mkl@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, trivial@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH trivial 1/2] net: Fix Kconfig indentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923155243.6997-1-krzk@kernel.org>
References: <20190923155243.6997-1-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 23:56:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 23 Sep 2019 17:52:42 +0200

> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
>     $ sed -e 's/^        /\t/' -i */Kconfig
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Ok, I'll apply these to 'net'.
