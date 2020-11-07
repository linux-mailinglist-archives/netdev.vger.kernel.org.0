Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371C22AA260
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 04:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgKGD57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 22:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgKGD57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 22:57:59 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C01C20691;
        Sat,  7 Nov 2020 03:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604721478;
        bh=2mel3Of2YVGpiysSKvzZ1mbHiycaxIGNhrechHXN4FY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1R33ygtW2Cl4fbV6biT9wp6+lZ158gUX81ipyPuQRdSDOCAxuAam8K3MLsPYj5TFb
         hFQMTJcpOD81kqzVfm2iNqFMvzYqJkyBxOt9exO5y6xZuC2ew39e90uCIeyL5djf4z
         +eWmjmnWL+OBp8utBjun1+A7qMby3kZ6g+xWDxTc=
Date:   Fri, 6 Nov 2020 19:57:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-11-06
Message-ID: <20201106195757.60176976@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106221759.24143-1-alexei.starovoitov@gmail.com>
References: <20201106221759.24143-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 14:17:59 -0800 Alexei Starovoitov wrote:
> 1) Pre-allocated per-cpu hashmap needs to zero-fill reused element, from David.
> 
> 2) Tighten bpf_lsm function check, from KP.
> 
> 3) Fix bpftool attaching to flow dissector, from Lorenz.
> 
> 4) Use -fno-gcse for the whole kernel/bpf/core.c instead of function attribute, from Ard.


Pulled, thanks.
