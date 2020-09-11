Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE9266A65
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgIKVzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgIKVzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:55:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B112C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:55:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1C0913665371;
        Fri, 11 Sep 2020 14:38:53 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:55:40 -0700 (PDT)
Message-Id: <20200911.145540.2143671957488133463.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] sfc: misc cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911140038.5802bae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
        <20200911140038.5802bae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:38:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 11 Sep 2020 14:00:38 -0700

> On Fri, 11 Sep 2020 19:43:26 +0100 Edward Cree wrote:
>> Clean up a few nits I noticed while working on TXQ stuff.
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied.

