Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D895512AF8E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLZXOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:14:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZXOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:14:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B83A153899AB;
        Thu, 26 Dec 2019 15:14:23 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:14:22 -0800 (PST)
Message-Id: <20191226.151422.1939035312327080658.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net,v2] dpaa_eth: fix DMA mapping leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577086762-11453-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1577086762-11453-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:14:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Mon, 23 Dec 2019 09:39:22 +0200

> On the error path some fragments remain DMA mapped. Adding a fix
> that unmaps all the fragments. Rework cleanup path to be simpler.
> 
> Fixes: 8151ee88bad5 ("dpaa_eth: use page backed rx buffers")
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
> 
> Changes from v1: used Dave's suggestion to simplify cleanup path 

Applied, thanks.
