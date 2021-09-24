Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28A8416CEE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbhIXHlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244369AbhIXHlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:41:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D340C061574;
        Fri, 24 Sep 2021 00:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=cEZSJ10iclaK2zD479RKOFFGF6rgm0+z22w18oPYM+k=;
        t=1632469181; x=1633678781; b=LIIYAVxZR2PXkk8FFyfdIrYPt+Jfw+k3rHblUyRJ/v98pmC
        yUTapuYO0IthKPc3+eNd5DC7a+bgKHUX2mfZ8eG/+Vjd0cCRBxgvO2AHPV/J21Cl3GvXNmgK7Jlu7
        qZBjvHiCCjU8J83zrAqKJimda5Tfn2bxW4XCcP4m+1XFWE/MZKsDduKu7jEbyvIMziQHI2AhpOEL5
        KpJfY3LIoNCLV7rM0nbftq/FzbUgiNjKyURWBVHRwWiLzmet8uyprWWvqFOuAAWOq5w4dqFNiPpoi
        rrudqntLQqrh8KoVMAL8059gtbTSJ21PAIhEqMFOoty7q8gkuAMVuzT/Vn8ShsEg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mTfnx-00B6Hj-BH;
        Fri, 24 Sep 2021 09:39:33 +0200
Message-ID: <5826123db4731bde01594212101ed5dbbea4d54f.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     Abhishek Kumar <kuabhs@chromium.org>, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Date:   Fri, 24 Sep 2021 09:39:32 +0200
In-Reply-To: <66ba0f836dba111b8c7692f78da3f079@codeaurora.org>
References: <20201215172352.5311-1-youghand@codeaurora.org>
         <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
         <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
         <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
         (sfid-20210205_225202_513086_43C9BBC9) <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
         <66ba0f836dba111b8c7692f78da3f079@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-09-24 at 13:07 +0530, Youghandhar Chintala wrote:
> Hi Johannes and felix,
> 
> We have tested with DELBA experiment during post SSR, DUT packet seq 
> number and tx pn is resetting to 0 as expected but AP(Netgear R8000) is 
> not honoring the tx pn from DUT.
> Whereas when we tested with DELBA experiment by making Linux android 
> device as SAP and DUT as STA with which we don’t see any issue. Ping got 
> resumed post SSR without disconnect.

Hm. That's a lot of data, and not a lot of explanation :)

I don't understand how DelBA and PN are related?

johannes

