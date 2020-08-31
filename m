Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569752583FC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 00:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgHaWSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 18:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHaWSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 18:18:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938AC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 15:18:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36F6211CE9DEC;
        Mon, 31 Aug 2020 15:01:14 -0700 (PDT)
Date:   Mon, 31 Aug 2020 15:17:57 -0700 (PDT)
Message-Id: <20200831.151757.1112716052657607181.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     tlfalcon@linux.ibm.com, netdev@vger.kernel.org,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL
 sysfs files
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831150050.3cadde6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200831131158.03ac2d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fa1d1efb-d799-a1e1-5e1e-8795d5d6cda7@linux.ibm.com>
        <20200831150050.3cadde6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 15:01:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 31 Aug 2020 15:00:50 -0700

> On Mon, 31 Aug 2020 16:44:06 -0500 Thomas Falcon wrote:
>> On 8/31/20 3:11 PM, Jakub Kicinski wrote:
>> > This seems similar to normal SR-IOV operation, but I've not heard of
>> > use cases for them VM to know what its pvid is. Could you elaborate?  
>> It's provided for informational purposes.
> 
> Seems like an information leak :S and since it's equivalent to the
> standard SR-IOV functionality - we'd strongly prefer a common
> interface for all use cases. sysfs won't be it. Jiri & Mellanox had 
> been working on something in devlink for quite some time.

Agreed, Thomas please work with Jiri et al. so that you can provide
this information using a standard facility.

Thanks.
