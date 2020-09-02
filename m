Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FCD25AE04
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgIBO6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:58:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:38394 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIBO5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:57:53 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDUCr-0001Zj-Qp; Wed, 02 Sep 2020 16:57:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDUCr-0004S5-LE; Wed, 02 Sep 2020 16:57:49 +0200
Subject: Re: [PATCH bpf-next] xsk: fix possible segfault in xsk umem
 diagnostics
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
References: <1599036743-26454-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <06ad8200-8b81-fbaf-b796-d0961b83e170@iogearbox.net>
Date:   Wed, 2 Sep 2020 16:57:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1599036743-26454-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 10:52 AM, Magnus Karlsson wrote:
> Fix possible segfault in the xsk diagnostics code when dumping
> information about the umem. This can happen when a umem has been
> created, but the socket has not been bound yet. In this case, the xsk
> buffer pool does not exist yet and we cannot dump the information
> that was moved from the umem to the buffer pool. Fix this by testing
> for the existence of the buffer pool and if not there, do not dump any
> of that information.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: syzbot+3f04d36b7336f7868066@syzkaller.appspotmail.com
> Fixes: c2d3d6a47462 ("xsk: Move queue_id, dev and need_wakeup to buffer pool")
> Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")

Applied, thanks!
