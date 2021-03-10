Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C57333621
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 08:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhCJHKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 02:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhCJHKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 02:10:00 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B3DC06174A;
        Tue,  9 Mar 2021 23:10:00 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u18so7998200plc.12;
        Tue, 09 Mar 2021 23:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ERttXFOKAolL/dPLIXf43Bj2Hlxeg+cuDD7+vsvIM68=;
        b=JLQQfsXD04FNo9SSEmsx1JO5dzwzhX0+9pIGoP7CmyG7wI+qpYH1352kOTyor1P0XN
         JLkbQfCz/7Fn6zLmM3VTKKlnbrnv4QScnsWmM1pWZtjgxnqsG5l2X+lL8nmmGORmj75z
         MI/MNMnPyXaYg+aJMS+olMUxGvl7irpgCDNBVHteDooRo5uKdsZPxeOjMJqwm9LmvklA
         aeBfdgbfNk1gk1yEZl8jr9UzMm8paOdI9RpwS2f2+NFR1SI7szwQ9rlvEwjvpJJKlqqm
         R6rjoicZiYJF7Rw1qDOt9iXe2z6sSkrrN3pJQEHh/3shj3BwdxPbgJLCWuS3jkQDOnaS
         fZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ERttXFOKAolL/dPLIXf43Bj2Hlxeg+cuDD7+vsvIM68=;
        b=qR7IyrYANhmpxjA9VYebXy0HNDDsHspqNLbDG+D/KpREhUMn5jVmAHk2blWEyG53Ya
         Y8+sSWU2hZjK9x/r4DTJtIr9tFsVGNWSrlMZTu5CYaUq3/XMZnCYN5I7cOQKjDDXRDMA
         Bck7e9J2xQ1BYra/jpmv/8xq60TfZ93hCdzxowWVtTb/N5KcXJMwMmrCtaGJPyt22sxO
         O3Wax8cD3ZxOZiFt3gcBrmS58LieStD94cD510TkjQaHRltgdn/bvPnWX/e7mjZWIO3n
         cvcO3lr7v/JvwgBlN6+TnakAq2j0Nwr2SohmBSLYYIjKzKUp1Uyr4vWpMirfM2DpCzBS
         NwgQ==
X-Gm-Message-State: AOAM531ehB/I9VpRBOg/vjE3CQ9vJXXATuszfqduJsrFp76jVNHbQ2Fq
        4kcOfFmhwvNmkQP0yQW3SZ0=
X-Google-Smtp-Source: ABdhPJyGyZqnvJc5j15JxBGozTVm1V3WS8aIUO0bl7tFkZuTrjR8UPF28q6TYAF0vjQqwrdmJGzrKg==
X-Received: by 2002:a17:902:6845:b029:e4:4d0f:c207 with SMTP id f5-20020a1709026845b02900e44d0fc207mr1610088pln.36.1615360200106;
        Tue, 09 Mar 2021 23:10:00 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v23sm880523pfn.71.2021.03.09.23.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 23:09:59 -0800 (PST)
Date:   Wed, 10 Mar 2021 15:09:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, daniel@iogearbox.net,
        yihung.wei@gmail.com, davem@davemloft.net, bpf@vger.kernel.org,
        u9012063@gmail.com
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel
 opt failed
Message-ID: <20210310070949.GY2900@Leo-laptop-t470s>
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
 <161534026864.31790.14467574294253275820.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161534026864.31790.14467574294253275820.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:37:48AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Tue,  9 Mar 2021 11:22:14 +0800 you wrote:
> > When fixing the bpf test_tunnel.sh genve failure. I only fixed
> > the IPv4 part but forgot the IPv6 issue. Similar with the IPv4
> > fixes 557c223b643a ("selftests/bpf: No need to drop the packet when
> > there is no geneve opt"), when there is no tunnel option and
> > bpf_skb_get_tunnel_opt() returns error, there is no need to drop the
> > packets and break all geneve rx traffic. Just set opt_class to 0 and
> > keep returning TC_ACT_OK at the end.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net] selftests/bpf: set gopt opt_class to 0 if get tunnel opt failed
>     https://git.kernel.org/netdev/net-next/c/557c223b643a

Hi bot,

I think you are mixing this patch with commit

557c223b643a ("selftests/bpf: No need to drop the packet when there is no geneve opt")

Thanks
Hangbin
