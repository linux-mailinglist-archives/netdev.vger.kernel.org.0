Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74152166BA
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgGGGtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:49:21 -0400
Received: from verein.lst.de ([213.95.11.211]:57366 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgGGGtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 02:49:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5D38768AFE; Tue,  7 Jul 2020 08:49:16 +0200 (CEST)
Date:   Tue, 7 Jul 2020 08:49:16 +0200
From:   Christoph Hellwig <hch@lst.de>
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
Subject: Re: [PATCH v6 2/7] fs: Move __scm_install_fd() to __receive_fd()
Message-ID: <20200707064916.GA23649@lst.de>
References: <20200706201720.3482959-1-keescook@chromium.org> <20200706201720.3482959-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706201720.3482959-3-keescook@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 01:17:15PM -0700, Kees Cook wrote:
> In preparation for users of the "install a received file" logic outside
> of net/ (pidfd and seccomp), relocate and rename __scm_install_fd() from
> net/core/scm.c to __receive_fd() in fs/file.c, and provide a wrapper
> named receive_fd_user(), as future patches will change the interface
> to __receive_fd().

Why the __ prefix if there is no receive_fd()?
