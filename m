Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97D24BDB9
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfFSQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfFSQJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:09:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 032EB2E95AF;
        Wed, 19 Jun 2019 16:09:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D55765C225;
        Wed, 19 Jun 2019 16:09:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <156096036064.6697.2432500504898119675.stgit@warthog.procyon.org.uk>
References: <156096036064.6697.2432500504898119675.stgit@warthog.procyon.org.uk>
Cc:     dhowells@redhat.com, ebiederm@xmission.com,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, dwalsh@redhat.com,
        vgoyal@redhat.com, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] keys: Namespacing [ver #4]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10071.1560960566.1@warthog.procyon.org.uk>
Date:   Wed, 19 Jun 2019 17:09:26 +0100
Message-ID: <10072.1560960566@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 19 Jun 2019 16:09:29 +0000 (UTC)
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies...  A couple of the patches don't compile because I forgot to commit
a change:-(

Will repush and repost.

David
