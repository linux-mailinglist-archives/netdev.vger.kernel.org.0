Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4245331A9
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfFCODN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:03:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50600 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbfFCODN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:03:13 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 245D2B400D8;
        Mon,  3 Jun 2019 14:03:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 3 Jun
 2019 07:03:07 -0700
Subject: Re: [PATCH net] net: fix indirect calls helpers for ptype list hooks.
To:     Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <656fbe8fb21ca156d227cb012e65d017c62a1a91.1559558702.git.pabeni@redhat.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <8e5f019b-fce7-a1cb-e968-c9c4f76685e8@solarflare.com>
Date:   Mon, 3 Jun 2019 15:03:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <656fbe8fb21ca156d227cb012e65d017c62a1a91.1559558702.git.pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24654.005
X-TM-AS-Result: No-2.747300-4.000000-10
X-TMASE-MatchedRID: fgYTp5XatxbmLzc6AOD8DfHkpkyUphL9qLKYlTwO0TU3Z30zFBVlKBnT
        7Zu4XdPS29ZNH9aIyX1It09BTqMis74br6qTk1yGAZ0lncqeHqF9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0zCLNfu05PakAtuKBGekqUpm+MB6kaZ2g7kK1rRdlpxFr2EEw0oILZm/mkP+zh7KAzogR
        S3vmGkvdwTUU7U7Rq4LFhOfFAhwWfUBKMmW4g07SEx5ZDwFclhfca6Shjs8MGHzGTHoCwyHhlNK
        Sp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.747300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24654.005
X-MDID: 1559570591-ZGx6d5vqefXI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/06/2019 11:46, Paolo Abeni wrote:
> As Eric noted, the current wrapper for ptype func hook inside
> __netif_receive_skb_list_ptype() has no chance of avoiding the indirect
> call: we enter such code path only for protocols other than ipv4 and
> ipv6.
>
> Instead we can wrap the list_func invocation.
>
> Fixes: 92884ca8830b ("net: fix indirect calls helpers for ptype list hooks.")
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Edward Cree <ecree@solarflare.com>
