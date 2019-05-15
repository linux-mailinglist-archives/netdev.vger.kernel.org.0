Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC511FD7B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 03:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEPBqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 21:46:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:58082 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfEOXmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 19:42:33 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hR3Xb-0002sp-RQ; Thu, 16 May 2019 01:42:31 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hR3Xb-0005E8-LJ; Thu, 16 May 2019 01:42:31 +0200
Subject: Re: [PATCH bpf 1/2] selftests/bpf: add missing \n to flow_dissector
 CHECK errors
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20190514211234.25097-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3fa1ed2b-e79a-7f65-67fd-9cc11a0cb25f@iogearbox.net>
Date:   Thu, 16 May 2019 01:42:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190514211234.25097-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25450/Wed May 15 09:59:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/14/2019 11:12 PM, Stanislav Fomichev wrote:
> Otherwise, in case of an error, everything gets mushed together.
> 
> Fixes: a5cb33464e53 ("selftests/bpf: make flow dissector tests more extensible")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Both applied, thanks!
