Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19193276068
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgIWSr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:47:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbgIWSr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:47:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600886875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2WMp1T0DVJXN4WDrQu1JxkLpRzKFw+3Wie7j16J+0+g=;
        b=bE0MnqKWAcJ6MKS8PglqeQiKpIIjtzXUrbq5kui5PpBow6tt+mKzf7CYEoUMjbHmRJq7Z6
        /3SdFpFnSP8yzi96DaHxsx9pqaUsAQKbu9A9WeMeuKnRzLjwGLIE77tgjOKnnnYzttbcQv
        7BjYxcF+1BeCOZcZMc74HYUR7rfXhLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-VyZEbt_rMuqI3zgDwT8h8Q-1; Wed, 23 Sep 2020 14:47:53 -0400
X-MC-Unique: VyZEbt_rMuqI3zgDwT8h8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 310B3800493;
        Wed, 23 Sep 2020 18:47:51 +0000 (UTC)
Received: from krava (ovpn-112-117.ams2.redhat.com [10.36.112.117])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8ECB15DE86;
        Wed, 23 Sep 2020 18:47:47 +0000 (UTC)
Date:   Wed, 23 Sep 2020 20:47:46 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCHv2 bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF
 is not enabled
Message-ID: <20200923184746.GP2893484@krava>
References: <20200923140459.3029213-1-jolsa@kernel.org>
 <CAEf4BzZM8UOZ4x_uDtbzMbpmYGcLSo5h-7miPMAd+wDzMuG7Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZM8UOZ4x_uDtbzMbpmYGcLSo5h-7miPMAd+wDzMuG7Aw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 09:09:17AM -0700, Andrii Nakryiko wrote:
> On Wed, Sep 23, 2020 at 7:06 AM Jiri Olsa <jolsa@kernel.org> wrote:

damn I'm blind this week.. will send v3 with proper subject :-\

jirka

> >
> > Currently all the resolve_btfids 'users' are under CONFIG_BPF
> > code, so if we have CONFIG_BPF disabled, resolve_btfids will
> > fail, because there's no data to resolve.
> >
> > Disabling resolve_btfids if there's CONFIG_BPF disabled,
> > so we won't fail such builds.
> >
> > Suggested-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> > v2 changes:
> >   - disable resolve_btfids completely when CONFIG_BPF is not defined
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> [...]
> 

