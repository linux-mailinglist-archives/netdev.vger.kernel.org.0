Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADE822A038
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbgGVTlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVTlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:41:10 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E855C0619DC;
        Wed, 22 Jul 2020 12:41:10 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jyKbc-009Dkq-Qb; Wed, 22 Jul 2020 21:40:44 +0200
Message-ID: <adb69bc4b83d9a03ac4e8a4556f79a72c7a6f2cc.camel@sipsolutions.net>
Subject: Re: [PATCH][next] wil6210: Avoid the use of one-element array
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 22 Jul 2020 21:40:43 +0200
In-Reply-To: <20200715215755.GA21716@embeddedor> (sfid-20200715_235229_800667_63552319)
References: <20200715215755.GA21716@embeddedor>
         (sfid-20200715_235229_800667_63552319)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 16:57 -0500, Gustavo A. R. Silva wrote:
> One-element arrays are being deprecated[1]. Replace the one-element
> array with a simple value type 'u8 reserved'[2], once this is just
> a placeholder for alignment.
> 
> [1] https://github.com/KSPP/linux/issues/79
> [2] https://github.com/KSPP/linux/issues/86

Umm, no, you're misinterpreting this ... This has nothing to do with
variable length and isn't used that way. As you can see from your own
patch, since you're not changing any users.

johannes

