Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474DC21B3F2
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgGJL3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 07:29:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44692 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgGJL24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 07:28:56 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jtrD1-0005TR-0A; Fri, 10 Jul 2020 11:28:51 +0000
Date:   Fri, 10 Jul 2020 13:28:48 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sargun Dhillon <sargun@sargun.me>,
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
Subject: Re: [PATCH v7 1/9] net/compat: Add missing sock updates for
 SCM_RIGHTS
Message-ID: <20200710112848.ict5lbpyq35jj4qm@wittgenstein>
References: <20200709182642.1773477-1-keescook@chromium.org>
 <20200709182642.1773477-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200709182642.1773477-2-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:26:34AM -0700, Kees Cook wrote:
> Add missed sock updates to compat path via a new helper, which will be
> used more in coming patches. (The net/core/scm.c code is left as-is here
> to assist with -stable backports for the compat path.)
> 
> Cc: stable@vger.kernel.org
> Fixes: 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> Fixes: d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Thanks!
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
