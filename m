Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A489C10F
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfHXXr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:47:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHXXr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:47:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87B2F152619AC;
        Sat, 24 Aug 2019 16:47:26 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:47:26 -0700 (PDT)
Message-Id: <20190824.164726.357731088137490877.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jeffrey.t.kirsher@intel.com, david.m.ertman@intel.com,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        andrewx.bowers@intel.com
Subject: Re: [net-next 07/14] ice: Rename ethtool private flag for lldp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190823183111.509e176c@cakuba.netronome.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
        <20190823233750.7997-8-jeffrey.t.kirsher@intel.com>
        <20190823183111.509e176c@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:47:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 23 Aug 2019 18:31:11 -0700

> On Fri, 23 Aug 2019 16:37:43 -0700, Jeff Kirsher wrote:
>> From: Dave Ertman <david.m.ertman@intel.com>
>> 
>> The current flag name of "enable-fw-lldp" is a bit cumbersome.
>> 
>> Change priv-flag name to "fw-lldp-agent" with a value of on or
>> off.  This is more straight-forward in meaning.
>> 
>> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> 
> Just flagging this for Dave, it was introduced in v5.2 by:

So should we backport the rename into 'net'?  Is this a bug fix or just
making life easier for people?
