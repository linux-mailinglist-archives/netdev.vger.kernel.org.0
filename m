Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A356C12
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfFZOdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:33:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:44924 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZOdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:33:13 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8z1-0000dn-U6; Wed, 26 Jun 2019 16:33:11 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8z1-000ItL-OK; Wed, 26 Jun 2019 16:33:11 +0200
Subject: Re: [PATCH v2] samples: bpf: make the use of xdp samples consistent
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20190625005536.2516-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <45a51f5a-4598-4ecb-7374-3a1fccfd258b@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:33:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190625005536.2516-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25/2019 02:55 AM, Daniel T. Lee wrote:
> Currently, each xdp samples are inconsistent in the use.
> Most of the samples fetch the interface with it's name.
> (ex. xdp1, xdp2skb, xdp_redirect_cpu, xdp_sample_pkts, etc.)
> 
> But some of the xdp samples are fetching the interface with
> ifindex by command argument.
> 
> This commit enables xdp samples to fetch interface with it's name
> without changing the original index interface fetching.
> (<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c does.)
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Applied, thanks!
