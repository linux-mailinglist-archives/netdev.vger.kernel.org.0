Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E867400EBA
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 10:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhIEIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 04:40:47 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34763 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhIEIkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 04:40:46 -0400
Received: from cust-b66e5d83 ([IPv6:fc0c:c157:b88d:62c6:5e3c:5f07:82d0:1b4])
        by smtp-cloud8.xs4all.net with ESMTPA
        id MngjmaONmy7WyMngkmDvjC; Sun, 05 Sep 2021 10:39:42 +0200
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 6D744161EBB;
        Sun,  5 Sep 2021 10:39:41 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s6V1LdwxJ6RU; Sun,  5 Sep 2021 10:39:40 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 40B7D161E88;
        Sun,  5 Sep 2021 10:39:40 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id 295171631CA; Sun,  5 Sep 2021 10:39:40 +0200 (CEST)
Date:   Sun, 5 Sep 2021 10:39:40 +0200
From:   folkert <folkert@vanheusden.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
Subject: Re: masquerading AFTER first packet
Message-ID: <20210905083939.GH3350910@belle.intranet.vanheusden.com>
References: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
 <20210902162612.GA23554@breakpoint.cc>
 <20210902174845.GE3350910@belle.intranet.vanheusden.com>
 <20210902200736.GB23554@breakpoint.cc>
 <20210902205423.GG3350910@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902205423.GG3350910@belle.intranet.vanheusden.com>
Reply-By: Wed 01 Sep 2021 07:11:01 PM CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Envelope: MS4xfNfRnCRSonppqVkxgYiJz45820Rtxoy+iisEjHFepT+2FisYV3RAX1SjFBRUW4uYSa/F9hfYBYwZMo2ViMUki4YFwPpHtL/W63/yGhlRl254XUkvgikD
 CT1ThGHuSl60BdOqCNlrBqOoVyyN33YBu/qgBfv9nJW/bPGXTZl6bY1bs6xvcCAOYPt11PWUR7yTP144945jWLdOI36ZPRyCepyjuj2AP+01JxAljM/xVzuY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So conclusion: my IP-stack *may* be producing incorrect checksums, or
> Linux or tcpdump and wireshark may be incorrectly evaluating them?

I'm sceptical about the incorrect checksum hypothesis.

That would be wireshark, tcpdump, my own ip-stack and a quick python-
script that verifies checksums all disagreeing with the kernel in this
specific case.

https://github.com/folkertvanheusden/MyIP/blob/master/netverify.py
