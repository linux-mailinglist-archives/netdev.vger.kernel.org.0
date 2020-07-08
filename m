Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37CC2190D2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGHTfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgGHTff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:35:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1597C061A0B;
        Wed,  8 Jul 2020 12:35:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 440141276B32F;
        Wed,  8 Jul 2020 12:35:34 -0700 (PDT)
Date:   Wed, 08 Jul 2020 12:35:33 -0700 (PDT)
Message-Id: <20200708.123533.193185690205076854.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/5] net/smc: fixes 2020-07-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708150515.44938-1-kgraul@linux.ibm.com>
References: <20200708150515.44938-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 12:35:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Wed,  8 Jul 2020 17:05:10 +0200

> Please apply the following patch series for smc to netdev's net tree.
> 
> The patches fix problems found during more testing of SMC
> functionality, resulting in hang conditions and unneeded link
> deactivations. The clc module was hardened to be prepared for
> possible future SMCD versions.

Series applied, thank you.
