Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1185A0BF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfF1Q07 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 12:26:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfF1Q07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 12:26:59 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C0C03082E55;
        Fri, 28 Jun 2019 16:26:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-219.rdu2.redhat.com [10.10.120.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3BFE608CA;
        Fri, 28 Jun 2019 16:26:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com>
References: <293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com> <20190626190343.22031-1-aring@mojatatu.com> <20190626190343.22031-2-aring@mojatatu.com>
To:     nicolas.dichtel@6wind.com
Cc:     dhowells@redhat.com, Alexander Aring <aring@mojatatu.com>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@mojatatu.com
Subject: Re: [RFC iproute2 1/1] ip: netns: add mounted state file for each netns
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18556.1561739215.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 28 Jun 2019 17:26:55 +0100
Message-ID: <18557.1561739215@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 28 Jun 2019 16:26:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> David Howells was working on a mount notification mechanism:
> https://lwn.net/Articles/760714/
> https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=notifications
> 
> I don't know what is the status of this series.

It's still alive.  I just posted a new version on it.  I'm hoping, possibly
futiley, to get it in in this merge window.

David
