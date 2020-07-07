Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A27A216C49
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 13:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgGGLt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 07:49:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37981 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgGGLt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 07:49:27 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jsm6G-0004ZI-Uh; Tue, 07 Jul 2020 11:49:25 +0000
Date:   Tue, 7 Jul 2020 13:49:23 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 3/7] fs: Add receive_fd() wrapper for __receive_fd()
Message-ID: <20200707114923.6huxnb4e5vkl657a@wittgenstein>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200706201720.3482959-4-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 01:17:16PM -0700, Kees Cook wrote:
> For both pidfd and seccomp, the __user pointer is not used. Update
> __receive_fd() to make writing to ufd optional via a NULL check. However,
> for the receive_fd_user() wrapper, ufd is NULL checked so an -EFAULT
> can be returned to avoid changing the SCM_RIGHTS interface behavior. Add
> new wrapper receive_fd() for pidfd and seccomp that does not use the ufd
> argument. For the new helper, the allocated fd needs to be returned on
> success. Update the existing callers to handle it.
> 
> Reviewed-by: Sargun Dhillon <sargun@sargun.me>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Hm, I'm not sure why 2/7 and 3/7 aren't just one patch but ok. :)
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
