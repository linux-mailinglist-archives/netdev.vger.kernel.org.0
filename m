Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FFDAA404
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388467AbfIENNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:13:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:55368 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388243AbfIENNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 09:13:20 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5rZf-0007Uz-LW; Thu, 05 Sep 2019 15:13:19 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5rZf-000NOu-DN; Thu, 05 Sep 2019 15:13:19 +0200
Subject: Re: [PATCH bpf-next] ixgbe: fix xdp handle calculations
To:     Kevin Laatz <kevin.laatz@intel.com>, netdev@vger.kernel.org,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
References: <20190905011217.3567-1-kevin.laatz@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8f705b0a-e0e8-df0f-e5ed-e94dc809fb5c@iogearbox.net>
Date:   Thu, 5 Sep 2019 15:13:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190905011217.3567-1-kevin.laatz@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25563/Thu Sep  5 10:24:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/19 3:12 AM, Kevin Laatz wrote:
> Currently, we don't add headroom to the handle in ixgbe_zca_free,
> ixgbe_alloc_buffer_slow_zc and ixgbe_alloc_buffer_zc. The addition of the
> headroom to the handle was removed in
> commit d8c3061e5edd ("ixgbe: modify driver for handling offsets"), which
> will break things when headroom isvnon-zero. This patch fixes this and uses
> xsk_umem_adjust_offset to add it appropritely based on the mode being run.
> 
> Fixes: d8c3061e5edd ("ixgbe: modify driver for handling offsets")
> Reported-by: Bjorn Topel <bjorn.topel@intel.com>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Applied, thanks!
