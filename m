Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4941267A7
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfLSRGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:06:08 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37021 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfLSRGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:06:08 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so2831917plz.4;
        Thu, 19 Dec 2019 09:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XA55rnPiD5VnRa+mIp3j0LMWkAaLQc68hKMnHswUhU4=;
        b=Vx83zgmgCS0J6uG2ryd0wXh7MG6w+jAPCHg0iNJ7cos7v1rOAlTiNXyIA9dM9QwERc
         SMlNhFtMtHWSyTG38mjwLYQtZfHSUIjun7l1rdCgy72dcgJO6BPj+cDDKd5dLw5hD+Zs
         cq9EqolL3ah8iLRWH7Ys+gt2/vvTtm2oqtq/EMazxfsxXVBS6VoPfwpsRxSnBv0eAPuc
         LFgJ5rEiyqQt4/S+gXKSMlMwqqQFyri2sSGibSz7KO1k+KzCDoC4tezMtxON10RJInah
         cDxCCC+DKFrhcK9jqiLdiMS0dI/uUdoajNKkJKIZO+UADJ25bzY0Bnp2l+HWGePychFv
         ZXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XA55rnPiD5VnRa+mIp3j0LMWkAaLQc68hKMnHswUhU4=;
        b=V6I1eMeG6z76IJmNDUiWQgKnKknuM7wtHROcnH9yYLO2qtJyXkYtTy4RV8hMle7REu
         weERScmFcO+pD5XaqgcZzpp5ARGued5U6IwuhqFXz4xA0AEi10dssicgUokD2iUHeseH
         bWqAZxD44fBbQe1WdTUuOd+sQz3QRgQgRS0FFRFz/1xB/yZwO9PNSdcY3Yv9MsgcvFv+
         CAazVpeRJheSlmo65SXBDyYtmTC0u/oH5j2dOf0nvyMeenm9b66vhbj4XF8ib45uLY5l
         rt79ZiwKctxe8/N7Wa2afSU+bhKrdf3iXEocXCo2qGzXjx+U+nwp2PusgsCDP565afrn
         BthA==
X-Gm-Message-State: APjAAAXeMeJNu8yWlZ2/rtt4R/8djv5J/EDs/benT2NbrU3dLmy5M9a/
        T0Vb+3gVyv8e6TZJxoURDjw=
X-Google-Smtp-Source: APXvYqyBSosMeJSZI0uU5VE5Up6x6lhN/AF6DOuokbHul/Qbi/lBms9M4kzQ+6X9Wzzb1kBX4Tl1vA==
X-Received: by 2002:a17:90a:660d:: with SMTP id l13mr9325220pjj.23.1576775167245;
        Thu, 19 Dec 2019 09:06:07 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::6b48])
        by smtp.gmail.com with ESMTPSA id u26sm8682977pfn.46.2019.12.19.09.06.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 09:06:05 -0800 (PST)
Date:   Thu, 19 Dec 2019 09:06:04 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump
 command
Message-ID: <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
References: <20191219070659.424273-1-andriin@fb.com>
 <20191219070659.424273-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219070659.424273-2-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 11:06:56PM -0800, Andrii Nakryiko wrote:
> +	if (core_mode) {
> +		printf("#if defined(__has_attribute) && __has_attribute(preserve_access_index)\n");
> +		printf("#define __CLANG_BPF_CORE_SUPPORTED\n");
> +		printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
> +		printf("#endif\n\n");

I think it's dangerous to automatically opt-out when clang is not new enough.
bpf prog will compile fine, but it will be missing co-re relocations.
How about doing something like:
  printf("#ifdef NEEDS_CO_RE\n");
  printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
  printf("#endif\n\n");
and emit it always when 'format c'.
Then on the program side it will look:
#define NEEDS_CO_RE
#include "vmlinux.h"
If clang is too old there will be a compile time error which is a good thing.
Future features will have different NEEDS_ macros.
