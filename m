Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E5C9878E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbfHUWza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:55:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731242AbfHUWz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:55:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1B1214DE886C;
        Wed, 21 Aug 2019 15:55:28 -0700 (PDT)
Date:   Wed, 21 Aug 2019 15:55:28 -0700 (PDT)
Message-Id: <20190821.155528.1923977592342462826.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/15][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-08-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821143106.0a2ac71d@cakuba.netronome.com>
References: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
        <20190821143106.0a2ac71d@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 15:55:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 21 Aug 2019 14:31:06 -0700

> On Wed, 21 Aug 2019 13:16:08 -0700, Jeff Kirsher wrote:
>> This series contains updates to i40e driver only.
> 
> Patch 12 should really be squashed into 13, 7 and 9 could also be
> combined. But not a big deal, I guess.

Agreed, publicizing a function is not a discreet change within the
same module.  Whereas doing so in order to facilitate a new external
user as part of another change, on the other hand, is.
