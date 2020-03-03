Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313CF1769B8
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCCA75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:59:57 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34926 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCCA75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:59:57 -0500
Received: by mail-pg1-f194.google.com with SMTP id 7so686314pgr.2;
        Mon, 02 Mar 2020 16:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ja3eaZ6L0eZYhBLiMvzByj46go5Z0Lrg8ifCIq+nQrI=;
        b=NNhcu0LUIzJUWWTBfDe4wTjzFWvwAuqSsvcEZnXDBz1loX1CXYcq2fx4gCFo3axhhZ
         +aLbpL5F60Yoo9vALy04cdH2kpeksrx9EE6dUDndnRppcT/NnrstBOxM44Mn6hq/xrwB
         J7BR6x4CaZrthzg+bYOQqfbrLV8v64Xpt79qRtjD8VJ00rd7QH/O5QgRLKr11Q809Tq0
         bzxj1KqOTpVQwdP+vTJ4h1LhMHv5hvh0rbJM8co+dbKWPgx5cbpI+TRXMHK4rzpornmI
         5HDfwrig1y25n+7jA8427xV9tJr4cLyp3XAs1gCgFw+8XP7JAEtV1crW0SbrOd0izyeP
         haew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ja3eaZ6L0eZYhBLiMvzByj46go5Z0Lrg8ifCIq+nQrI=;
        b=DNsLGl6URb5FBveBBujSd8fSgGzVeprGzvwqMpCfVqHItfUm3WwJfR3LOwFvGkKhiC
         7x1UvTQEwqqMnSTFKmhXJ7phGpjNpK9c9kGVfdjCsGqWcOrjNa78phfgTF17xhnqjVhG
         jFY15tzzsagT8K6gK8dxW8SsxXClp2xO6PriWk87UzbLDCeMP9wcnt6uh4u5/kHkwIn7
         pyvIxI8KyPsVAevREjjnyWi4dJNyfL/JKE7UvCfkvP9FwsMVCKVsnGqFTr2Av+U4nz1M
         bp+vCbAEWs0qt561cCKVnxa4CcDfVkIcv90CsZOM/2grV5VPjd03eLj4ktLHwxfYp3q9
         ARlA==
X-Gm-Message-State: ANhLgQ2pmlJPF3uyrr3QdvyiYUkNu/vHDU+gnFTMvws6TyefaSFt8BMK
        leEh9thU3g8JoH0ogGNH2/nEEEWn
X-Google-Smtp-Source: ADFU+vvIC1K3UmPLp1QSbhPFDiFfSOzsHdRKvclUa2/RFGf6a4a6nFugQPm0BySsD6Td7v1qoxE5vA==
X-Received: by 2002:a63:4864:: with SMTP id x36mr1477356pgk.398.1583197196017;
        Mon, 02 Mar 2020 16:59:56 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:1db6])
        by smtp.gmail.com with ESMTPSA id v29sm22153506pgc.72.2020.03.02.16.59.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 16:59:55 -0800 (PST)
Date:   Mon, 2 Mar 2020 16:59:53 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, ethercflow@gmail.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] Improve raw tracepoint BTF types
 preservation
Message-ID: <20200303005951.72szj5sb5rveh4xp@ast-mbp>
References: <20200301081045.3491005-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301081045.3491005-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 01, 2020 at 12:10:42AM -0800, Andrii Nakryiko wrote:
> Fix issue with not preserving btf_trace_##call structs when compiled under
> Clang. Additionally, capture raw tracepoint arguments in raw_tp_##call
> structs, directly usable from BPF programs. Convert runqslower to use those
> for proof of concept and to simplify code further.

Not only folks compile kernel with clang they use the latest BPF/BTF features
with it. This is very nice to see!
I've applied 1st patch to make clang compiled kernel emit proper BTF.

As far as patch 2 I'm not sure about 'raw_tp_' prefix. tp_btf type of progs can
use the same structs. So I think there could be a better name. Also bpftool can
generate them as well while emitting vmlinux.h. I think that will avoid adding
few kilobytes to vmlinux BTF that kernel isn't going to use atm.
