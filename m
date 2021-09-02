Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0623FE9B7
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 09:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbhIBHIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 03:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhIBHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 03:08:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB31EC061575;
        Thu,  2 Sep 2021 00:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6sjnkjopQPMxohcGm3e2DVG2cvE/ih6IU12E9ib69XQ=;
        t=1630566437; x=1631776037; b=NsgjSPP1mvxmNeZHsQnKjY4PsnFAKdtkfr4uw/dobmBTmQG
        9mJzd0tf2BPLc3cDYpiFIseWWcTb+hrRiH8kn9w23yZYcwifZdA8InevYGUVSNRE+PotmJ88K2ELW
        Jg9ET6guZzarXLTibvWEd/4X77NWkK8ZfbciM5A18riuwZXY5XrKHylrAPE1yvZrayH7KlZNWgeAz
        HrBoW1MAOZuO+/ID1dY+/uHm/oIL+NXgBKfWCEXkj66RM9niwvYjv8jS2sna4C+h/lbEcm/6X9GO3
        vX+VOh/Y024TI3kD3uFPDJAZaaM7Ujgcyhdo/HipZeJbfjPdvaZKvEP9ksWH+EmQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mLgoQ-001VOD-By; Thu, 02 Sep 2021 09:07:02 +0200
Message-ID: <f226f487ca0e815c197e6638ba57f06490ba9cbe.camel@sipsolutions.net>
Subject: Re: [GIT PULL] Networking for v5.15
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>
Date:   Thu, 02 Sep 2021 09:07:01 +0200
In-Reply-To: <bb2a4294-b0b3-e36f-8828-25fde646be2c@lwfinger.net>
References: <20210831203727.3852294-1-kuba@kernel.org>
         <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
         <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <bb2a4294-b0b3-e36f-8828-25fde646be2c@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-09-02 at 00:55 -0500, Larry Finger wrote:
> 
> I did not get the bisection finished tonight, but commit eb09ae93dabf is not the 
> problem.
> 
> My bisection has identified commit 7a3f5b0de36 ("netfilter: add netfilter hooks 
> to SRv6 data plane") as bad, and commit 9055a2f59162 ("ixp4xx_eth: make ptp 
> support a platform driver") as good.

Can you send the backtraces from the RTNL assertions you posted?
Probably easier that way anyway.

johannes

