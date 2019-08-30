Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4287CA3C10
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 18:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfH3QdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 12:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19665 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbfH3QdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 12:33:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 485CC3001839;
        Fri, 30 Aug 2019 16:33:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D562160BF7;
        Fri, 30 Aug 2019 16:32:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190820001805.241928-24-matthewgarrett@google.com>
References: <20190820001805.241928-24-matthewgarrett@google.com> <20190820001805.241928-1-matthewgarrett@google.com>
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     dhowells@redhat.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH V40 23/29] bpf: Restrict bpf when kernel lockdown is in confidentiality mode
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3801.1567182778.1@warthog.procyon.org.uk>
Date:   Fri, 30 Aug 2019 17:32:58 +0100
Message-ID: <3802.1567182778@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 30 Aug 2019 16:33:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew Garrett <matthewgarrett@google.com> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> bpf_read() and bpf_read_str() could potentially be abused to (eg) allow
> private keys in kernel memory to be leaked. Disable them if the kernel
> has been locked down in confidentiality mode.
> 
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> cc: netdev@vger.kernel.org
> cc: Chun-Yi Lee <jlee@suse.com>
> cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: James Morris <jmorris@namei.org>

Signed-off-by: David Howells <dhowells@redhat.com>
