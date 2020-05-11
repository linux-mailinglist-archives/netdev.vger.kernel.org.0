Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7411CDEE0
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgEKPZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:25:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:55612 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgEKPZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:25:47 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYAJN-0004M0-3d; Mon, 11 May 2020 17:25:45 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYAJM-0005Nd-ST; Mon, 11 May 2020 17:25:44 +0200
Subject: Re: [PATCH bpf-next 2/4] tools: bpftool: minor fixes for
 documentation
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200511133807.26495-1-quentin@isovalent.com>
 <20200511133807.26495-3-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <673bcb25-1949-f0d8-c690-4f0a75819a80@iogearbox.net>
Date:   Mon, 11 May 2020 17:25:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200511133807.26495-3-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25809/Mon May 11 14:16:55 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/20 3:38 PM, Quentin Monnet wrote:
> Bring minor improvements to bpftool documentation. Fix or harmonise
> formatting, update map types (including in interactive help), improve
> description for "map create", fix a build warning due to a missing line
> after the double-colon for the "bpftool prog profile" example,
> complete/harmonise/sort the list of related bpftool man pages in
> footers.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
[...]
> @@ -116,24 +123,24 @@ DESCRIPTION
>   		  receiving events if it installed its rings earlier.
>   
>   	**bpftool map peek**  *MAP*
> -		  Peek next **value** in the queue or stack.
> +		  Peek next value in the queue or stack.

Looks great overall. Was about to push, but noticed above inconsistency. Should this
be `*VALUE*` as well?

>   	**bpftool map push**  *MAP* **value** *VALUE*
> -		  Push **value** onto the stack.
> +		  Push *VALUE* onto the stack.
>   
>   	**bpftool map pop**  *MAP*
> -		  Pop and print **value** from the stack.
> +		  Pop and print *VALUE* from the stack.
>   
>   	**bpftool map enqueue**  *MAP* **value** *VALUE*
> -		  Enqueue **value** into the queue.
> +		  Enqueue *VALUE* into the queue.
>   
>   	**bpftool map dequeue**  *MAP*
> -		  Dequeue and print **value** from the queue.
> +		  Dequeue and print *VALUE* from the queue.
>   
>   	**bpftool map freeze**  *MAP*
>   		  Freeze the map as read-only from user space. Entries from a
>   		  frozen map can not longer be updated or deleted with the
> -		  **bpf\ ()** system call. This operation is not reversible,
> +		  **bpf**\ () system call. This operation is not reversible,
>   		  and the map remains immutable from user space until its
>   		  destruction. However, read and write permissions for BPF
>   		  programs to the map remain unchanged.
