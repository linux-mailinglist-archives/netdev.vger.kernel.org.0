Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E961F7E4C
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 23:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgFLVKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 17:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLVKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 17:10:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B6C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 14:10:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A5A0127B6943;
        Fri, 12 Jun 2020 14:10:41 -0700 (PDT)
Date:   Fri, 12 Jun 2020 14:10:40 -0700 (PDT)
Message-Id: <20200612.141040.977929535227856014.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        danymadden@us.ibm.com
Subject: Re: [PATCH net] ibmvnic: Harden device login requests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591986699-19484-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1591986699-19484-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jun 2020 14:10:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Fri, 12 Jun 2020 13:31:39 -0500

> @@ -841,13 +841,14 @@ static int ibmvnic_login(struct net_device *netdev)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>  	unsigned long timeout = msecs_to_jiffies(30000);
> +	int retries = 10;
>  	int retry_count = 0;
>  	bool retry;
>  	int rc;

Reverse christmas tree, please.
