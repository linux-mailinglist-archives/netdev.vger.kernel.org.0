Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468BC304C6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE3W2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:28:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55038 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3W2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0VN5c421RywifIF8i/3tvMhN6mXfzQVaKnVDur62RGU=; b=KHCp4Wiwwi+f9S4LXp2IJWa5zG
        SxnfG52Z9HxmHDW4gg74ulMSbpX0CDQGMZwMd+W5Zj+3lr0uW1f1hHekCH/7sjHKruEstLuNKJWji
        olk3QfhPAS/s/B3FHzbOEj2ynup7ZWk48Me/GhtfyzAVBus//uBGdH+fLD4xK6DtTkJ6b3VRkyThS
        4SKYhXskAK0TnZVr53SjW5ArJZZiNr6g6vNNrZqkCWt9zCwUk47K4GQVfBrUgqtecIi/gLuFzxFOt
        gnPfHcQ5hIyijGQfOj0LZgCOctO4GZSAJb0BvI+seY1CoYVj/KtS7DdWCZlqkY2ELPdulpDWaLiFR
        yLh9IG1Q==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hWTXV-0003kU-A0; Thu, 30 May 2019 22:28:49 +0000
Subject: Re: mmotm 2019-05-29-20-52 uploaded (mpls)
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190530035339.hJr4GziBa%akpm@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5a9fc4e5-eb29-99a9-dff6-2d4fdd5eb748@infradead.org>
Date:   Thu, 30 May 2019 15:28:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530035339.hJr4GziBa%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 8:53 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2019-05-29-20-52 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (5.x
> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
> 
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.
> 

on i386 or x86_64:

when CONFIG_PROC_SYSCTL is not set/enabled:

ld: net/mpls/af_mpls.o: in function `mpls_platform_labels':
af_mpls.c:(.text+0x162a): undefined reference to `sysctl_vals'
ld: net/mpls/af_mpls.o:(.rodata+0x830): undefined reference to `sysctl_vals'
ld: net/mpls/af_mpls.o:(.rodata+0x838): undefined reference to `sysctl_vals'
ld: net/mpls/af_mpls.o:(.rodata+0x870): undefined reference to `sysctl_vals'



-- 
~Randy
