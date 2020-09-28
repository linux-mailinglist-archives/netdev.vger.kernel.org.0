Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6476427B856
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgI1Xin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgI1Xim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:38:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D1DC0613E6;
        Mon, 28 Sep 2020 15:19:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59F2811E44298;
        Mon, 28 Sep 2020 15:02:46 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:19:32 -0700 (PDT)
Message-Id: <20200928.151932.1462655542943966425.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 00/14] net/smc: introduce SMC-Dv2 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:02:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Sat, 26 Sep 2020 12:44:18 +0200

> Please apply the following patch series for smc to netdev's net-next tree.
> 
> SMC-Dv2 support (see https://www.ibm.com/support/pages/node/6326337)
> provides multi-subnet support for SMC-D, eliminating the current
> same-subnet restriction. The new version detects if any of the virtual
> ISM devices are on the same system and can therefore be used for an
> SMC-Dv2 connection. Furthermore, SMC-Dv2 eliminates the need for
> PNET IDs on s390.

Series applied, thanks.
