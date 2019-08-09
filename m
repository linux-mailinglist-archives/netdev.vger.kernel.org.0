Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A3B87E53
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 17:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436799AbfHIPnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 11:43:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:51038 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfHIPnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 11:43:10 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hw72p-0000y4-Ns; Fri, 09 Aug 2019 17:43:07 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hw72p-0002ks-I4; Fri, 09 Aug 2019 17:43:07 +0200
Subject: Re: [PATCH bpf 0/2] tools: bpftool: fix pinning error messages
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        alexei.starovoitov@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190807001923.19483-1-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cc58a0b1-b0f2-29fb-8e1c-982f5d3126bf@iogearbox.net>
Date:   Fri, 9 Aug 2019 17:43:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190807001923.19483-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25536/Fri Aug  9 10:22:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 2:19 AM, Jakub Kicinski wrote:
> Hi!
> 
> First make sure we don't use "prog" in error messages because
> the pinning operation could be performed on a map. Second add
> back missing error message if pin syscall failed.
> 
> Jakub Kicinski (2):
>    tools: bpftool: fix error message (prog -> object)
>    tools: bpftool: add error message on pin failure
> 
>   tools/bpf/bpftool/common.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 

Applied, thanks!
