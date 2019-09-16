Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD933B3BFF
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfIPOAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:00:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfIPOAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:00:00 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B772153CA220;
        Mon, 16 Sep 2019 06:59:58 -0700 (PDT)
Date:   Mon, 16 Sep 2019 15:59:53 +0200 (CEST)
Message-Id: <20190916.155953.1067026088082448315.davem@davemloft.net>
To:     shalomt@mellanox.com
Cc:     idosch@idosch.org, netdev@vger.kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 0/3] mlxsw: spectrum_buffers: Add the
 ability to query the CPU port's shared buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <95297977-0757-68c2-77f3-960056050fb3@mellanox.com>
References: <20190916061750.26207-1-idosch@idosch.org>
        <95297977-0757-68c2-77f3-960056050fb3@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 06:59:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>
Date: Mon, 16 Sep 2019 08:14:47 +0000

> I have v3 with all the fixes Jiri commented. Can I send it? Or should I wait
> until net-next will be open again?

Just send it, thanks for asking.
