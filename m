Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C3520D8F7
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgF2TnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387995AbgF2Tmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:42:44 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE81C02F026;
        Mon, 29 Jun 2020 07:57:40 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpvE2-0000Ta-Oh; Mon, 29 Jun 2020 16:57:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpvE2-000RAy-GV; Mon, 29 Jun 2020 16:57:38 +0200
Subject: Re: [PATCH bpf-next v2 0/3] bpf, netns: Prepare for multi-prog
 attachment
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20200623103459.697774-1-jakub@cloudflare.com>
 <9b9f413c-fa55-2fd9-a6d8-12e434a2b603@iogearbox.net>
Message-ID: <d2b4cb4e-77aa-95e2-41cf-2d95c71c34a1@iogearbox.net>
Date:   Mon, 29 Jun 2020 16:57:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9b9f413c-fa55-2fd9-a6d8-12e434a2b603@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25858/Mon Jun 29 15:30:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/20 4:56 PM, Daniel Borkmann wrote:
[...]
> Applied, thanks!

(The v3 one of course.)
