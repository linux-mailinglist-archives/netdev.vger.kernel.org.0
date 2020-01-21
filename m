Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582E81442AF
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 18:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgAURAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 12:00:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39413 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAURAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 12:00:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id 4so1809356pgd.6;
        Tue, 21 Jan 2020 09:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YxAdGehcuaknnMHNzXpLp8sLstU9M2dpQjvG1NuR//U=;
        b=lRg0grQbeA9l30X0RwgBmEjC3//VETs5RUp5TBfgBA2UvgG+ZAlhS5CnsfvSkiH8IH
         +DEiyxeL/0q7Wkh1gh4X2qc24GpH+9Wrvc9egg9xxIgLa5MkaNpjtB71LmVT4gdS+HtD
         rgF0Xp2pEv/DIftXbT5XIN3qOmJ860IQh1yeAhwvvsK4UE2ya8rtZPn1Z6XwGiIt6CV5
         +Jck2i2YpXSSG5ACr8Dei/PkhTzPap3JfeE9F/+y7i/1+Mycz+aqejfMJfMrq7QZszWC
         hW1yEp9pedXVCvJ0tw7P6AH5zfS4capOWxh9ARFvLuBvRi1FBu1Znslh9ZQR5APWp4AX
         UTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YxAdGehcuaknnMHNzXpLp8sLstU9M2dpQjvG1NuR//U=;
        b=EuhP/RLWCWtUesk3+LkHtr5QVsxDx73u1UMIVhRu9U5FTRPAmTBcwZgtTnswcco7p2
         HTy5/8bpW9LvnmG2pzUlKOmxSkqWLunqQOVFAOal/o1cwitlyUJUCFSdp+5ESnbafWdP
         LAGAA53g06hzWW9y0RUtH+z6gBOC0ORB0kdm44SmYM0B02zKoKk9rGzCyKillpZrVaKZ
         OnyfCNxy04wLxA1EpmBj1raURqK7FPzPAiid8AQrnlvFj7nYSSRRCa2K97r1lQ4NZRQT
         NvZunjzXI5hjoCutJWDFG2uaeP4h6/uS5pBsj4Q3ZUDdrOShCVecEaWeZTkuZccbwbdV
         OdAw==
X-Gm-Message-State: APjAAAW7H6HpO75F3iYnNa/gTGx4yfmLeTP8TyUigtkwRYLUiQP5fHTy
        3w95vKtBLSMRd6R4RMFtRROBCkXB
X-Google-Smtp-Source: APXvYqz9PQw0VwzbBR5Pn5Tmh6/+qvhLRDHK6KKs/E2u9nUB1maRQZwpW3PkNjMdkegqHyjruQ2F5Q==
X-Received: by 2002:a65:6914:: with SMTP id s20mr6337086pgq.44.1579626003167;
        Tue, 21 Jan 2020 09:00:03 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:8f80])
        by smtp.gmail.com with ESMTPSA id hg11sm4138033pjb.14.2020.01.21.09.00.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 09:00:02 -0800 (PST)
Date:   Tue, 21 Jan 2020 09:00:01 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Program extensions or dynamic
 re-linking
Message-ID: <20200121165958.zfpvsz7kdcx2dotr@ast-mbp.dhcp.thefacebook.com>
References: <20200121005348.2769920-1-ast@kernel.org>
 <87k15kbz2c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k15kbz2c.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 04:37:31PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <ast@kernel.org> writes:
> 
> > The last few month BPF community has been discussing an approach to call
> > chaining, since exiting bpt_tail_call() mechanism used in production XDP
> > programs has plenty of downsides. The outcome of these discussion was a
> > conclusion to implement dynamic re-linking of BPF programs. Where rootlet XDP
> > program attached to a netdevice can programmatically define a policy of
> > execution of other XDP programs. Such rootlet would be compiled as normal XDP
> > program and provide a number of placeholder global functions which later can be
> > replaced with future XDP programs. BPF trampoline, function by function
> > verification were building blocks towards that goal. The patch 1 is a final
> > building block. It introduces dynamic program extensions. A number of
> > improvements like more flexible function by function verification and better
> > libbpf api will be implemented in future patches.
> 
> This is great, thank you! I'll go play around with it; couldn't spot
> anything obvious from eye-balling the code, except that yeah, it does
> need a more flexible libbpf api :)
> 
> One thing that's not obvious to me: How can userspace tell which
> programs replace which functions after they are loaded? Is this put into
> prog_tags in struct bpf_prog_info, or?

good point. Would be good to extend bpf_prog_info. Since prog-to-prog
connection is unidirectional the bpf_prog_info of extension prog will be able
to say which original program it's replacing. bpftool prog show will be able to
print all this data. I think fenry/fexit progs would need the same
bpf_prog_info extension. attach_prog_id + attach_btf_id would be enough.
In the mean time I can try to hack drgn script to do the same.
