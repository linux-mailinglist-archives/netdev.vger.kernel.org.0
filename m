Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C439D2DDA1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfE2NAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:00:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:35156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbfE2NAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 09:00:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 962DEAEB7;
        Wed, 29 May 2019 13:00:03 +0000 (UTC)
Date:   Wed, 29 May 2019 12:59:59 +0000
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] libbpf: Return btf_fd in libbpf__probe_raw_btf
Message-ID: <20190529125959.GA31842@wotan.suse.de>
References: <20190529082941.9440-1-mrostecki@opensuse.org>
 <e28170e1-cf06-87ef-812b-9b9e6185d925@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e28170e1-cf06-87ef-812b-9b9e6185d925@cogentembedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 12:53:42PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 29.05.2019 11:29, Michal Rostecki wrote:
> 
> > Function load_sk_storage_btf expects that libbpf__probe_raw_btf is
> > returning a btf descriptor, but before this change it was returning
> > an information about whether the probe was successful (0 or 1).
> > load_sk_storage_btf was using that value as an argument to the close
> > function, which was resulting in closing stdout and thus terminating the
> > process which used that dunction.
> 
>    Function? :-)

Opps! I will fix in v2. Thanks!
