Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D446C87F1D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436958AbfHIQMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:12:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:59688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406171AbfHIQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:12:34 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hw7VA-0002sq-6F; Fri, 09 Aug 2019 18:12:24 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hw7V9-0002DH-Vh; Fri, 09 Aug 2019 18:12:24 +0200
Subject: Re: [PATCH v2 bpf-next] xdp: xdp_umem: fix umem pages mapping for
 32bits systems
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc:     davem@davemloft.net, ast@kernel.org, john.fastabend@gmail.com,
        hawk@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190808093803.4918-1-ivan.khoronzhuk@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0854fff0-4e21-c78e-b2a6-7f76364a70d2@iogearbox.net>
Date:   Fri, 9 Aug 2019 18:12:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190808093803.4918-1-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25536/Fri Aug  9 10:22:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/19 11:38 AM, Ivan Khoronzhuk wrote:
> Use kmap instead of page_address as it's not always in low memory.
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied, thanks!
