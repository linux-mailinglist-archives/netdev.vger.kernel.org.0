Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC4226CBC1
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgIPUdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:33:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726904AbgIPRMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600276345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vEOYWIWUZZbjOvWaaaZu93r2/i0CVOT9x7lwnsy/CMY=;
        b=YV7iGDY0Fb9YPpT+1IGPqcWcqz1eUJK2XOJFVehc98nG+DabWnhk8+Ncpitb9ADaGDGnmE
        LEwGF/TEr1mOtAinWkpuaoSOJcfooIkdFtMAjDtwphlfRE3wqUIFDgbVg8kN16flAfIo+m
        hdUQbTLQuE+LNHrtCw/OdkkkEw5tUgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-rId4z_HRNOupn5g7JK_1kQ-1; Wed, 16 Sep 2020 09:45:35 -0400
X-MC-Unique: rId4z_HRNOupn5g7JK_1kQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13722AD682;
        Wed, 16 Sep 2020 13:45:32 +0000 (UTC)
Received: from astarta.redhat.com (ovpn-114-67.ams2.redhat.com [10.36.114.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54A1A78811;
        Wed, 16 Sep 2020 13:45:26 +0000 (UTC)
From:   Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
        ardb@kernel.org, naresh.kamboju@linaro.org,
        Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: bpf: Fix branch offset in JIT
References: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
        <20200915131102.GA26439@willie-the-truck>
        <20200915135344.GA113966@apalos.home>
        <20200915141707.GB26439@willie-the-truck>
        <20200915192311.GA124360@apalos.home> <xunyo8m5hp4m.fsf@redhat.com>
        <20200916131702.GB5316@myrica>
Date:   Wed, 16 Sep 2020 16:45:24 +0300
In-Reply-To: <20200916131702.GB5316@myrica> (Jean-Philippe Brucker's message
        of "Wed, 16 Sep 2020 15:17:02 +0200")
Message-ID: <xunyk0wthm2z.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jean-Philippe!

>>>>> On Wed, 16 Sep 2020 15:17:02 +0200, Jean-Philippe Brucker  wrote:

 > On Wed, Sep 16, 2020 at 03:39:37PM +0300, Yauheni Kaliuta wrote:
 >> If you start to amend extables, could you consider a change like
 >> 
 >> 05a68e892e89 ("s390/kernel: expand exception table logic to allow
 >> new handling options")
 >> 
 >> and implementation of BPF_PROBE_MEM then?

 > Commit 800834285361 ("bpf, arm64: Add BPF exception tables") should have
 > taken care of that, no?

Ah, missed that. Thanks!

-- 
WBR,
Yauheni Kaliuta

