Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C01963DD
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfHTPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:12:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:42202 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfHTPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:12:22 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05nw-0000dN-Ke; Tue, 20 Aug 2019 17:12:12 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05nw-0002KW-Cj; Tue, 20 Aug 2019 17:12:12 +0200
Subject: Re: [PATCH bpf 1/1] xdp: unpin xdp umem pages in error path
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, bjorn.topel@intel.com
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, ast@kernel.org, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190815205635.6536-1-ivan.khoronzhuk@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ad6abe26-0644-7843-e3e7-7a0de704bd74@iogearbox.net>
Date:   Tue, 20 Aug 2019 17:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190815205635.6536-1-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25547/Tue Aug 20 10:27:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 10:56 PM, Ivan Khoronzhuk wrote:
> Fix mem leak caused by missed unpin routine for umem pages.
> Fixes: 8aef7340ae9695 ("commit xsk: introduce xdp_umem_page")
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied & fixed up 'Fixes:' tag, thanks.
