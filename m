Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EAD41558C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 04:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbhIWCvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 22:51:16 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35344 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbhIWCvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 22:51:15 -0400
Received: by linux.microsoft.com (Postfix, from userid 1095)
        id A96792089EE2; Wed, 22 Sep 2021 19:49:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A96792089EE2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1632365384;
        bh=xLdsl8kzcMimc82CMKplU0g9FfAdCqs4Pu32SbQeCEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VmLDghvMOMaar/xy4oNVDrTSqTn1kSdaJeEQDQMbBKJhEFZ1tzX+9xBHQgvWlUGKK
         hDwQ4dXCehdZLDGP/friH+rvyOL5zDC9sN8jx0PksOkKAqI+jzpPU/6De7y1lQasc8
         b79lFP9YxU7dC2G6i0ZViHG7tx36/Jrf3uCM6+k8=
Date:   Wed, 22 Sep 2021 19:49:44 -0700
From:   Muhammad Falak Wani <mwani@linux.microsoft.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next] libbpf: Use sysconf to simplify
 libbpf_num_possible_cpus
Message-ID: <20210923024944.GA446@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20210922070748.21614-1-falakreyaz@gmail.com>
 <ef0f23d0-456a-70b0-1ef9-2615a5528278@iogearbox.net>
 <CAEf4Bza6Bsee1i_ypbDogG5MsVFGW9pnatxHCn9PycW9eP2Gkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza6Bsee1i_ypbDogG5MsVFGW9pnatxHCn9PycW9eP2Gkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This approach is unfortunately broken, see also commit e00c7b216f34 ("bpf: fix
> > multiple issues in selftest suite and samples") for more details:
> 
> Oh, that predates me. Thanks, Daniel!
Thank you Daniel for the context. 

> 
> Sorry, Muhammad, seems like current implementation is there for a
> reason and will have to stay. Thanks a lot for working on this,
> though. Hopefully you can help with other issues, though.
> 
No worries at all, it was a good experience for me & I will
try to help here and there for sure.

Thank you again!

-mfrw
