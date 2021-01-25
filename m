Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2AC3027A2
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbhAYQS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:18:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730610AbhAYQSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611591401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c08+oV2gi7G/xLUQh2HQkXweRbcrmh4JkDtR8hT31AE=;
        b=hjbd9ydWxffydVCN9rIG/jYRuqRTifjRwlwW4fSNxxaGoKqAaf9wjMG/rZNHJid4sHXYXM
        INAGiVswWSyGsL7CKK+AevzZoEU1UPUuz/6+FrRbJgkDfYZ4ZZwSArC+jCD26bx9PAN+DS
        IUDQU4TWoZmeDaRuBRlzLqbvnmWn/AI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-9YwePZdaO5avh1gstvV8Gw-1; Mon, 25 Jan 2021 11:16:37 -0500
X-MC-Unique: 9YwePZdaO5avh1gstvV8Gw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37EB9804002;
        Mon, 25 Jan 2021 16:16:35 +0000 (UTC)
Received: from [10.10.112.133] (ovpn-112-133.rdu2.redhat.com [10.10.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 268B960C9C;
        Mon, 25 Jan 2021 16:16:30 +0000 (UTC)
Subject: Re: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Mark Wielaard <mjw@redhat.com>
References: <20210122163920.59177-1-jolsa@kernel.org>
 <20210122163920.59177-3-jolsa@kernel.org>
 <20210122195228.GB617095@kernel.org>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <d0bd23aa-2b44-2caa-703b-13e9f32ff9c0@redhat.com>
Date:   Mon, 25 Jan 2021 11:16:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210122195228.GB617095@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 2:52 PM, Arnaldo Carvalho de Melo wrote:
> 
> Who originally reported this? Joe? Also can someone provide a Tested-by:
> in addition to mine when I get this detailed set of steps to test?
> 

As Jiri noted, we tested v2 I think, so if there is a v4 build we could 
give a spin, just let us know.

In the meantime, for kpatch, we figured that we could just temporarily 
disable CONFIG_DEBUG_INFO_BTF in the scripts/link-vmlinux.sh file during 
kpatch builds ... that would leave kernel code intact, but skip the BTF 
generation step (for which kpatch doesn't need anyway).

Thanks,

-- Joe

