Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6E9473B80
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhLNDZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhLNDZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:25:42 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA9BC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:25:42 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 7so25703249oip.12
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ypmcXXp8spuGA40lF3D5fD+jU02RQTKj421NSyVWrLc=;
        b=j6Y3hnR5vyAivMg2BuaUGw+W7aFDYXNYT690rZqZqTV86CTLgGMLDrUNWnqbdEZ8ma
         +gbmjpZQQJWCOWimc3tGndPhaW7KsaJOszm9D5aY95KmZL5Mqd0oTAy9TH1QMTi5KbnQ
         exUB6RPyVvu1gg/1ZkOo5kbhrfJhFnxD5ThgQuOJ7YlvnJXSstzQBCLKv/X+mk3kyuGK
         7KBf/7GwNOBT2/O41NfxmQdgbMCq6Fsw5vYJABbkQNudm81Ou+Vdi88XdRHfK/DPyv5T
         TslMuETU4CLseDwGhLl3kQe8Pl3sDro+rV+NPTrQDtW4ZCFSFHMvAM+icogxaXDyWA3i
         cRyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ypmcXXp8spuGA40lF3D5fD+jU02RQTKj421NSyVWrLc=;
        b=x3iRaSOESSPok7slPAgS5hsbmUWPMUyGmWi1inA4u/l1DQLrkZG+zInRQaXEw7v52r
         QggZ2HL5Vk9MlNl9nG9BE1FZkTur3u0gCN8U/sUqEy3WE6j43GyhMgsoVX/S7olCcnu7
         YuHQ5/MFpOTMj2GojDYlCZZxcyoQAeDwPE5j5Ew6Q95ZDX1+o+6qYmkUHbxZwEIUS6cS
         KjBgWNnh+ewhfpYYdDzjYfptOyGehqYXIYfM1eM5idpKWS0GZFKSE/llUxj35vpbyfgZ
         PHAqKyKKVMiZ6og6/wwsTjh3uAHyDLkIMlGMflUDzHWFyTI3XVzlrpdru+UioHtXgUS6
         PZNg==
X-Gm-Message-State: AOAM531XW7sZsUGTifD0U1Y1+qDhBol8wPF2ijN/cpx9OEUeI6mc1R+s
        ndIsLTq4qUpCBFOhQXhZjmQ=
X-Google-Smtp-Source: ABdhPJxqPsQSoDm7R8hCzaUiCl9yiGsdbZ8eHUVuPjGUxUQs/7AUab9yrPd3vR9Kh7nM0XQ3o3AIDQ==
X-Received: by 2002:a05:6808:20a5:: with SMTP id s37mr30088721oiw.127.1639452341717;
        Mon, 13 Dec 2021 19:25:41 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o2sm3266881oik.11.2021.12.13.19.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 19:25:41 -0800 (PST)
Message-ID: <43124a32-b509-bbbc-ea3f-38aa4c656b86@gmail.com>
Date:   Mon, 13 Dec 2021 20:25:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH iproute2-next] mptcp: add support for changing the backup
 flag
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>
References: <cb2ddffb2211d6fdde7a8bf81879a3a83c620f00.1639039948.git.dcaratti@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <cb2ddffb2211d6fdde7a8bf81879a3a83c620f00.1639039948.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/21 2:10 AM, Davide Caratti wrote:
> Linux supports 'MPTCP_PM_CMD_SET_FLAGS' since v5.12, and this control has
> recently been extended to allow setting flags for a given endpoint id.
> Although there is no use for changing 'signal' or 'subflow' flags, it can
> be helpful to set/clear the backup bit on existing endpoints: add the 'ip
> mptcp endpoint change <...>' command for this purpose.
> 
> Link: https://github.com/multipath-tcp/mptcp_net-next/issues/158
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  ip/ipmptcp.c        | 20 ++++++++++++++++----
>  man/man8/ip-mptcp.8 | 14 ++++++++++++++
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 

does not apply to iproute2-next; please rebase.

