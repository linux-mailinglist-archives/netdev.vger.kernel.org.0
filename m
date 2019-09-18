Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADDDB6845
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387623AbfIRQhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:37:09 -0400
Received: from latitanza.investici.org ([82.94.249.234]:43535 "EHLO
        latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbfIRQhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:37:09 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2019 12:37:08 EDT
Received: from mx3.investici.org (localhost [127.0.0.1])
        by latitanza.investici.org (Postfix) with ESMTP id 2388E120141;
        Wed, 18 Sep 2019 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=autistici.org;
        s=stigmate; t=1568824028;
        bh=WNqcTZAFZi/hec6Tn1CJtCpGwS4Z9DFy2GOVbNboYTI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TzC/XNhJn7mnihzwQuRfvr1UApKOAzjQp19zQWM7r6FIImaZ/Ifrl/1TL1fr2mXTh
         iGNSApPsUd+kv5lntqN0SpuKnai+QaqotaMmKuX4AQ/9KJMIzX0VPyTDNYAhUXhyxM
         xK3vMPahG4fx8LC2WTvn4NopTYNrqHLmfYodxBQg=
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234]) (Authenticated sender: najamelan@autistici.org) by localhost (Postfix) with ESMTPSA id DDB5A120493;
        Wed, 18 Sep 2019 16:27:05 +0000 (UTC)
Subject: Re: ip netns exec hides mount points from child processes
To:     netdev@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>
References: <e3493413-38f8-69a3-6ab8-7ce9610a40e9@autistici.org>
 <871s5qdgqj.fsf@xmission.com>
From:   Naja Melan <najamelan@autistici.org>
Autocrypt: addr=najamelan@autistici.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2b00e3ca-11ac-be47-ac7b-77c8fb24e3ff@autistici.org>
Date:   Wed, 18 Sep 2019 18:26:53 +0200
MIME-Version: 1.0
In-Reply-To: <871s5qdgqj.fsf@xmission.com>
Content-Type: text/plain; charset=utf-8
Content-Language: nl-BE
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for looking into it. Sorry for the long delay, but my answers got blocked by xmission several times and I think I just gave up on containers at some point. This is still not solved though. To answer Eric's question: 

> Why you don't see the new sysfs is something I need more information to understand.

> Since everything else is mounted on top of sysfs. The code probably needs an update to bind mount (cgroups, debugfs, configs, pstore, selinuxfs, and securitfs) from the old sysfs to the new sysfs.  That everything now gets mount points on sysfs is new from the time the code was written and the code just needs an update for that.

There is a mount of type sysfs. It is now called after the network namespace rather than being called sysfs, that's why I missed it last time. It looks like:
testns on /sys type sysfs (rw,relatime)

So that's probably not a problem.

So it seems the code of `ip netns exec` still hasn't been updated not to lose cgroups and all other system mounts...

I just checked with 5.2.14-arch2-1-ARCH

Thanks in advance,
Naja Melan
