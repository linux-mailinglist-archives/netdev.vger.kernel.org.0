Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05D188374
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfHITrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:47:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37102 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfHITri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:47:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E6191265AE21;
        Fri,  9 Aug 2019 12:47:38 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:47:37 -0700 (PDT)
Message-Id: <20190809.124737.1555857142412327777.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     tlfalcon@linux.ibm.com, mpe@ellerman.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next v2] ibmveth: Allow users to update reported
 speed and duplex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806151524.69d75f8d@cakuba.netronome.com>
References: <1565108588-17331-1-git-send-email-tlfalcon@linux.ibm.com>
        <20190806151524.69d75f8d@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:47:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 6 Aug 2019 15:15:24 -0700

> On Tue,  6 Aug 2019 11:23:08 -0500, Thomas Falcon wrote:
>> Reported ethtool link settings for the ibmveth driver are currently
>> hardcoded and no longer reflect the actual capabilities of supported
>> hardware. There is no interface designed for retrieving this information
>> from device firmware nor is there any way to update current settings
>> to reflect observed or expected link speeds.
>> 
>> To avoid breaking existing configurations, retain current values as
>> default settings but let users update them to match the expected
>> capabilities of underlying hardware if needed. This update would
>> allow the use of configurations that rely on certain link speed
>> settings, such as LACP. This patch is based on the implementation
>> in virtio_net.
>> 
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> 
> Looks like this is the third copy of the same code virtio and
> netvsc have :(  Is there a chance we could factor this out into
> helpers in the core?

Yeah, let's stop the duplication of code while we can.

Thomas please perform the consolidation and respin.

Thank you.
