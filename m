Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5151DA116
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgESTlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:41:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3DAC08C5C0;
        Tue, 19 May 2020 12:41:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 848BE128B385B;
        Tue, 19 May 2020 12:41:51 -0700 (PDT)
Date:   Tue, 19 May 2020 12:41:50 -0700 (PDT)
Message-Id: <20200519.124150.829166555278246861.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     ecree@solarflare.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519171923.GA16785@salvia>
References: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
        <20200519171923.GA16785@salvia>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:41:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 19 May 2020 19:19:23 +0200

> This is breaking netfilter again.

This is vague and not useful feedback.

Please be specific about how the change breaks netfilter.

What breaks exactly, and how?

