Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD32D2B2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfE2ALR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:11:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfE2ALQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:11:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6642C13FBDE90;
        Tue, 28 May 2019 17:11:16 -0700 (PDT)
Date:   Tue, 28 May 2019 17:11:16 -0700 (PDT)
Message-Id: <20190528.171116.2068345016721052525.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org, camelia.groza@nxp.com
Subject: Re: [PATCH net-next] enetc: Enable TC offloading with mqprio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558970491-15931-1-git-send-email-claudiu.manoil@nxp.com>
References: <1558970491-15931-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:11:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Mon, 27 May 2019 18:21:31 +0300

> From: Camelia Groza <camelia.groza@nxp.com>
> 
> Add support to configure multiple prioritized TX traffic
> classes with mqprio.
> 
> Configure one BD ring per TC for the moment, one netdev
> queue per TC.
> 
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied.
