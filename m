Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5BC68D066
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjBGHQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBGHQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:16:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6C2AD12;
        Mon,  6 Feb 2023 23:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2817E611EC;
        Tue,  7 Feb 2023 07:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D323C433EF;
        Tue,  7 Feb 2023 07:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675754191;
        bh=7ZAG2Gv6Qe3yVJ4Mp1PlV55GuwUWAH8smj85Hoka1Zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oJG3T6M/f5RFqJdMFSd7yp8Mbq6MHeoP69hGs2DbEFAwZquDEZfrgCQWQ1SaNsELQ
         C+TpA4QqKaml/HhyFtiFFzsOz5M2Rt5gpJej8cl1YWCvNPL77ymgzgn77yxkKn3n29
         Gr6u/QGoVqs/7yPmZS34tQw1rCMsX1rYd5fvp2K02WOLzw5lXwH0Z4jMMrjc65GjON
         qch/tmkbSuIso0CpzSc9APTWE1aHk4VR+Rc4zRcNSPUvTf+mjc0F+wo07qZiRSzldz
         BVf18qEyv3nMDtckx3dmS6cd1xpQNoGLNEuTMDn5Rug/JvcFnQ60sILSbuCdhDTMK8
         KrYYxN40FgGBw==
Date:   Mon, 6 Feb 2023 23:16:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH 0/17] crypto: api - Change completion callback argument
 to void star
Message-ID: <20230206231629.03572f5a@kernel.org>
In-Reply-To: <20230206231008.64c822c1@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
        <20230206231008.64c822c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Feb 2023 23:10:08 -0800 Jakub Kicinski wrote:
> Buggy means bug could be hit in real light or buggy == did not use 
> the API right?

"in real light"... time to sign off for the night. s/light/life/
