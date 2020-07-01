Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABEE2115F7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgGAWZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAWZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:25:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77231C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 15:25:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DAB614959202;
        Wed,  1 Jul 2020 15:25:32 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:25:31 -0700 (PDT)
Message-Id: <20200701.152531.404414400889297618.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v14 0/3] xen networking: add XDP support to
 xen-netfront
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593436409-1101-1-git-send-email-kda@linux-powerpc.org>
References: <1593436409-1101-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:25:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Mon, 29 Jun 2020 16:13:26 +0300

> The first patch adds a new extra type to enable proper synchronization
> between an RX request/response pair.
> The second patch implements BFP interface for xen-netfront.
> The third patch enables extra space for XDP processing.
 ...

Series applied, thank you.
