Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20AC3627DC
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbhDPSl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:41:26 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:45523 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236156AbhDPSlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:41:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E32A3146A;
        Fri, 16 Apr 2021 14:40:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 14:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xlIOQ0
        fAlmYpbd4Euqp5Dp2Typ6lOH5qTTSLEw94Egg=; b=Z2UNoeBNDw9Co0NfWtZybM
        Ba5rQoiAkQHzq92pH2v1JsavZ/mCgpcrbjm6PFdLhDSoqkrt8YQnRN9su58/cZ2Y
        52cM+z/XnR91FZ0Jo/S4KREeBfYwIuPj4n7Effedih24qxz341vQJtKcYsnip8BU
        e/RAW5yj6vHMqXAVzWSXc7DNp0X2ndgfAipdmYZZle1y8xDRYQc26Y5IG+hDAKEQ
        wKFD9T1AQ05sVmgZgz+hbGmaMjDMm28gCnLLhPqjl0cQ+fFFYW7D52zxPWPeJNXO
        L96uHFrzioLCMBhrkmUSKSMJ2B27kkh9WvSFy6jkWlsOoLa0InBvVKDS5D2ef1KA
        ==
X-ME-Sender: <xms:Otp5YCx1ImC1KcD3XfKRNAiOz9zbEhvVjKx4xApE-zoGhLpNWdWt3w>
    <xme:Otp5YOSHd1hym9z4dr3vlGjM8emg1Cp-i62twu0-zIrJ-Flki6JW5uG1hoh7fYUyB
    oXdnE4qzlQFs64>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Otp5YEUMjATR6F1IsDHFLbK6GWBA7Xkh0WuudPsHT7co-W_VfqUBrQ>
    <xmx:Otp5YIijJi2Y8AQo24-FcsCIpIOLMEbhPoe_xeXymziFIFokJnp4Rw>
    <xmx:Otp5YECVA97TH45yZQcdt4oNCtsJ5Zt_xIf2MKjvBPsnLaWXK_Zilg>
    <xmx:Otp5YN6Xiwc7IPrO056bluF2vSAHg0TjccKCIiCG3Fbqgt4thaw33g>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id A52AB24005D;
        Fri, 16 Apr 2021 14:40:57 -0400 (EDT)
Date:   Fri, 16 Apr 2021 21:40:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] scm: fix a typo in put_cmsg()
Message-ID: <YHnaNT+16WTvTGti@shredder.lan>
References: <20210416183538.1194197-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416183538.1194197-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 11:35:38AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need to store cmlen instead of len in cm->cmsg_len.
> 
> Fixes: 38ebcf5096a8 ("scm: optimize put_cmsg()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jakub Kicinski <kuba@kernel.org>

Tested-by: Ido Schimmel <idosch@nvidia.com>

(I was about to bisect, but then noticed the report from Jakub)

Thanks!
