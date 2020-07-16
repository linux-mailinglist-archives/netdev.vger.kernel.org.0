Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3C22197D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGPBaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgGPBaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 21:30:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9E6C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 18:30:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7053C1274BDCC;
        Wed, 15 Jul 2020 18:29:59 -0700 (PDT)
Date:   Wed, 15 Jul 2020 18:29:56 -0700 (PDT)
Message-Id: <20200715.182956.490791427431304861.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     tlfalcon@linux.ibm.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, drt@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Increase driver logging
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200715170632.11f0bf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1594857115-22380-1-git-send-email-tlfalcon@linux.ibm.com>
        <20200715170632.11f0bf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jul 2020 18:29:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 15 Jul 2020 17:06:32 -0700

> On Wed, 15 Jul 2020 18:51:55 -0500 Thomas Falcon wrote:
>>  	free_netdev(netdev);
>>  	dev_set_drvdata(&dev->dev, NULL);
>> +	netdev_info(netdev, "VNIC client device has been successfully removed.\n");
> 
> A step too far, perhaps.
> 
> In general this patch looks a little questionable IMHO, this amount of
> logging output is not commonly seen in drivers. All the the info
> messages are just static text, not even carrying any extra information.
> In an era of ftrace, and bpftrace, do we really need this?

Agreed, this is too much.  This is debugging, and thus suitable for tracing
facilities, at best.
