Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3F0452E10
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhKPJgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233059AbhKPJgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 04:36:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A239C63222;
        Tue, 16 Nov 2021 09:33:09 +0000 (UTC)
Date:   Tue, 16 Nov 2021 10:33:06 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/seccomp: fix check of fds being assigned
Message-ID: <20211116093306.wlrtk4p5rbvnrxm7@wittgenstein>
References: <20211115165227.101124-1-andrea.righi@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211115165227.101124-1-andrea.righi@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 05:52:27PM +0100, Andrea Righi wrote:
> There might be an arbitrary free open fd slot when we run the addfd
> sub-test, so checking for progressive numbers of file descriptors
> starting from memfd is not always a reliable check and we could get the
> following failure:
> 
>   #  RUN           global.user_notification_addfd ...
>   # seccomp_bpf.c:3989:user_notification_addfd:Expected listener (18) == nextfd++ (9)
>   # user_notification_addfd: Test terminated by assertion
> 
> Simply check if memfd and listener are valid file descriptors and start
> counting for progressive file checking with the listener fd.
> 
> Fixes: 93e720d710df ("selftests/seccomp: More closely track fds being assigned")
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---

Thanks!
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
