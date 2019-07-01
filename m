Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF7F5C5FA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGAXqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:46:43 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38468 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGAXqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:46:42 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so14991295ljg.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRqDKrW3IPavUWp1F9Nqj698h13KeKAId+GIMKLYSdY=;
        b=FJQreLHAlWPp1grBA6lKU8XTQ2pihXY0G90YVw1q+EUg63+ET8xHn74vw4qLIQJEKj
         TySXsT0QRjj7tsvwPN4d83lOYVZKAe3QzeaexJgxxivYXmuv+QjxEm8p2KBKcxJXy1AX
         EYmX57+gt7YhdKgr7upMJ3vgM+IwmjaCMOgXo6LLypui2xXt1Ssd7MADXGvwz6Sr8ohY
         tJhNhS62DvMfKVwSHhpiBq5pKJhC07T+o1g+ebda5QcL7qGe/wvOGWu/P11Ixh8TuJLR
         Ov4aeyXAW206/Qu2Y9T3PCrL2KydRQ3Jn2QiVsLXEFDYuHc9m3y3JL0OWcWdegWiMQ6Q
         CBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRqDKrW3IPavUWp1F9Nqj698h13KeKAId+GIMKLYSdY=;
        b=NEnDouPW6AWOB8euZZzbMLNFYhjnwz6xofPfIzxqbfuyEE2nuyAiSwjOa+XPNM2+58
         V8hPRqSj96p7+pv/yizC81eXSyoIewEmo+Gaztjo24MFenwWbWQGRppunXjNBjoWvdW/
         OiXoTyVcpV35IxN6R7uKrmzPw8yBv5Rzk+/D+ZIQYjAei7cIx4jQKK6FPmpPZZtswrf0
         0y4UGsw2KhKsceWjwCo/lmx+bniVGkKBpQwCcaazCE/5cycMWKXKKtQrArbSf+u7jbwn
         cFQaV0jSivBlDXffnTrw+jftmvikvPjBMe46mbg4eIqVT7yKWE+8s01Rf+r/DdTq/hZk
         9C7w==
X-Gm-Message-State: APjAAAVvarJXNlVu6lXgCQBbkDunjzZVOqhrbXqxNybiSBIbrP3WXVJB
        /HvZhaBXD7KHHKp1qwTvF4sq8jQRbA1lUTosw3hrx9bu
X-Google-Smtp-Source: APXvYqzFrIplv3BW0HA02fmm2tSKYl4pdMS2Y/sZwRN4bqZbW/iIteW1OVWe4r7jHlJnHl0Wuf3s3QzsuUl3RhQK7y4=
X-Received: by 2002:a05:651c:95:: with SMTP id 21mr15867633ljq.128.1562024800727;
 Mon, 01 Jul 2019 16:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Mon, 1 Jul 2019 16:46:29 -0700
Message-ID: <CALzJLG-LEPqr3kDTYRKq8V-URsdTS2F87mV_qO9HaCX6CY7VZQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next 00/18] Mellanox, mlx5 E-Switch and low level updates
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 3:35 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Hi All,
>
> This series includes some low level updates mainly in the E-Switch
> netdev and rdma vport representors areas.
>
> From Parav and Huy:
>  1) Added hardware bits and structures definitions for sub-functions
>  2) Small code cleanup and improvement for PF pci driver.
>
> From Bodong:
>  3) Use the correct name semantics of vport index and vport number
>  4) Cleanup the rep and netdev reference when unloading IB rep.
>  5) Bluefield (ECPF) updates and refactoring for better E-Switch
>     management on ECPF embedded CPU NIC:
>     5.1) Consolidate querying eswitch number of VFs
>     5.2) Register event handler at the correct E-Switch init stage
>     5.3) Setup PF's inline mode and vlan pop when the ECPF is the
>          E-Swtich manager ( the host PF is basically a VF ).
>     5.4) Handle Vport UC address changes in switchdev mode.
>
> From Shay:
>  6) Add support for MCQI and MCQS hardware registers.
>
> In case of no objections these patches will be applied to mlx5-next and
> will be sent later as pull request to both rdma-next and net-next trees.

Applied to mlx5-next,

Thanks!
