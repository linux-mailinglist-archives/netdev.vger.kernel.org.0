Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3664A47D13C
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhLVLqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:46:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2021 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbhLVLqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:46:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640173575; x=1671709575;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=vUJ1Jl3dmo7KXOYEHPiaB+00U8Yp9tbCcOQXGKyynvg=;
  b=FoPWrXKBLxZWCKRdsfhuTQaNsOVEwLsJK+Iv6H2dy2YvN+TdPW3zPwRM
   ph4ETH4f6wxJvZVIZytZ5Lm1gwk9JUEe6qQuMF8mhXiqxPMADfhe0vFTY
   oXpsv4+oj1mw8Oh3AU9GQrqbCqs6FGzaaLVFLWw1XJXxcUPCftiZcK1Ib
   0Lc5QIb/4jeUiKoMkEEdxeo60o8N6X6FSXqdvQjQoTwBrkp56PgovBHwv
   kdNKOSq+zYsqGTyZtb8cKaq9hoHkhBCZGISHy18yIUqoKgEmV1xqhn0sK
   jbon/jAJLLByV1hyFfCJLcYProl18N6LtFtADuGUv5OXEpNRWEBH6t3KT
   w==;
IronPort-SDR: 58a4Dl1Xkm1NtiWED5oMM6vd2k93tg65PJx/5/zqywTF+1V9upDphmkZ2c2luIyCDDHrKcdL6B
 Tx9Xs3XCgfpPswTxClcJTHp0Setv7SJerkh+CdqaV+NY5w+0ShrzubAxpfl5ZHE/PqFHp+MDpO
 zTjQ1mFmNaU/q7JjGQi+hon/uV8j1tJ8maKmF9+N/D6vCBXDE1jAW8a+uaWQHWz9R5nuPkQErP
 HhduHihzlqRBxCg9pSZ5fK5L1trwaLt2yHemtp1R+SWcpnqOjDjsQgDktxmIhJZwbQ4sMPViH8
 HK4Wq0C0HTLF+u18EJxSFuGf
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="143229183"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2021 04:46:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Dec 2021 04:46:14 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 22 Dec 2021 04:46:14 -0700
Date:   Wed, 22 Dec 2021 12:48:20 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Message-ID: <20211222114820.vj4obabkytuljqq6@soft-dev3-1.localhost>
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/26/2021 11:38, Horatiu Vultur wrote:

Hi,

Sorry for reviving this old thread. I can see this patch was marked as
"Changes Requested" [1]. The change that Heiner proposed, will not worked as
we already discussed. It is using a different mechanism to access extend
pages.
Should I just try to resend the patch or is possible to get this one?

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211126103833.3609945-1-horatiu.vultur@microchip.com/

-- 
/Horatiu
