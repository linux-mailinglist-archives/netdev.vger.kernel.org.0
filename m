Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E44736BA
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 22:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhLMVvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 16:51:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:58474 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhLMVvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 16:51:37 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mwtEN-000BiG-Ur; Mon, 13 Dec 2021 22:51:35 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mwtEN-000S1w-P0; Mon, 13 Dec 2021 22:51:35 +0100
Subject: Re: [PATCH v3 net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <cover.1638189075.git.pabeni@redhat.com>
 <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
 <1ac2941f-b751-9cf0-f0e3-ea0f245b7503@iogearbox.net>
 <70c5f1a6ecdc67586d108ab5ebed4be6febf8423.camel@redhat.com>
 <1685fbab-e4e1-5116-5148-fa7cd8f5879b@iogearbox.net>
Message-ID: <b583c416-ad03-e65f-3d93-0a1e448480a2@iogearbox.net>
Date:   Mon, 13 Dec 2021 22:51:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1685fbab-e4e1-5116-5148-fa7cd8f5879b@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26385/Mon Dec 13 10:38:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 4:04 PM, Daniel Borkmann wrote:
> On 12/6/21 11:20 AM, Paolo Abeni wrote:
[...]
>> Yep, that would probably be better. Pleas let me know it you prefer a
>> formal new version for the patch.
> 
> Ok, I think no need, we can take care of it when applying.

Done now, thanks Paolo!
