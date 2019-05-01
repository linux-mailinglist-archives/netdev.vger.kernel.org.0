Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1377D10BE8
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEARSc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 May 2019 13:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfEARSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 13:18:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 53D0A3082B4B;
        Wed,  1 May 2019 17:18:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-61.rdu2.redhat.com [10.10.120.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C199271A0;
        Wed,  1 May 2019 17:18:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.21.1905020306290.14696@namei.org>
References: <alpine.LRH.2.21.1905020306290.14696@namei.org> <561.1556663960@warthog.procyon.org.uk>
To:     James Morris <jmorris@namei.org>
Cc:     dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [GIT PULL] keys: Namespacing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22942.1556731109.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 01 May 2019 18:18:29 +0100
Message-ID: <22943.1556731109@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 01 May 2019 17:18:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Can you pull this set of patches into the security tree and pass them along
> > to Linus in the next merge window?  The primary thrust is to add
> > namespacing to keyrings.
> 
> Not for this merge window, it's too close. Something like this would need 
> to be in -rc2 or so.

Okay.

David
