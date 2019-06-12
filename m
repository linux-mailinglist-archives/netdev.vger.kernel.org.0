Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90825429E2
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408812AbfFLOtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:49:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:45262 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfFLOs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:48:59 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4YT-0007ga-Sh; Wed, 12 Jun 2019 16:48:49 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4YT-0001m9-Hf; Wed, 12 Jun 2019 16:48:49 +0200
Subject: Re: [PATCH bpf] xdp: check device pointer before clearing
To:     Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
References: <CGME20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e@eucas1p2.samsung.com>
 <20190607172732.4710-1-i.maximets@samsung.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d7957438-2f69-44de-c999-1e1568ef6d74@iogearbox.net>
Date:   Wed, 12 Jun 2019 16:48:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190607172732.4710-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2019 07:27 PM, Ilya Maximets wrote:
> We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.
> 
> Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Applied, thanks!
