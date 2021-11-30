Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A71462E28
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhK3IGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbhK3IGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 03:06:51 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46332C061714
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 00:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=uDe44T9uMm2Ho9I+XpilySothrARD8K+vfSDwWdWPaU=;
        t=1638259412; x=1639469012; b=Dz5cavtYBsCCRgw8kWaNM53W41ovUr2inCuMNCa8XVP5sEx
        5alpYMajHVsHamdagTCcCeVYJDwWsF+q4rc7I/K1ORZlBB1lBqAwGkJgE88n56N6I/89ZpSEhK7HG
        Ow9J6iNlY2LJkKvpZRwy21jTDg/UObmylVGJZkaBbISOihHlyoEKvy4KhrlGdxLUrgY0cO4mADV5L
        SiRSZmddnC8j20oYg2e92oqQnRvdILoHy3ZEgv7/vQrjqcd+VVZlpG8iZ5iEnbg5w1MA3ZSbVAl85
        Pw5m6Uqw6z/8fGzg9hJbKyYeIYc4GB6L9XCIXzVS/A18uRASD91/efuMwzs97JzA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mry6n-004oxJ-46;
        Tue, 30 Nov 2021 09:03:25 +0100
Message-ID: <392f3d3cc15018c789ed5fe2a8ad278cd0ceceda.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND net-next 0/5] WWAN debugfs tweaks
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Leon Romanovsky <leon@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 30 Nov 2021 09:03:24 +0100
In-Reply-To: <YaPKJ1JADMxheh0b@unreal>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
         <YaPKJ1JADMxheh0b@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-11-28 at 20:27 +0200, Leon Romanovsky wrote:
> 
> I personally see your CONFIG_*_DEBUGFS patches as a mistake, which
> complicates code without any gain at all. Even an opposite is true,
> by adding more knobs, you can find yourself with the system which
> has CONFIG_DEBUGFS enabled but with your CONFIG_*_DEBUGFS disabled.
> 

I tend to agree with this - it has already happened to me "in the wild"
that I've had to walk people through a handful of DEBUGFS options to
finally get all the right data ...

johannes
