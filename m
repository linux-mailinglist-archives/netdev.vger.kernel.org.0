Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B863A1138FE
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfLEAza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:55:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLEAza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:55:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 777EA14F2F78D;
        Wed,  4 Dec 2019 16:55:29 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:55:28 -0800 (PST)
Message-Id: <20191204.165528.1483577978366613524.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     willemdebruijn.kernel@gmail.com, vvidic@valentin-vidic.from.hr,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191204150136.2f001242@cakuba.netronome.com>
References: <CA+FuTSdhtGZtTnuncpYaoOROF7L=coGawCPSLv7jzos2Q+Tb=Q@mail.gmail.com>
        <20191204.125135.750458923752225025.davem@davemloft.net>
        <20191204150136.2f001242@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:55:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 4 Dec 2019 15:01:36 -0800

> Valentin, what's the strategy you're using for this fix? There's a
> bunch of ENOTSUPP in net/tls/tls_sw.c as well, could you convert those,
> too?

Yes I see those as well, let's get them all in one patch ok?
