Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD6202029
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgFTDWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgFTDWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:22:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DE9C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:22:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA99C127853D8;
        Fri, 19 Jun 2020 20:22:29 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:22:29 -0700 (PDT)
Message-Id: <20200619.202229.791079743124441257.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net] ibmveth: Fix max MTU limit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592495026-27202-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1592495026-27202-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:22:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Thu, 18 Jun 2020 10:43:46 -0500

> The max MTU limit defined for ibmveth is not accounting for
> virtual ethernet buffer overhead, which is twenty-two additional
> bytes set aside for the ethernet header and eight additional bytes
> of an opaque handle reserved for use by the hypervisor. Update the
> max MTU to reflect this overhead.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied with Fixes: tags added and queued up for -stable.

Thank you.
