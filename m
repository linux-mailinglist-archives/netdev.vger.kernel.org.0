Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7E53E4D88
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbhHIUBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235812AbhHIUBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:01:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157FFC061798;
        Mon,  9 Aug 2021 13:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Om3EEuXdHWjYj9gS/+HAJ1lLyTQFKGdm9B9GiLl+f8Y=;
        t=1628539246; x=1629748846; b=DaCNr5SrePeGkwD19tm3CVKB3cEUTAUuL1sDroRaaSmLFFY
        S+alGsOVFMBS1TtyTKqNAQIz9jaKCo9kc965iX8EMgNfhWq7Yl/Bq0t6Re2VT9tEQkTD4U9JGUr1I
        ucglAaL0JP/CDmBoFsc+QtMwogYxO+X/xepDddxrWh+XtC7F7N5YA/zz+Sz8rL26i09+xyVyDYDx2
        VqOJgs7nj9Y70RwmFavLngn1QnTQCbjHZ7pjcoAZtYSG8oZvn8bB8bHqCNn6hTg39NycIsAFye/Hr
        5tNfJ74MCfgamAe4g0O7k3obTG87lm+H9DWXqGGXDUz9OwM8KRH/3FTxUNXFtpkQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mDBPI-008GAP-OL; Mon, 09 Aug 2021 22:00:35 +0200
Message-ID: <d61f3947cddec660cbb2a59e2424d2bd8c01346a.camel@sipsolutions.net>
Subject: Re: [PATCH RFC v1 3/7] rtw88: Use rtw_iterate_stas where the
 iterator reads or writes registers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Date:   Mon, 09 Aug 2021 22:00:34 +0200
In-Reply-To: <981001e2981346ada4dcc08558b87a18@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
         <20210717204057.67495-4-martin.blumenstingl@googlemail.com>
         <27d8246ef3c9755b3e6e908188ca36f7b0fab3fc.camel@sipsolutions.net>
         <CAFBinCAzoPmtvH1Wn9dY4pFsERQ5N+0xXRG=UB1eEGe_qTf+6w@mail.gmail.com>
         <981001e2981346ada4dcc08558b87a18@realtek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> I am thinking rtw88 needs to maintain sta and vif lists itself, 

I would tend to prefer drivers do not maintain separate lists - that's
just duplicated book-keeping and prone to state mismatch errors?

But OTOH the locking does make things complex.

johannes

