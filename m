Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA581FA14A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbgFOUS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFOUS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:18:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF9AC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 13:18:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63766120ED49A;
        Mon, 15 Jun 2020 13:18:26 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:18:25 -0700 (PDT)
Message-Id: <20200615.131825.395007573746693303.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        danymadden@us.ibm.com
Subject: Re: [PATCH net v2] ibmvnic: Harden device login requests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592234963-9535-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1592234963-9535-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:18:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Mon, 15 Jun 2020 10:29:23 -0500

> The VNIC driver's "login" command sequence is the final step
> in the driver's initialization process with device firmware,
> confirming the available device queue resources to be utilized
> by the driver. Under high system load, firmware may not respond
> to the request in a timely manner or may abort the request. In
> such cases, the driver should reattempt the login command
> sequence. In case of a device error, the number of retries
> is bounded.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
> v2: declare variables in Reverse Christmas tree format

Applied, thanks.
