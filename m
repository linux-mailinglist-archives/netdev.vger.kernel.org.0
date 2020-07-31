Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6C233C64
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgGaAFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:05:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:45734 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgGaAFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:05:40 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IYM-00072b-EH; Fri, 31 Jul 2020 02:05:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IYM-0001nW-8a; Fri, 31 Jul 2020 02:05:38 +0200
Subject: Re: [PATCH bpf-next] libbpf: make destructors more robust by handling
 ERR_PTR(err) cases
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Song Liu <songliubraving@fb.com>
References: <20200729232148.896125-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d83974fc-376b-2cb2-b213-e38aa554d508@iogearbox.net>
Date:   Fri, 31 Jul 2020 02:05:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200729232148.896125-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25889/Thu Jul 30 17:03:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 1:21 AM, Andrii Nakryiko wrote:
> Most of libbpf "constructors" on failure return ERR_PTR(err) result encoded as
> a pointer. It's a common mistake to eventually pass such malformed pointers
> into xxx__destroy()/xxx__free() "destructors". So instead of fixing up
> clean up code in selftests and user programs, handle such error pointers in
> destructors themselves. This works beautifully for NULL pointers passed to
> destructors, so might as well just work for error pointers.
> 
> Suggested-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
