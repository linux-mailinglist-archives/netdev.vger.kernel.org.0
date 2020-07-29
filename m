Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813DA2327A4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgG2Wge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2Wge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 18:36:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F1CC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 15:36:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 146B5127FBF96;
        Wed, 29 Jul 2020 15:19:47 -0700 (PDT)
Date:   Wed, 29 Jul 2020 15:36:29 -0700 (PDT)
Message-Id: <20200729.153629.1424450623923218576.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        drt@linux.ibm.com
Subject: Re: [PATCH net] ibmvnic: Fix IRQ mapping disposal in error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596058592-12025-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1596058592-12025-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 15:19:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Wed, 29 Jul 2020 16:36:32 -0500

> RX queue IRQ mappings are disposed in both the TX IRQ and RX IRQ
> error paths. Fix this and dispose of TX IRQ mappings correctly in
> case of an error.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied with Fixes: tag added and queued up for -stable.
