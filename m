Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7B634943
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfFDNpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:45:41 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36266 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfFDNpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:45:41 -0400
Received: by mail-pl1-f195.google.com with SMTP id d21so8378584plr.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FXYFlU4Gtt1sNdAjVggynhOg2dbU2oGefZAnt6fsu2U=;
        b=Tbi2u/FdtK2E7K6ejc7yZJ6aQwkZSm4xxiryFDGQGrEwZfBVxEHdBm4bD0GbunlEQV
         C9WyPnVDv44be2dPO6UFVC3wBkhhViqTF+aNOPKGAPTDYDZ83OOoJAq/cDlT3NF1UEoy
         cSRAoePj1itruwChupXGNcG9QHk5zdVTEFV2UmmdCzIhvGIDAQkTBb6Mx6SvaMaqRFv0
         QuFaUMxvrFoAi5JszAmfSds89ycyvC60JeynIyoEFq5RsPYkI1JFzbNmRBKoXAqsX6Lf
         3AU9OjOGcMFXK2JbEQ0yuML5ABluZ8KFSgjQvizUQpQF74sL56XGTz5sVcz1C2XyJpj+
         kvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FXYFlU4Gtt1sNdAjVggynhOg2dbU2oGefZAnt6fsu2U=;
        b=uItHpkqjmRkGo2lg0CisibMwwqzQMOd8f6KE9ffIhNonWQEosVWONd4q2/+WT12f5M
         /n6z16jVzZXYbezSDUuAzRcoA91CFQ51aBrl0+VyFZXkHA1Hk2mxmfcHpsMd5Q95/11Z
         OFjeQig9yK5SNwaAgzAEgYUPJYOJu2MGbz/3VR2hCOA1cpi/QJqyUtE/Zb8UmuP+mfvJ
         aEE8gSHRfrCFXi3jj2IP5g4K5fpZFyon7mPwIrDoGLMri3pH4A8uuZlWwSPsYiFy9Cb6
         KNYHkVBW21B92Ky+6lNUpR0XIZvOv12FnEumw/ZyJXyER2IdQI0qSblAMOKMVw/SrF6G
         rgzw==
X-Gm-Message-State: APjAAAUcGW5eHPTXE7E1vNwgHT/DoRjAAeUXOKYuE4ijxzbe8UUpwKJ5
        JvUTXu+VtsTqsaImkhu6UMX0Gg==
X-Google-Smtp-Source: APXvYqz3ZTxtw1bpsSszcQ7p1WSYVxLQleNdZtVgGMEWXWNgB0CDoMCghRH63hN6aZmoPosAFXZiuQ==
X-Received: by 2002:a17:902:2869:: with SMTP id e96mr35514488plb.203.1559655940367;
        Tue, 04 Jun 2019 06:45:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id g8sm2377205pfi.8.2019.06.04.06.45.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:45:39 -0700 (PDT)
Date:   Tue, 4 Jun 2019 06:45:38 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Message-ID: <20190604134538.GB2014@mini-arch>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
 <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604042902.GA2014@mini-arch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03, Stanislav Fomichev wrote:
> > BTF is mandatory for _any_ new feature.
> If something is easy to support without asking everyone to upgrade to
> a bleeding edge llvm, why not do it?
> So much for backwards compatibility and flexibility.
> 
> > It's for introspection and debuggability in the first place.
> > Good debugging is not optional.
> Once llvm 8+ is everywhere, sure, but we are not there yet (I'm talking
> about upstream LTS distros like ubuntu/redhat).
But putting this aside, one thing that I didn't see addressed in the
cover letter is: what is the main motivation for the series?
Is it to support iproute2 map definitions (so cilium can switch to libbpf)?
If that's the case, maybe explicitly focus on that? Once we have
proof-of-concept working for iproute2 mode, we can extend it to everything.
