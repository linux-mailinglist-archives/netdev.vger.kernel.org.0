Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2636FD2C
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhD3PBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 11:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhD3PAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 11:00:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC60C06137B;
        Fri, 30 Apr 2021 07:59:10 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lcUbe-00293F-0B; Fri, 30 Apr 2021 16:59:02 +0200
Message-ID: <573f85365f81b2505c90fd6e3e003faf48067abe.camel@sipsolutions.net>
Subject: Re: [PATCH net] rsi: Add a NULL check in rsi_core_xmit
From:   Johannes Berg <johannes@sipsolutions.net>
To:     wangyunjian <wangyunjian@huawei.com>, kuba@kernel.org,
        davem@davemloft.net
Cc:     amitkarwar@gmail.com, siva8118@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dingxiaoxiong@huawei.com
Date:   Fri, 30 Apr 2021 16:59:00 +0200
In-Reply-To: <1619794016-27348-1-git-send-email-wangyunjian@huawei.com> (sfid-20210430_164755_644415_C818D374)
References: <1619794016-27348-1-git-send-email-wangyunjian@huawei.com>
         (sfid-20210430_164755_644415_C818D374)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-30 at 22:46 +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The skb may be NULL in rsi_core_xmit().

How so?

Static checkers are good. Coverity is one of the better ones, in my
experience. But blindly believing static checkers still isn't good.

I see why the static checker is confused, but really, _you_ should have
done that work, not me.

johannes

