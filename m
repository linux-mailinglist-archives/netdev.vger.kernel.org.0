Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF28B1BB074
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgD0VXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:23:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:47950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgD0VXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:23:40 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBE0-0002BI-Qy; Mon, 27 Apr 2020 23:23:36 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBE0-000QGE-FV; Mon, 27 Apr 2020 23:23:36 +0200
Subject: Re: [PATCH 1/5] bpf-cgroup: remove unused exports
To:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrey Ignatov <rdna@fb.com>
References: <20200424064338.538313-1-hch@lst.de>
 <20200424064338.538313-2-hch@lst.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7f4e6ed3-d009-4636-34dc-b115cf310c0f@iogearbox.net>
Date:   Mon, 27 Apr 2020 23:23:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200424064338.538313-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/20 8:43 AM, Christoph Hellwig wrote:
> Except for a few of the networking hooks called from modular ipv4 or
> ipv6 code, all of hooks are just called from guaranteed to be built-in
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Andrey Ignatov <rdna@fb.com>

Applied this one to bpf-next, thanks!
