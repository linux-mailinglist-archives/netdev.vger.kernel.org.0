Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E11F2298BC
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbgGVMzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGVMzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:55:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E3BC0619DC;
        Wed, 22 Jul 2020 05:55:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jyEHN-0094wv-03; Wed, 22 Jul 2020 14:55:25 +0200
Message-ID: <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net>
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org
Date:   Wed, 22 Jul 2020 14:55:06 +0200
In-Reply-To: <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
         <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
         <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
         <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-22 at 14:27 +0200, Felix Fietkau wrote:

> I'm considering testing a different approach (with mt76 initially):
> - Add a mac80211 rx function that puts processed skbs into a list
> instead of handing them to the network stack directly.

Would this be *after* all the mac80211 processing, i.e. in place of the
rx-up-to-stack?

johannes

