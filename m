Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E41E34DD67
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhC3BVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhC3BUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:20:41 -0400
Received: from joooj.vinc17.net (joooj.vinc17.net [IPv6:2001:4b99:1:3:216:3eff:fe20:ac98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F18C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:20:38 -0700 (PDT)
Received: from smtp-zira.vinc17.net (lfbn-tou-1-1431-42.w90-89.abo.wanadoo.fr [90.89.233.42])
        by joooj.vinc17.net (Postfix) with ESMTPSA id B0216239;
        Tue, 30 Mar 2021 03:20:35 +0200 (CEST)
Received: by zira.vinc17.org (Postfix, from userid 1000)
        id 574D5C2057A; Tue, 30 Mar 2021 03:20:34 +0200 (CEST)
Date:   Tue, 30 Mar 2021 03:20:34 +0200
From:   Vincent Lefevre <vincent@vinc17.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: ip help text should fit on 80 columns
Message-ID: <20210330012034.GA272537@zira.vinc17.org>
References: <20210329172405.GD209599@zira.vinc17.org>
 <20210329151338.790332dd@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210329151338.790332dd@hermes.local>
X-Mailer-Info: https://www.vinc17.net/mutt/
User-Agent: Mutt/2.0.6+145 (9566a95c) vl-132933 (2021-03-29)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-29 15:13:38 -0700, Stephen Hemminger wrote:
> On Mon, 29 Mar 2021 19:24:05 +0200
> Vincent Lefevre <vincent@vinc17.net> wrote:
> 
> > Help text such as output by "ip help" or "ip link help" should fit
> > on 80 columns. It currently seems to take up to 86 columns.
> > 
> > Tested version:
> > 
> > zira:~> ip -V  
> > ip utility, iproute2-5.9.0, libbpf 0.3.0
> > 
> > but that's the iproute2 5.10.0-4 Debian package.
> 
> Have you looked at latest iproute2 in git?

OK, I see that there have been changes in the one from git.kernel.org,
but not in the one from github (which I was looking at until now).

I'm not sure whether the difference between these repositories is
expected, but https://wiki.linuxfoundation.org/networking/iproute2
suggests either, without saying anything else.

-- 
Vincent Lefèvre <vincent@vinc17.net> - Web: <https://www.vinc17.net/>
100% accessible validated (X)HTML - Blog: <https://www.vinc17.net/blog/>
Work: CR INRIA - computer arithmetic / AriC project (LIP, ENS-Lyon)
