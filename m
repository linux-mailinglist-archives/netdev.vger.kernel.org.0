Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45369141AE2
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 02:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgASB2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 20:28:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30501 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727070AbgASB2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 20:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579397312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ep+Ssn8WBjmyp0iuaT4Hlyn5coNFBJoPCX01STXwIlg=;
        b=XhOkCHhDvJaAtr+1TnGyniy2IS3A0ndvuYFIbS9x3SWuR2DH2IhTnKKDbSER4fP/kFPgWR
        nXG4EpaQo4SRnNt3x41z2Xc3gLh1WbBrBh/kxrdjBMc2G7YoOiUnI7IvUf5mWcHee67miq
        ZA4KQJ2yE7Kze2cglQhtqwNvC5gEu9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-0K8Hp6ZcOy-fAElHAzcadw-1; Sat, 18 Jan 2020 20:28:29 -0500
X-MC-Unique: 0K8Hp6ZcOy-fAElHAzcadw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39DB4185432D;
        Sun, 19 Jan 2020 01:28:28 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FEDD84D87;
        Sun, 19 Jan 2020 01:28:25 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     netdev@vger.kernel.org
Cc:     vdronov@redhat.com, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George Shuklin <george.shuklin@gmail.com>
Subject: Re: [PATCH iproute2] ip: fix link type and vlan oneline output
Date:   Sun, 19 Jan 2020 02:28:22 +0100
Message-Id: <20200119012822.8135-1-vdronov@redhat.com>
In-Reply-To: <20200119011251.7153-1-vdronov@redhat.com>
References: <20200119011251.7153-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

i believe this fix should get to iproute2-next too and i'm not sure how
to do it. could you, please, advise/help to handle this?

-vladis

