Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E4D2D4511
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbgLIPGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730367AbgLIPGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607526287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FmYAnbm6d1OBLGv5ZSJZ9lsbdFzQNlSAZjkpdV006SE=;
        b=jOvXZ+bnVcipDKMx89WfcsVgxUXQxVcRDts7Ibfh3Lye4PCFiWVM6u0F58eySizgfhOte4
        /dZGSXBCE//G9g+otKgbzFXl0f/X0DpwwZXoA7KnfZqCDs85Wi4/vqB28YaRwVn0upxJk0
        zvkjRgPf0iHylazxZTWmLd5n1HOsR7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-S8lXlQdZOAq4IVt0d9LgkQ-1; Wed, 09 Dec 2020 10:04:43 -0500
X-MC-Unique: S8lXlQdZOAq4IVt0d9LgkQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FA758030B9;
        Wed,  9 Dec 2020 15:04:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B16EE1F425;
        Wed,  9 Dec 2020 15:04:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201209133228.996-1-zhengyongjun3@huawei.com>
References: <20201209133228.996-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: rxrpc: convert comma to semicolon
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1255492.1607526271.1@warthog.procyon.org.uk>
Date:   Wed, 09 Dec 2020 15:04:31 +0000
Message-ID: <1255493.1607526271@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Reviewed-by: David Howells <dhowells@redhat.com>

