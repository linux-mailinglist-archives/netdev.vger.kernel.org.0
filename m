Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5569C1C21E5
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 02:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEBAZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 20:25:18 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:37310 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726352AbgEBAZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 20:25:18 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 27FA8181D341E;
        Sat,  2 May 2020 00:25:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:491:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3874:4321:5007:6119:6120:6742:7875:10004:10400:10848:11232:11658:11914:12109:12297:12740:12760:12895:13069:13138:13231:13311:13357:13439:14659:21080:21627:30034:30054:30062:30075:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: unit54_10c38181e770c
X-Filterd-Recvd-Size: 2162
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sat,  2 May 2020 00:25:15 +0000 (UTC)
Message-ID: <7c15d0d43e0661d4b68d80c26fe73bfb6df38184.camel@perches.com>
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type
 printing
From:   Joe Perches <joe@perches.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Fri, 01 May 2020 17:25:13 -0700
In-Reply-To: <alpine.LRH.2.21.2004301010520.23084@localhost>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
         <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
         <alpine.LRH.2.21.2004201623390.12711@localhost>
         <7d6019da19d52c851d884731b1f16328fdbe2e3d.camel@perches.com>
         <alpine.LRH.2.21.2004301010520.23084@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-30 at 03:03 -0700, Alan Maguire wrote:
> On Mon, 20 Apr 2020, Joe Perches wrote:

> > Here as well the individual field types don't contain
> > enough information to determine if a field should be
> > output as %x or %u.
> Right, we could add some more format modifiers for cases
> like that I guess.  Currently the display formats used are
> - numbers are represented as decimal
> - bitfields are represented in hex
> - pointers are obfuscated unless the 'x' option is used
> - char arrays are printed as chars if printable,
>   [ 'l', 'i', 'k', 'e', ' ', 't', 'h', 'i', 's' ]
> 
> I'd be happy to add more format specifiers to control
> these options, or tweak the defaults if needed. A
> "print numbers in hex" option seems worthwhile perhaps?

Or maybe add and use new typedefs like x8,x16,x32,x64 to the
bpf struct definitions where u8,u16,u32,u64 are %u and
x8,x16,x32,x64 are %x


