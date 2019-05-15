Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB251F848
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfEOQOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:14:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfEOQOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:14:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E19414E3340B;
        Wed, 15 May 2019 09:14:48 -0700 (PDT)
Date:   Wed, 15 May 2019 09:14:48 -0700 (PDT)
Message-Id: <20190515.091448.2090435908607316182.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] enetc: Allow to disable Tx SG
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557936538-23691-2-git-send-email-claudiu.manoil@nxp.com>
References: <1557936538-23691-1-git-send-email-claudiu.manoil@nxp.com>
        <1557936538-23691-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 May 2019 09:14:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Wed, 15 May 2019 19:08:57 +0300

> The fact that the Tx SG flag is fixed to 'on' is only
> an oversight. Non-SG mode is also supported. Fix this
> by allowing to turn SG off.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied.
