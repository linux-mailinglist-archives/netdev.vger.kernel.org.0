Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464CF1F7E53
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 23:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFLVLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 17:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLVLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 17:11:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE661C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 14:11:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B467127AE201;
        Fri, 12 Jun 2020 14:11:20 -0700 (PDT)
Date:   Fri, 12 Jun 2020 14:11:19 -0700 (PDT)
Message-Id: <20200612.141119.2088345549482265873.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        danymadden@us.ibm.com
Subject: Re: [PATCH net] ibmvnic: Flush existing work items before device
 removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591986881-19624-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1591986881-19624-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jun 2020 14:11:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Fri, 12 Jun 2020 13:34:41 -0500

> Ensure that all scheduled work items have completed before continuing
> with device removal and after further event scheduling has been
> halted. This patch fixes a bug where a scheduled driver reset event
> is processed following device removal.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied, thank you.
