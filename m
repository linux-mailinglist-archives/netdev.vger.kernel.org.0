Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3683F25832E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 23:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgHaVDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 17:03:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:46324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaVDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 17:03:17 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqxO-0007Tf-4A; Mon, 31 Aug 2020 23:03:14 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqxN-0008pD-Aq; Mon, 31 Aug 2020 23:03:13 +0200
Subject: Re: [PATCH bpf-next] samples/bpf: fix to xdpsock to avoid recycling
 frames
To:     Weqaar Janjua <weqaar.a.janjua@intel.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
References: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a93a08b1-9460-8f46-af79-372bb41bf5ad@iogearbox.net>
Date:   Mon, 31 Aug 2020 23:03:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 6:17 PM, Weqaar Janjua wrote:
> The txpush program in the xdpsock sample application is supposed
> to send out all packets in the umem in a round-robin fashion.
> The problem is that it only cycled through the first BATCH_SIZE
> worth of packets. Fixed this so that it cycles through all buffers
> in the umem as intended.
> 
> Fixes: 248c7f9c0e21 ("samples/bpf: convert xdpsock to use libbpf for AF_XDP access")
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>

Applied, thanks!
