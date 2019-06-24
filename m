Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378D250DB8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfFXOUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:20:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:51018 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFXOUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:20:19 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfPpR-0002PE-AQ; Mon, 24 Jun 2019 16:20:17 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfPpR-000Qoh-4m; Mon, 24 Jun 2019 16:20:17 +0200
Subject: Re: [PATCH bpf] samples/bpf: xdp_redirect, correctly get dummy
 program id
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20190620065815.7698-1-prashantbhole.linux@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ab19a95-36c7-5113-bdd2-00643bfab8b6@iogearbox.net>
Date:   Mon, 24 Jun 2019 16:20:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190620065815.7698-1-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20/2019 08:58 AM, Prashant Bhole wrote:
> When we terminate xdp_redirect, it ends up with following message:
> "Program on iface OUT changed, not removing"
> This results in dummy prog still attached to OUT interface.
> It is because signal handler checks if the programs are the same that
> we had attached. But while fetching dummy_prog_id, current code uses
> prog_fd instead of dummy_prog_fd. This patch passes the correct fd.
> 
> Fixes: 3b7a8ec2dec3 ("samples/bpf: Check the prog id before exiting")
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>

Applied, thanks!
