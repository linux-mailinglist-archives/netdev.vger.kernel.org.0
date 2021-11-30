Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302814636E0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbhK3Olw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhK3Olv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7A7C061574;
        Tue, 30 Nov 2021 06:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD9F2B81A10;
        Tue, 30 Nov 2021 14:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C144C53FC7;
        Tue, 30 Nov 2021 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283109;
        bh=misPsdso/ucl7FldjYFPOJZ2946tkLT3Cuk4N7R+27c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RwHUa9sjp3r1GGWLhIGcVHM4qBqhPpfgHZYvmPi0pYYK5Yn5fM2tdYlVwKc7Uz/5S
         IvaxHw9aI+edHV8dMDdvD40cuswPNQvAI5sYWmnmJYI4A1mAKo+Cr5RQ1OPGohvB7Q
         W05dT/8MynKn14bpFMJruY+aQV57ZlSnKw3AEpU1zQzz7xox70AeGb4bJKiPOdgNBD
         RExeNzwzguFRWbjBsQSXsE/hOn2v4a+mf2cMgdber2K+d9+ooGkEi0SiOlKvFAQ3Bd
         b4NRNGgddUdqraD4nWq/kQ2DZsDlEYQRWF55SwZkCoIyKgSvu2Hmey0lovgicIVbIR
         HM60xco+1WZJA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1385140002; Tue, 30 Nov 2021 11:38:27 -0300 (-03)
Date:   Tue, 30 Nov 2021 11:38:27 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] Documentation: Add minimum pahole version
Message-ID: <YaY3Yypl80gZ5TFl@kernel.org>
References: <YZfzQ0DvHD5o26Bt@kernel.org>
 <87k0gqsked.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0gqsked.fsf@meer.lwn.net>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Nov 29, 2021 at 02:48:42PM -0700, Jonathan Corbet escreveu:
> Arnaldo Carvalho de Melo <acme@kernel.org> writes:
> 
> > A report was made in https://github.com/acmel/dwarves/issues/26 about
> > pahole not being listed in the process/changes.rst file as being needed
> > for building the kernel, address that.
> >
> > Link: https://github.com/acmel/dwarves/issues/26
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: bpf@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Link: http://lore.kernel.org/lkml/YZPQ6+u2wTHRfR+W@kernel.org
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  Documentation/process/changes.rst | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> 
> Applied (with the duplicate SOB removed), thanks.

Oops, one should be enough indeed :-)

Thanks!

- Arnaldo
