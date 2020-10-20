Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D7E293F3E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408513AbgJTPGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408510AbgJTPGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 11:06:41 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4205DC061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 08:06:41 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z5so3879169iob.1
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 08:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TRLniivicDPBrJmWtD5VYf1FKJumtqurgTFqAYL5pRM=;
        b=QekwbSLZj5vwDeeWNbhc2umShSFeSLnEgZiqvAmBjinqHH4cKMBpG+K22sqAunh4Jn
         784vxmj6rPcJzc+WyjxfJIUhQ4mCbjsxEETWdjqdzuLls+v+gf9311hHJyoL1clRc8qR
         6xN2g58bXoVp5olrPHKSr343Xpr2LOY2XHN2K71JVEkdAB/zqmjGaW7AVwfXhkfTLdtx
         NhBAwvHFtm81ZCp3kWiqplsEEUCB6+OKWIaFKUWqOGzLo4DDUeCkNUcf7Wo0Cs1dGL78
         nVdV8BmsxMo/WHsFs0sN1Ecq2/kWA1jgPS+455ThoEtd6uQ0aTanzKEQTdRb+NxGl6vb
         0Ksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TRLniivicDPBrJmWtD5VYf1FKJumtqurgTFqAYL5pRM=;
        b=pWoUqxbpJgK1P9iiT+SKrSmjq4ufqzaPAPnE4T8ZifH8ElVnjAfCeq2ZrfU/UmL8O8
         jL6qLEzdgkJhW3mhaaRClNJKXEx+JFx+HTf++Ew8IUPCel6CX+GeB++hy4R46PJ5vB7H
         g8p6e4BKysdAacyqc13mrPfd9B8FLpdu+XHXIDwQzo6W4jqN1SIFFnLqna2StuWIqKQw
         olRZTz6pRIJj1cxsA5uAmgJKV/MJUkWi9CYtB5vqETqM0uJiQTcLV63Yh4v5XYynThxm
         j/qLYIKqphmgYvWTTFIyEkxOi1PY7h8ZA5FMkk1q+eXKkqTjIyJ83X4IpfL2KompNYD4
         cN1g==
X-Gm-Message-State: AOAM532cZa1rOuIYcpYQaOuijHPeSvbH+saeP2yYas1kkIX83yHEcS3D
        RKWwRiYsid+LHKcMM2eNhOI=
X-Google-Smtp-Source: ABdhPJxod+PxVrSaCiVitZe9GGgiFHhjqmV8thrE+U1dAKxbdMUzfCk4zHY0/tjExqNjVP9qVV0YNQ==
X-Received: by 2002:a05:6602:2d85:: with SMTP id k5mr2523144iow.165.1603206400722;
        Tue, 20 Oct 2020 08:06:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2cd9:64d4:cacf:1e54])
        by smtp.googlemail.com with ESMTPSA id z21sm1702069ioq.35.2020.10.20.08.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 08:06:40 -0700 (PDT)
Subject: Re: [iproute2-next 0/2] tipc: add new options for TIPC encryption
To:     Tuong Lien <tuong.t.lien@dektech.com.au>, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
References: <20201016160201.7290-1-tuong.t.lien@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <942f4e8e-baf5-b8c4-bd5d-88872dfe7762@gmail.com>
Date:   Tue, 20 Oct 2020 09:06:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201016160201.7290-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/20 10:01 AM, Tuong Lien wrote:
> This series adds two new options in the 'iproute2/tipc' command, enabling users
> to use the new TIPC encryption features, i.e. the master key and rekeying which
> have been recently merged in kernel.
> 
> The help menu of the "tipc node set key" command is also updated accordingly:
> 
> # tipc node set key --help
> Usage: tipc node set key KEY [algname ALGNAME] [PROPERTIES]
>        tipc node set key rekeying REKEYING
> 
> KEY
>   Symmetric KEY & SALT as a composite ASCII or hex string (0x...) in form:
>   [KEY: 16, 24 or 32 octets][SALT: 4 octets]
> 
> ALGNAME
>   Cipher algorithm [default: "gcm(aes)"]
> 
> PROPERTIES
>   master                - Set KEY as a cluster master key
>   <empty>               - Set KEY as a cluster key
>   nodeid NODEID         - Set KEY as a per-node key for own or peer
> 
> REKEYING
>   INTERVAL              - Set rekeying interval (in minutes) [0: disable]
>   now                   - Trigger one (first) rekeying immediately
> 
> EXAMPLES
>   tipc node set key this_is_a_master_key master
>   tipc node set key 0x746869735F69735F615F6B657931365F73616C74
>   tipc node set key this_is_a_key16_salt algname "gcm(aes)" nodeid 1001002
>   tipc node set key rekeying 600
> 
> Tuong Lien (2):
>   tipc: add option to set master key for encryption
>   tipc: add option to set rekeying for encryption
> 
>  tipc/cmdl.c |  2 +-
>  tipc/cmdl.h |  1 +
>  tipc/node.c | 81 +++++++++++++++++++++++++++++++++++++++--------------
>  3 files changed, 62 insertions(+), 22 deletions(-)
> 

applied to iproute2-next
