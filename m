Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B9E457200
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhKSPtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhKSPtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:49:47 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B63C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:46:45 -0800 (PST)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AF92E4D2DC50A;
        Fri, 19 Nov 2021 07:46:44 -0800 (PST)
Date:   Fri, 19 Nov 2021 15:46:43 +0000 (GMT)
Message-Id: <20211119.154643.1501990776976487977.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] net: constify netdev->dev_addr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 19 Nov 2021 07:46:45 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 19 Nov 2021 06:21:48 -0800

> Take care of a few stragglers and make netdev->dev_addr const.
> 
> netdev->dev_addr can be held on the address tree like any other
> address now.

Acked-by: David S. Miller <davem@davemloft.net>
