Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8640419B5A6
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgDASga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:36:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732308AbgDASg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:36:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2585C11E3C074;
        Wed,  1 Apr 2020 11:36:28 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:36:27 -0700 (PDT)
Message-Id: <20200401.113627.1377328159361906184.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     grygorii.strashko@ti.com, nsekhar@ti.com, t-kristo@ti.com,
        peter.ujfalusi@ti.com, robh@kernel.org, netdev@vger.kernel.org,
        rogerq@ti.com, devicetree@vger.kernel.org, kuba@kernel.org,
        m-karicheri2@ti.com, kishon@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hpAnWbnQihTVGyB-TyRYad+gWCdF7suzsXRFJg-nsU9xg@mail.gmail.com>
References: <cac3d501-cc36-73c5-eea8-aaa2d10105b0@ti.com>
        <590f9865-ace7-fc12-05e7-0c8579785f96@ti.com>
        <CA+h21hpAnWbnQihTVGyB-TyRYad+gWCdF7suzsXRFJg-nsU9xg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:36:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 1 Apr 2020 21:27:04 +0300

> I think the ARM64 build is now also broken on Linus' master branch,
> after the net-next merge? I am not quite sure if the device tree
> patches were supposed to land in mainline the way they did.

There's a fix in my net tree and it will go to Linus soon.

There is no clear policy for dt change integration, and honestly
I try to deal with the situation on a case by case basis.
