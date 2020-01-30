Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4493C14E56C
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgA3WPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:15:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36828 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgA3WPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 17:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580422530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=juHZpbC38gvldwKKQgtdJvr3WmA0nVAvz2zKADDsVX8=;
        b=Dg5DBbg8ioL3+SsafOB7iQn0GQBkGA6JmScpWFzQEkVPagdlI7SabiKp5SmcWwP6xIaGdg
        Z9o2aMeQaUJpdCQe1Gu0DOkNMPOxlGQ/6VyJBDSA4j7dH2MhMSLCbrNcYOBvl/yi/xNUew
        rGgAPqt+0LHH/qGF/VNrHpFiGBcZv90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287--dY0x9LyPcuhPTVbKqxSyA-1; Thu, 30 Jan 2020 17:15:26 -0500
X-MC-Unique: -dY0x9LyPcuhPTVbKqxSyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99730803C22;
        Thu, 30 Jan 2020 22:15:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-197.rdu2.redhat.com [10.10.120.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB24F8BE04;
        Thu, 30 Jan 2020 22:15:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000005b4a6c0596d8c5a8@google.com>
References: <0000000000005b4a6c0596d8c5a8@google.com>
To:     syzbot <syzbot+2e7168a4d3c4ec071fdc@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, glider@google.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KMSAN: use-after-free in rxrpc_send_keepalive
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3725015.1580422520.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Jan 2020 22:15:20 +0000
Message-ID: <3725016.1580422520@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs=
.git e4866645bc264194ef92722ff09321a485d913a5

