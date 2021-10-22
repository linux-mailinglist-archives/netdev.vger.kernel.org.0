Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32682437F24
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhJVUNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhJVUNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 16:13:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C1EC061764;
        Fri, 22 Oct 2021 13:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Mt1ER8wBgAFwSEEoJbsiwGVzZMY2Dxu84p6MYzt5mlA=;
        t=1634933448; x=1636143048; b=WqJefOdtCd/nIiTy4OqJHrC4gnOvati11qpKb4v+yZTZfct
        I9A4gOoiIo9Cq4ihLnyJZ2xbwWFyWVI0aWGroSnoIEDyg16fAl9KNu7WEGyA6+TKgkRh9+4QRCnYO
        O+lb5Ew05aY8VsrzsHNXNA7Zapld/VHesbeyIyXtLf/p3v4osxWpTBTlQg2A2VVm0I6UHbJaIUdVO
        tOi2JtsiUuPb1oO2OSPCqVkLVyQ06nMi1gtTAgWdbl7dcw364IJFCvzS5HKQ7sMbmpkRpwEg5sTK1
        R0N1TE6xQ0Zg5PpNwHFNjK0lgwx2ciOlzPlrcIb62lUNY/y1BwQj3X6Pq1aWtpaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1me0sI-005mGx-HK;
        Fri, 22 Oct 2021 22:10:46 +0200
Date:   Fri, 22 Oct 2021 22:10:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2021-10-21
In-Reply-To: <20211022130308.43487b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211021154351.134297-1-johannes@sipsolutions.net> <163493100739.20489.10617693347363757800.git-patchwork-notify@kernel.org> <5e093d1aa26f0b442dd37c293ae57fcc837e448a.camel@sipsolutions.net> <20211022130308.43487b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <83548B49-B090-48D1-9776-766A5B6FD9E7@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 October 2021 22:03:08 CEST, Jakub Kicinski <kuba@kernel=2Eorg> wrote=
:
>You missed the previous PR by like 15 min :(=20

:-)

>Next one on Thursday, I think=2E Good enough?

Sure, it's just a small cleanup anyway, I didn't want to have a conflict f=
or something that unimportant=2E

Thanks,
johannes=20

--=20
Sent from my phone=2E
