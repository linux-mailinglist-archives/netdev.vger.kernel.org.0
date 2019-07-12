Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4466F94
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfGLNHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:07:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:50736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLNHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:07:33 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvGh-0005ei-8M; Fri, 12 Jul 2019 15:07:19 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvGh-0005Qo-03; Fri, 12 Jul 2019 15:07:19 +0200
Subject: Re: [PATCH bpf] xdp: fix possible cq entry leak
To:     Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
 <20190704142503.23501-1-i.maximets@samsung.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <47c7cc21-6e4c-63a6-7649-5486fcd43607@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:07:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190704142503.23501-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/2019 04:25 PM, Ilya Maximets wrote:
> Completion queue address reservation could not be undone.
> In case of bad 'queue_id' or skb allocation failure, reserved entry
> will be leaked reducing the total capacity of completion queue.
> 
> Fix that by moving reservation to the point where failure is not
> possible. Additionally, 'queue_id' checking moved out from the loop
> since there is no point to check it there.
> 
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Applied, thanks!
