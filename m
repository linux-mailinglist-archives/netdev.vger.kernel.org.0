Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081732957D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390306AbfEXKJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389806AbfEXKJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 06:09:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EA3F93004159;
        Fri, 24 May 2019 10:09:17 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.36.118.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16545679D8;
        Fri, 24 May 2019 10:09:15 +0000 (UTC)
Date:   Fri, 24 May 2019 12:09:14 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [RESEND][PATCH] Fix MACsec kernel panics, oopses and bugs
Message-ID: <20190524100914.GA20686@bistromath.localdomain>
References: <32eb738a0a0f3ed5880911e4ac4ceedca76e3f52.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32eb738a0a0f3ed5880911e4ac4ceedca76e3f52.camel@domdv.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 24 May 2019 10:09:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas,

2019-05-23, 09:46:15 +0200, Andreas Steinmetz wrote:
> MACsec causes oopses followed by a kernel panic when attached
> directly or indirectly to a bridge. It causes erroneous checksum
> messages when attached to vxlan.

It looks like you're fixing multiple separate bugs in a single patch,
which makes it really difficult to understand. You're also not
describing what the issues are, and why the changes you're proposing
are fixing those bugs.

Do you have reproducers for those bugs? That would be helpful, as I've
never seen the panics/leaks/checksum issues you're mentioning.

> When I did investigate I did find skb leaks, apparent skb mis-handling and
> superfluous code. The attached patch fixes all MACsec misbehaviour I could find.

Please fix only one issue per patch. Otherwise, it's really hard to
tell what change fixes which issue.


Thanks,

-- 
Sabrina
