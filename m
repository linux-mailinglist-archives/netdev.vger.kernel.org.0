Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DBD197EFE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgC3OuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:50:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38057 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgC3OuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 10:50:00 -0400
Received: by mail-io1-f68.google.com with SMTP id m15so18061610iob.5;
        Mon, 30 Mar 2020 07:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BcQ9fbONtYvk5hoch2Fj0jEG/2zXqzDbwyIIOVzN06c=;
        b=GzPyiRIn6tTxSfc53jEz3pQP8UqGVhDSyzvJh5wS21Qdr0KNzP/ovVSJD6Jq7ovd0o
         CFF1sFDjoJSL7K2oV1TOH186P3VUiCws7uswVFZwXufe/yW/UIlH5dLeFMyegC7pTX1b
         Y9gubqr/sxZbj5PChwji/f84QAZYBT1UGSXr1p5XxC9gg5jXMev7CnvNTl9ozjq/x2KB
         8/6NOflO0dCGGU7prbnxVlQ7kJpKc8SEp/SPZM+bUCGDn3KOzofweJT84frpqopdp+Xl
         R6BFAfxXVkwvZ+CZLJ7bQdDo32WJMJdFg69d2Uwq7Z5OmRbIKghTezvAHYM8NIge4dx8
         BLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BcQ9fbONtYvk5hoch2Fj0jEG/2zXqzDbwyIIOVzN06c=;
        b=D9v36NSdqWx8i1jIX83LxM0/FtkJJdOfJ5QRyKmPPMl/nsE+KMJ64q5SzUl/G2jNqD
         1QdWKDp7GDW4GaAOcRzK7003wrWFewDYAxQwiXfJ4ZPRDHBsRq1yvkKIQlo9uncfcPl6
         tYhQTyos4UzDEnhkIAHflUovUq94riWWBK5Yt/bjFvRnkEvkhWFyRXDkfurPKTRZYv4w
         ZbWGBSzNBmg5aFCUXQmg5zihwHxK/zRSWwLocKTSritr+hXmqLHpXht6EqvvusrCKXSa
         ER7PDc4bsZam9gx9cHwLTZ+n157G3iVWAgkbf/pvLUfYpqL3GwmufIJDlqsOseDBypUJ
         8ztA==
X-Gm-Message-State: ANhLgQ1wfcpx3RH0BKyxVNzhdYiLO6pXKkOUav2LwCEMxg/MBTR/sRWT
        f7YwK0LKR1wG7jW2F9r8kdTyh8uS
X-Google-Smtp-Source: ADFU+vsN/xqONjwabyJEuD5eFT4l8bUAZMOgu9lFmm6FSBG4XoIgoZsO3O/isVngIRZa4M64N/xnpg==
X-Received: by 2002:a6b:d808:: with SMTP id y8mr10792291iob.121.1585579799554;
        Mon, 30 Mar 2020 07:49:59 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:6833:d88e:92a1:cac9? ([2601:282:803:7700:6833:d88e:92a1:cac9])
        by smtp.googlemail.com with ESMTPSA id v80sm4923669ila.62.2020.03.30.07.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 07:49:58 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        rdna@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200330030001.2312810-1-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
Date:   Mon, 30 Mar 2020 08:49:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330030001.2312810-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/20 8:59 PM, Andrii Nakryiko wrote:
> bpf_link abstraction itself was formalized in [0] with justifications for why
> its semantics is a good fit for attaching BPF programs of various types. This
> patch set adds bpf_link-based BPF program attachment mechanism for cgroup BPF
> programs.
> 
> Cgroup BPF link is semantically compatible with current BPF_F_ALLOW_MULTI
> semantics of attaching cgroup BPF programs directly. Thus cgroup bpf_link can
> co-exist with legacy BPF program multi-attachment.
> 
> bpf_link is destroyed and automatically detached when the last open FD holding
> the reference to bpf_link is closed. This means that by default, when the
> process that created bpf_link exits, attached BPF program will be
> automatically detached due to bpf_link's clean up code. Cgroup bpf_link, like
> any other bpf_link, can be pinned in BPF FS and by those means survive the
> exit of process that created the link. This is useful in many scenarios to
> provide long-living BPF program attachments. Pinning also means that there
> could be many owners of bpf_link through independent FDs.
> 
> Additionally, auto-detachmet of cgroup bpf_link is implemented. When cgroup is
> dying it will automatically detach all active bpf_links. This ensures that
> cgroup clean up is not delayed due to active bpf_link even despite no chance
> for any BPF program to be run for a given cgroup. In that sense it's similar
> to existing behavior of dropping refcnt of attached bpf_prog. But in the case
> of bpf_link, bpf_link is not destroyed and is still available to user as long
> as at least one active FD is still open (or if it's pinned in BPF FS).
> 
> There are two main cgroup-specific differences between bpf_link-based and
> direct bpf_prog-based attachment.
> 
> First, as opposed to direct bpf_prog attachment, cgroup itself doesn't "own"
> bpf_link, which makes it possible to auto-clean up attached bpf_link when user
> process abruptly exits without explicitly detaching BPF program. This makes
> for a safe default behavior proven in BPF tracing program types. But bpf_link
> doesn't bump cgroup->bpf.refcnt as well and because of that doesn't prevent
> cgroup from cleaning up its BPF state.
> 
> Second, only owners of bpf_link (those who created bpf_link in the first place
> or obtained a new FD by opening bpf_link from BPF FS) can detach and/or update
> it. This makes sure that no other process can accidentally remove/replace BPF
> program.
> 
> This patch set also implements LINK_UPDATE sub-command, which allows to
> replace bpf_link's underlying bpf_prog, similarly to BPF_F_REPLACE flag
> behavior for direct bpf_prog cgroup attachment. Similarly to LINK_CREATE, it
> is supposed to be generic command for different types of bpf_links.
> 

The observability piece should go in the same release as the feature.
