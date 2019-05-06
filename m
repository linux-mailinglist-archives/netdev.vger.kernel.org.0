Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DBC15564
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEFVYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:24:44 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:39570 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfEFVYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 17:24:43 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 0096953D37D;
        Mon,  6 May 2019 23:24:39 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 06 May 2019 23:24:39 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com, linux-kernel@vger.kernel.org,
        xdp-newbies@vger.kernel.org, valdis@vt.edu
Subject: Re: netronome/nfp/bpf/jit.c cannot be build with -O3
In-Reply-To: <20190506140022.188d2b84@cakuba.hsd1.ca.comcast.net>
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
 <20190506140022.188d2b84@cakuba.hsd1.ca.comcast.net>
Message-ID: <2a3761669e4ec13847205d30384c0a17@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

On 06.05.2019 23:00, Jakub Kicinski wrote:
> Any chance you could try different compiler versions?  The code in
> question does not look too unusual.  Could you try if removing
> FIELD_FIT() on line 326 makes a difference?

If building with gcc from CentOS 7:

gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36)

the issue is not reproducible.

Also, commenting out the whole "if" block with FIELD_FIT() prevents the 
issue from occurring too.

-- 
   Oleksandr Natalenko (post-factum)
