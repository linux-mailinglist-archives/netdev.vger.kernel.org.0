Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF218E6B
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfEIQt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:49:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfEIQt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:49:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C709B14D07B9F;
        Thu,  9 May 2019 09:49:55 -0700 (PDT)
Date:   Thu, 09 May 2019 09:49:55 -0700 (PDT)
Message-Id: <20190509.094955.1442479082286779117.davem@davemloft.net>
To:     petkan@nucleusys.com
Cc:     oneukum@suse.com, netdev@vger.kernel.org
Subject: Re: [PATCH] rtl8150: switch to BIT macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509143441.sm4zygbeasvyja3z@carbon>
References: <20190509090106.9065-1-oneukum@suse.com>
        <20190509143441.sm4zygbeasvyja3z@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:49:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Thu, 9 May 2019 17:34:41 +0300

> On 19-05-09 11:01:06, Oliver Neukum wrote:
>> A bit of housekeeping switching the driver to the BIT()
>> macro.
> 
> Looks good.  I hope you've at least compiled the driver? :)
> 
> Acked-by: Petko Manolov <petkan@nucleusys.com>

net-next is closed for cleanups like this, please resubmit when it opens
back up.  Thank you.
