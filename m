Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4371AA0F7
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369713AbgDOMdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:33:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:43448 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369691AbgDOMdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 08:33:16 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jOhE6-00016w-E9; Wed, 15 Apr 2020 14:33:10 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jOhE6-000Chb-3v; Wed, 15 Apr 2020 14:33:10 +0200
Subject: Re: [PATCH bpf] xsk: add missing check on user supplied headroom size
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     minhquangbui99@gmail.com, bpf@vger.kernel.org
References: <1586849715-23490-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <61aa8e08-0a39-306b-e77d-f1398596b6e9@iogearbox.net>
Date:   Wed, 15 Apr 2020 14:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1586849715-23490-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 9:35 AM, Magnus Karlsson wrote:
> Add a check that the headroom cannot be larger than the available
> space in the chunk. In the current code, a malicious user can set the
> headroom to a value larger than the chunk size minus the fixed XDP
> headroom. That way packets with a length larger than the supported
> size in the umem could get accepted and result in an out-of-bounds
> write.
> 
> Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
> Reported-by: Bui Quang Minh <minhquangbui99@gmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=207225
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks everyone!
