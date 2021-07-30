Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428B73DBE7C
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhG3SpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhG3SpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:45:18 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A60EC06175F;
        Fri, 30 Jul 2021 11:45:12 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id a93so17582027ybi.1;
        Fri, 30 Jul 2021 11:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxkioZJ7t9U+9k5UMGuqOEybi4EZeIMzM90svPmEOsw=;
        b=WgjVOuG4YKvevfyOCTlJpOBQCCtx3G3zyszZiGu4NNzaSZOCR8W3zL9qa5jBgU+e48
         gwlv/LKAmsv72FkuUMfnzINa6xDTlxuC3wwbtpS3jrEAKiMc805N2ZUkXV8NX1feeCCx
         wVGA/Y3TMG1O1VV88baCTg1SX1YmbflC++OdfkBQOPWsDG4daInXtBtmuAneOGsubNBN
         nzzeV/WpIMJmCF2YqaMx8xJuRmVR4/fxO5pUa7d5H5d3+2LxF6gX5zkgPtgNQ4iAgWBy
         jisqb5LeE/qhTvL/Ry4EEuQvw7INCUmFhWYdbo2iCTpmyTcsCUH2F1djO94n8E86KeAb
         aHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxkioZJ7t9U+9k5UMGuqOEybi4EZeIMzM90svPmEOsw=;
        b=TkVMnPxH5qlwx1PJk7u4aXm4LNCNld2Ld50ziWqlzXHyOdw56GlCxPcmvZf2cPjRMb
         +N6cUz1Dll7nceB9ochbQ7LkT8UX3aPGx1dZu62EZs+Gy9N+8sSoHdAPHlkufKBpYYHR
         2ogEfFX41GEmDavhqsx9QFqVPo2C+Cv7UIZ/uhiEcQcD32mMR3ek7WPLBlCdbMTMXVjF
         axLnoVnsdJyrYVhFDhVMzUNrf9J9Z1jCM23bkE8rXWya3qMHGkwrxvdZ+qmqA1k8wtEZ
         VW6omERNeUxJJhUfSVOcqkJoqyuhfd8TzSAbBlxd69LsIKo6bY3MkltaowXkrMDW47LB
         O4HQ==
X-Gm-Message-State: AOAM530TTgOc9ttHi/oasUH46yWcBra7V/yL2xc6mF3jg+nOkGX3UVJP
        zqnhCTpaLj2SHJ9l+AYEwA12lOUrUFJAQtGEKko=
X-Google-Smtp-Source: ABdhPJw9c/r/qBB3r15mcDNWDwiiMGx1dOkTaNSAmxKdEHoOTumK6LqvM2dMUD5NiFm7JNddLsC3aZWXR/f6ulMCElY=
X-Received: by 2002:a5b:648:: with SMTP id o8mr5144151ybq.260.1627670711499;
 Fri, 30 Jul 2021 11:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com> <20210729162932.30365-2-quentin@isovalent.com>
In-Reply-To: <20210729162932.30365-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 11:45:00 -0700
Message-ID: <CAEf4BzadrpVDm6yAriDSXK2WOzbzeZJoGKxbRzH+KA4YUD7SEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] tools: bpftool: slightly ease bash
 completion updates
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bash completion for bpftool gets two minor improvements in this patch.
>
> Move the detection of attach types for "bpftool cgroup attach" outside
> of the "case/esac" bloc, where we cannot reuse our variable holding the
> list of supported attach types as a pattern list. After the change, we
> have only one list of cgroup attach types to update when new types are
> added, instead of the former two lists.
>
> Also rename the variables holding lists of names for program types, map
> types, and attach types, to make them more unique. This can make it
> slightly easier to point people to the relevant variables to update, but
> the main objective here is to help run a script to check that bash
> completion is up-to-date with bpftool's source code.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/bash-completion/bpftool | 57 +++++++++++++----------
>  1 file changed, 32 insertions(+), 25 deletions(-)
>
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index cc33c5824a2f..b2e33a2d8524 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -404,8 +404,10 @@ _bpftool()
>                              return 0
>                              ;;
>                          5)
> -                            COMPREPLY=( $( compgen -W 'msg_verdict stream_verdict \
> -                                stream_parser flow_dissector' -- "$cur" ) )
> +                            local BPFTOOL_PROG_ATTACH_TYPES='msg_verdict \
> +                                stream_verdict stream_parser flow_dissector'
> +                            COMPREPLY=( $( compgen -W \
> +                                "$BPFTOOL_PROG_ATTACH_TYPES" -- "$cur" ) )
>                              return 0
>                              ;;
>                          6)
> @@ -464,7 +466,7 @@ _bpftool()
>
>                      case $prev in
>                          type)
> -                            COMPREPLY=( $( compgen -W "socket kprobe \
> +                            local BPFTOOL_PROG_LOAD_TYPES='socket kprobe \
>                                  kretprobe classifier flow_dissector \
>                                  action tracepoint raw_tracepoint \
>                                  xdp perf_event cgroup/skb cgroup/sock \
> @@ -479,8 +481,9 @@ _bpftool()
>                                  cgroup/post_bind4 cgroup/post_bind6 \
>                                  cgroup/sysctl cgroup/getsockopt \
>                                  cgroup/setsockopt cgroup/sock_release struct_ops \
> -                                fentry fexit freplace sk_lookup" -- \
> -                                                   "$cur" ) )
> +                                fentry fexit freplace sk_lookup'
> +                            COMPREPLY=( $( compgen -W \
> +                                "$BPFTOOL_PROG_LOAD_TYPES" -- "$cur" ) )

nit: this and similar COMPREPLY assignments now can be on a single line now, no?

>                              return 0
>                              ;;
>                          id)
> @@ -698,15 +701,16 @@ _bpftool()
>                              return 0
>                              ;;
>                          type)
> -                            COMPREPLY=( $( compgen -W 'hash array prog_array \
> -                                perf_event_array percpu_hash percpu_array \
> -                                stack_trace cgroup_array lru_hash \
> +                            local BPFTOOL_MAP_CREATE_TYPES='hash array \
> +                                prog_array perf_event_array percpu_hash \
> +                                percpu_array stack_trace cgroup_array lru_hash \
>                                  lru_percpu_hash lpm_trie array_of_maps \
>                                  hash_of_maps devmap devmap_hash sockmap cpumap \
>                                  xskmap sockhash cgroup_storage reuseport_sockarray \
>                                  percpu_cgroup_storage queue stack sk_storage \
> -                                struct_ops inode_storage task_storage' -- \
> -                                                   "$cur" ) )
> +                                struct_ops inode_storage task_storage'
> +                            COMPREPLY=( $( compgen -W \
> +                                "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
>                              return 0
>                              ;;
>                          key|value|flags|entries)
> @@ -1017,34 +1021,37 @@ _bpftool()
>                      return 0
>                      ;;
>                  attach|detach)
> -                    local ATTACH_TYPES='ingress egress sock_create sock_ops \
> -                        device bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
> +                    local BPFTOOL_CGROUP_ATTACH_TYPES='ingress egress \
> +                        sock_create sock_ops device \
> +                        bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
>                          getpeername4 getpeername6 getsockname4 getsockname6 \
>                          sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl getsockopt \
>                          setsockopt sock_release'
>                      local ATTACH_FLAGS='multi override'
>                      local PROG_TYPE='id pinned tag name'
> -                    case $prev in
> -                        $command)
> -                            _filedir
> -                            return 0
> -                            ;;
> -                        ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
> -                        post_bind4|post_bind6|connect4|connect6|getpeername4|\
> -                        getpeername6|getsockname4|getsockname6|sendmsg4|sendmsg6|\
> -                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt|sock_release)
> +                    # Check for $prev = $command first
> +                    if [ $prev = $command ]; then
> +                        _filedir
> +                        return 0
> +                    # Then check for attach type. This is done outside of the
> +                    # "case $prev in" to avoid writing the whole list of attach
> +                    # types again as pattern to match (where we cannot reuse
> +                    # our variable).
> +                    elif [[ $BPFTOOL_CGROUP_ATTACH_TYPES =~ $prev ]]; then
>                              COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
>                                  "$cur" ) )
>                              return 0
> -                            ;;
> +                    fi
> +                    # case/esac for the other cases
> +                    case $prev in
>                          id)
>                              _bpftool_get_prog_ids
>                              return 0
>                              ;;
>                          *)
> -                            if ! _bpftool_search_list "$ATTACH_TYPES"; then
> -                                COMPREPLY=( $( compgen -W "$ATTACH_TYPES" -- \
> -                                    "$cur" ) )
> +                            if ! _bpftool_search_list "$BPFTOOL_CGROUP_ATTACH_TYPES"; then
> +                                COMPREPLY=( $( compgen -W \
> +                                    "$BPFTOOL_CGROUP_ATTACH_TYPES" -- "$cur" ) )
>                              elif [[ "$command" == "attach" ]]; then
>                                  # We have an attach type on the command line,
>                                  # but it is not the previous word, or
> --
> 2.30.2
>
