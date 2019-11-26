Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB5910A737
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKZXp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:45:26 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33012 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKZXp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:45:26 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so1279715pjb.0
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9uU6qHV5pOGz26SVj9iTq4D+yLDJRr2Oyj11nX2ZieU=;
        b=MBeOvK3ADnrJ8VvYXghkA0E56peH97xBtB3vDA+uGjo9vP1BqFGqFtL68zVfr1ajZu
         j+gfwRwwPCpKRG6SZS08bURb72V5B/Wqf5+0zr2kcceJgy0MzA0xOYWpxEBikVOAkIJk
         5VNSjSg05saLyLrQ3kGP0Wr+PpgIdr2GCmpqtpxArcd+Y9En/GjZOHQ2eoxsrHbiHaN6
         RODOeAhkVS7pAEow2G04T+57qcIIjLbwHPPT5BTJ56mqx6bip6VvnYYiY1z7KGqvbz03
         fjvjgHckjYihITDEVTp2bUIhdmlcsGBayfwKp9F1+gFHONpCcRF0i9oxlgCVXjBWE0EB
         w2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9uU6qHV5pOGz26SVj9iTq4D+yLDJRr2Oyj11nX2ZieU=;
        b=NRO0878bgiQRYiV5Lnr1DBBfy+4g37uhwFhtUqGZvmMWLvy1G6rK47oFm3D1tB6h53
         Z9yveHVR+pk9hp4h57hkdEka0DrWWH3Fs1MFEwz7yoh8x4PIwr7zD4pmeiozEOVl+Wzg
         j1JASgTEolkgC2AzqU+t5rL1K/TPG7odsqAW2EK6jHlEXTqYLvLmi+KdLDwKAtZoSodV
         ek5gV5uSltVoyV1uCA2Gwz56ArBjcGnvte2iMAEcEluQhA4jhJG2be4nZ9Z1ptPFWw8b
         JeNJDVrUIs67QkEPxel9LrA4dpb3BXWbAYRYYonbpaqAnUxgH2KDW1vKPubgRpC3PtPW
         zY3A==
X-Gm-Message-State: APjAAAWfDUZe73I1osZkDLmP+SKaMdqTB8+O6u+Zxce6L6ocHOTsJGS1
        r7DUI6xDRrvYQrffJaB/RKH/8w==
X-Google-Smtp-Source: APXvYqy5P3Onz5Xvx9GbYKxbDyv4xFbOHY0JWG1c0yyHBhjBxD3+lQ4rw5vBqVm+MrG4/DLqZUOQwQ==
X-Received: by 2002:a17:902:a618:: with SMTP id u24mr934071plq.296.1574811925223;
        Tue, 26 Nov 2019 15:45:25 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id p18sm14012447pff.9.2019.11.26.15.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 15:45:24 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:45:23 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for
 vmlinux BTF
Message-ID: <20191126234523.GF3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191126232818.226454-1-sdf@google.com>
 <5dddb7059b13e_13b82abee0d625bc2d@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dddb7059b13e_13b82abee0d625bc2d@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26, John Fastabend wrote:
> Stanislav Fomichev wrote:
> > If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> > .BTF section of vmlinux is empty and kernel will prohibit
> > BPF loading and return "in-kernel BTF is malformed".
> > 
> > --dump-section argument to binutils' objcopy was added in version 2.25.
> > When using pre-2.25 binutils, BTF generation silently fails. Convert
> > to --only-section which is present on pre-2.25 binutils.
> > 
> > Documentation/process/changes.rst states that binutils 2.21+
> > is supported, not sure those standards apply to BPF subsystem.
> > 
> > v2:
> > * exit and print an error if gen_btf fails (John Fastabend)
> > 
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  scripts/link-vmlinux.sh | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index 06495379fcd8..2998ddb323e3 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -127,7 +127,8 @@ gen_btf()
> >  		cut -d, -f1 | cut -d' ' -f2)
> >  	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> >  		awk '{print $4}')
> > -	${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
> > +	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
> > +		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
> >  	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> >  		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
> >  }
> > @@ -253,6 +254,10 @@ btf_vmlinux_bin_o=""
> >  if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> >  	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
> >  		btf_vmlinux_bin_o=.btf.vmlinux.bin.o
> > +	else
> > +		echo >&2 "Failed to generate BTF for vmlinux"
> > +		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"
> 
> I think we should encourage upgrading binutils first? Maybe
> 
> "binutils 2.25+ required for BTF please upgrade or disable CONFIG_DEBUG_INFO_BTF"
> 
> otherwise I guess its going to be a bit mystical why it works in
> cases and not others to folks unfamiliar with the details.
With the conversion from --dump-section to --only-section that I
did in this patch, binutils 2.25+ is no longer a requirement.
2.21 (minimal version from Documentation/process/changes.rst) should work
just fine.
