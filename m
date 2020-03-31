Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F4319924B
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 11:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgCaJbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 05:31:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58262 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730076AbgCaJbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 05:31:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jJDEZ-008Z84-N2; Tue, 31 Mar 2020 11:30:59 +0200
Message-ID: <52358d231e26dcb27b710c22f7993e0d331796ec.camel@sipsolutions.net>
Subject: Re: [linux-next] bisected: first bad commit: mac80211: Check port
 authorization in the ieee80211_tx_dequeue() case
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jouni Malinen <jouni@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 31 Mar 2020 11:30:58 +0200
In-Reply-To: <20200331092125.GA502@jagdpanzerIV.localdomain> (sfid-20200331_112312_529274_57BBC7B4)
References: <20200331092125.GA502@jagdpanzerIV.localdomain>
         (sfid-20200331_112312_529274_57BBC7B4)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-31 at 18:21 +0900, Sergey Senozhatsky wrote:
> Hello,
> 
> Commit "mac80211: Check port authorization in the ieee80211_tx_dequeue()
> case" breaks wifi on my laptop:
> 
> 	kernel: wlp2s0: authentication with XXXXXXXXXXXXXX timed out
> 
> It just never connects to the network.

Yes, my bad. Sorry about that.

Fix just narrowly missed the release and is on the way:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240

johannes

