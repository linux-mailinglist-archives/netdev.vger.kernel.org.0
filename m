Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223C971856
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbfGWMeo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 08:34:44 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35978 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbfGWMen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 08:34:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id k21so43748198edq.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 05:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RN3nMLeqnhSnshyvSgEdawE8SkB3c01YBC15mTfpzlM=;
        b=abNnik3WPLHLKp33R2Rry82JdHjuWpzZvK4I5HPZOVN07oZKOBNgVnCaUBvQk5WzyQ
         Egg3vJVNnvuYQHkf/IMgWmCZe5hJdi8Fd1ElSpdoibO4pg28asrNeRkCGhiQ0JrSgJgH
         cs/DnogH81hZhtMLR3FO5AQKvnrLqgR7M69P8mbo+pFV822xPmwHtUQ8KpZbfP7/5Vb3
         P+b34etkxzHtGQw8a/IUEVYVzh7at5af4ufUqwkyhpORAzhkeEkBDwn8v6aqQ6xquc79
         7h5IXcnZlZFfTH59vJvuFBJaL4th49BooWk3Gba/YH3WcfVSZmf6fnsYu1Dpm8FjrdKa
         Rvbg==
X-Gm-Message-State: APjAAAW2hO0C+pOBh/ctELjlt/If4eY6p3eoP6xDtfNZzOomdf+4tOJp
        Fv6xqAkBXMIUAYke3w0G3/JVkw==
X-Google-Smtp-Source: APXvYqwf9A3Sd1kSRtxnUOUjD0jkW5SWxVYeoppDuaXdWNEenPTbyKlWdOzSgVMmQzwdZa3xeEs/SQ==
X-Received: by 2002:a50:e619:: with SMTP id y25mr65519415edm.247.1563885282265;
        Tue, 23 Jul 2019 05:34:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g22sm8828272ejr.87.2019.07.23.05.34.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:34:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C2D84181CE7; Tue, 23 Jul 2019 14:34:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 3/5] samples/bpf: convert xdp_sample_pkts_user to perf_buffer API
In-Reply-To: <20190723043112.3145810-4-andriin@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com> <20190723043112.3145810-4-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 23 Jul 2019 14:34:40 +0200
Message-ID: <87zhl52alb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Convert xdp_sample_pkts_user to libbpf's perf_buffer API.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
