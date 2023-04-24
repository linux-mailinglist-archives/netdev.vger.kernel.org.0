Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E0F6ED550
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjDXTXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjDXTXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:23:04 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7CF6EBA;
        Mon, 24 Apr 2023 12:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=7yqMz6dS/0GILuAnJ+Bw+7l2gpqpGz2ORupHC3iMp7g=; b=Udci7HXQo5Z06+JGryPD826NnV
        4KHAviN35/kVbULrsH2ITkkI8qbaxejQXlubCdG2bGjuBJW1k+DU8bkSzpDbaq2KKRl2jNEMMeyCM
        Z4otWX9AzD26rvexAy+93Cq1NKuKn07+egoTVvBjM1HrqqNae8xTbcRqBda/eCZCZX1gdabFYEyef
        aJ1PE6Lu0nhYEUoyIhXcOZEuwY30hOMLLh9jDXQuNkv9VZxf+H4AnlLObPAnh2or8/0/uP7syO6IH
        k1tM8LQo6tk8Vg3JrEzDxeHDNMBgSa/d2ryMmh2Ry+ecYcN6NWzck/IiCkTQU6n7NhmwxPr3l9L6I
        RWzmSGKQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pr1m3-0005db-97; Mon, 24 Apr 2023 21:22:55 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pr1m3-0007lP-1F; Mon, 24 Apr 2023 21:22:55 +0200
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     xdp-newbies@vger.kernel.org, linux-wireless@vger.kernel.org,
        netfilter-devel@vger.kernel.org
From:   Daniel Borkmann <daniel@iogearbox.net>
Subject: LPC 2023 Networking and BPF Track CFP
Message-ID: <1515db2c-f517-76da-8aad-127a67da802f@iogearbox.net>
Date:   Mon, 24 Apr 2023 21:22:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26886/Mon Apr 24 09:25:10 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are pleased to announce the Call for Proposals (CFP) for the Networking and
BPF track at the 2023 edition of the Linux Plumbers Conference (LPC) which is
taking place in Richmond, VA, United States, on November 13th - 15th, 2023.

Note that the conference is planned to be both in person and remote (hybrid).
CFP submitters should ideally be able to give their presentation in person to
minimize technical issues, although presenting remotely will also be possible.

The Networking and BPF track technical committee consists of:

    David S. Miller <davem@davemloft.net>
    Jakub Kicinski <kuba@kernel.org>
    Paolo Abeni <pabeni@redhat.com>
    Eric Dumazet <edumazet@google.com>
    Alexei Starovoitov <ast@kernel.org>
    Daniel Borkmann <daniel@iogearbox.net>
    Andrii Nakryiko <andrii@kernel.org>
    Martin Lau <martin.lau@linux.dev>

We are seeking proposals of 30 minutes in length (including Q&A discussion). Any
kind of advanced Linux networking and/or BPF related topic will be considered.

Please submit your proposals through the official LPC website at:

    https://lpc.events/event/17/abstracts/

Make sure to select "eBPF & Networking Track" in the track pull-down menu.

Proposals must be submitted by September 27th, and submitters will be notified
of acceptance by October 2nd. Final slides (as PDF) are due on the first day of
the conference.

We are very much looking forward to a great conference and seeing you all!
