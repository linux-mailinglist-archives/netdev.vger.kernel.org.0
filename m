Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3454B507
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfFSJgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:36:37 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:54387 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727068AbfFSJgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:36:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 6B6F91803EF2F;
        Wed, 19 Jun 2019 09:36:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:4321:5007:6119:7903:9010:10004:10400:10848:11232:11658:11914:12663:12740:12760:12895:13069:13311:13357:13439:14659:21080:21433:21627:30054:30060:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: lake79_906b73ef29727
X-Filterd-Recvd-Size: 1631
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Wed, 19 Jun 2019 09:36:32 +0000 (UTC)
Message-ID: <f22006fedb0204ad05858609bc9d3ed0abc6078e.camel@perches.com>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Date:   Wed, 19 Jun 2019 02:36:30 -0700
In-Reply-To: <CAKwvOd=i2qsEO90cHn-Zvgd7vbhK5Z4RH89gJGy=Cjzbi9QRMA@mail.gmail.com>
References: <20190618211440.54179-1-mka@chromium.org>
         <20190618230420.GA84107@archlinux-epyc>
         <CAKwvOd=i2qsEO90cHn-Zvgd7vbhK5Z4RH89gJGy=Cjzbi9QRMA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 16:23 -0700, Nick Desaulniers wrote:
> As a side note, I'm going to try to see if MAINTAINERS and
> scripts/get_maintainers.pl supports regexes on the commit messages in
> order to cc our mailing list

Neither.  Why should either?


