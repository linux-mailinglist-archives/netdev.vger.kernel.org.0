Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40B3FD107
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbhIACDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhIACDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 22:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8516102A;
        Wed,  1 Sep 2021 02:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630461757;
        bh=qa/JlIKKfChoTfKvIaNuaQ9fQbjG9at5EXHOY9AVt+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JyVdzeao2Vrg6QNGEUoPMLLU3BA/TmKaWtM0iYg29yOjsWT9hz49WxZV6uIJaDX4Z
         6jIHsek088WGqZSg/TKs3VINlJtxhVciZog/2hkTH2Hhzv+sWk1e+0DWGa21iojxb8
         wZBDSxWIivMSf3Z//LNP9Zsn5h3K7Hh1pYud/mAHbL12kUyKHpJQzkPFCfj7sgPt/P
         zU/O1ppAOC0z66xglYHGrui/265Y9ONbBFgVgpR4F/Glcqww+HRt89iplkdXSIW0i8
         QU/4GiA5/VfyPX7oSuRDvvZSfFEEpNfb9ukQ8G3xgyaqulNVVCRnqgco8XtnleCxqt
         iZPdBOqwPFcTg==
Date:   Tue, 31 Aug 2021 19:02:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "bsd@fb.com" <bsd@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210831190235.00fa780b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR11MB4958D55CB9EDD459AF076525EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210831161927.GA10747@hoboy.vegasvil.org>
        <SJ0PR11MB4958D55CB9EDD459AF076525EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 22:09:18 +0000 Machnikowski, Maciej wrote:
> OK I can strip down the RTNL EEC state interface to only report 
> the state without any extras, like pin. Next step would be to add 
> the control over recovered clock also to the netdev subsystem.
> 
> The EEC state read is needed for recovered/source clock validation
> and that's why I think it belongs to the RTNL part as it gates the QL
> for each port.

If you mean just reporting state and have a syncE on/off without any
option for other sources that's fine by me.
