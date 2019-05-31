Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD93731172
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfEaPin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:38:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfEaPin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 11:38:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20FC130C1E3A;
        Fri, 31 May 2019 15:38:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-173.rdu2.redhat.com [10.10.120.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEBCB7C5E1;
        Fri, 31 May 2019 15:38:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190531122214.18616-2-fw@strlen.de>
References: <20190531122214.18616-2-fw@strlen.de> <20190531122214.18616-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH net-next v2 1/7] afs: do not send list of client addresses
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10843.1559317119.1@warthog.procyon.org.uk>
Date:   Fri, 31 May 2019 16:38:39 +0100
Message-ID: <10847.1559317119@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 31 May 2019 15:38:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:

> David Howell says:

"Howells"

Apart from that:

Tested-by: David Howells <dhowells@redhat.com>
