Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F65616283D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgBROdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:33:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:43258 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgBROdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:33:35 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j43wI-00017K-HJ; Tue, 18 Feb 2020 15:33:30 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j43wI-0007nx-8Y; Tue, 18 Feb 2020 15:33:30 +0100
Subject: Re: [PATCH bpf v2] uapi/bpf: Remove text about bpf_redirect_map()
 giving higher performance
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
References: <20200218130334.29889-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e5210c2b-58b1-efae-80b5-ece62f067689@iogearbox.net>
Date:   Tue, 18 Feb 2020 15:33:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200218130334.29889-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25726/Mon Feb 17 15:01:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 2:03 PM, Toke Høiland-Jørgensen wrote:
> The performance of bpf_redirect() is now roughly the same as that of
> bpf_redirect_map(). However, David Ahern pointed out that the header file
> has not been updated to reflect this, and still says that a significant
> performance increase is possible when using bpf_redirect_map(). Remove this
> text from the bpf_redirect_map() description, and reword the description in
> bpf_redirect() slightly. Also fix the 'Return' section of the
> bpf_redirect_map() documentation.
> 
> Fixes: 1d233886dd90 ("xdp: Use bulking for non-map XDP_REDIRECT and consolidate code paths")
> Reported-by: David Ahern <dsahern@gmail.com>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied and also updated tools header, thanks!
