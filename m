Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D0212768D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfLTHfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:35:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50631 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbfLTHfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 02:35:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576827354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w2Z040QQg3rmgl+fxa4Pg9DeMNSNdZutaGLQpmqqbpA=;
        b=hnRApzUWrXvPcsouFuFuO7Qm4kbRUAX9kwTnIWYzlVO3u9xki0ZUdPgKrwIvbkrKilVCp0
        iV1vhA8lvt/QFdlwEH2TXlbVaGhny25RBUU3yIMOxj+T3DeCJyjEWi1zPgXl6+7U6rrDwG
        O6qtdMobnLHd4HFZz0nPHrtq0Fn3y68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-h-C4-LO4NRmJqshYFgFVWA-1; Fri, 20 Dec 2019 02:35:51 -0500
X-MC-Unique: h-C4-LO4NRmJqshYFgFVWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 010B0107ACC4;
        Fri, 20 Dec 2019 07:35:50 +0000 (UTC)
Received: from elisabeth (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 182721001DD8;
        Fri, 20 Dec 2019 07:35:47 +0000 (UTC)
Date:   Fri, 20 Dec 2019 08:35:41 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests: pmtu: fix init mtu value in description
Message-ID: <20191220083541.17d467f0@elisabeth>
In-Reply-To: <20191220070806.9855-1-liuhangbin@gmail.com>
References: <20191220070806.9855-1-liuhangbin@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Dec 2019 15:08:06 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> There is no a_r3, a_r4 in the testing topology.

Oops :)

> It should be b_r1, b_r2. Also b_r1 mtu is 1400 and b_r2 mtu is 1500.
> 
> Fixes: e44e428f59e4 ("selftests: pmtu: add basic IPv4 and IPv6 PMTU tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

