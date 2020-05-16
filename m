Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF52C1D640C
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgEPUrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726659AbgEPUrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:47:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB7BC061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 13:47:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0652D119447B7;
        Sat, 16 May 2020 13:47:13 -0700 (PDT)
Date:   Sat, 16 May 2020 13:47:13 -0700 (PDT)
Message-Id: <20200516.134713.1292776651602163885.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netns: enable to inherit devconf from current
 netns
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513135843.8242-1-nicolas.dichtel@6wind.com>
References: <20200513135843.8242-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:47:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 13 May 2020 15:58:43 +0200

> The goal is to be able to inherit the initial devconf parameters from the
> current netns, ie the netns where this new netns has been created.
> 
> This is useful in a containers environment where /proc/sys is read only.
> For example, if a pod is created with specifics devconf parameters and has
> the capability to create netns, the user expects to get the same parameters
> than his 'init_net', which is not the real init_net in this case.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks.
