Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C061464B
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEFI3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:29:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:60908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbfEFI3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 04:29:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78725AC5A;
        Mon,  6 May 2019 08:29:22 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 06 May 2019 10:29:22 +0200
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        bpf-owner@vger.kernel.org
Subject: Re: [PATCH bpf-next v2] bpf, libbpf: Add .so files to gitignore
In-Reply-To: <CAADnVQ+exT+Jv=i9a4MWNB_eeO6ZeJWAm0=OL5_EZ1gQLvRk-w@mail.gmail.com>
References: <20190502081453.25097-1-mrostecki@opensuse.org>
 <CAADnVQ+exT+Jv=i9a4MWNB_eeO6ZeJWAm0=OL5_EZ1gQLvRk-w@mail.gmail.com>
Message-ID: <cbbbbc994750b8b34825fc1133d6282d@opensuse.org>
X-Sender: mrostecki@opensuse.org
User-Agent: Roundcube Webmail
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2019-05-05 09:03, schrieb Alexei Starovoitov:
> Some folks build libbpf as part of selftests.
> Please update .gitignore in tools/lib/bpf and
> in tools/testing/selftests/bpf
> 
> Also instead of "bpf, libbpf:" subj prefix just mention "libbpf:"

Thanks for your review!

I noticed that in the meantime the .gitignore file in tools/lib/bpf was 
fixed
by the other commit (39391377f8ec). Now I need to fix only .gitignore in
tools/testing/selftests/bpf (where I need to add even more files, 
because
some test program binaries are not included too). I will send a patch 
for that
later today.
