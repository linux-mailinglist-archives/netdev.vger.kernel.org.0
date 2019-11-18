Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03E810003A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfKRISb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:18:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726316AbfKRISb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574065110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3MvS3Pykn8mQZTc6+4LMgBcmRIMAtBNaV6FFky/nJNg=;
        b=G/VcAJftYbDn0PfKPblB4CwOzlZP/qHPZ3ogxY63vT3Yr7hhMfs8VKRSMBVh9pthTRyxWP
        xWAVvd9vMtcvLvc+Qs8RGwzNYZL2/ZvlTtW4J0woyubfaFGxKvVIchiKU1SrDQSxOdvEx6
        0LKj9zl7+sx+AsP6AagvAlCl/pJPN9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-3TMTSlgDM9aNXxUXH_Ks5Q-1; Mon, 18 Nov 2019 03:18:25 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A50801FA1;
        Mon, 18 Nov 2019 08:18:23 +0000 (UTC)
Received: from localhost (ovpn-204-195.brq.redhat.com [10.40.204.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE68060856;
        Mon, 18 Nov 2019 08:18:22 +0000 (UTC)
Date:   Mon, 18 Nov 2019 09:18:21 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf] selftests: bpf: xdping is not meant to be run
 standalone
Message-ID: <20191118091821.4a1b3faf@redhat.com>
In-Reply-To: <427e0b06-679e-5621-f828-be545e6ca3b1@iogearbox.net>
References: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
        <427e0b06-679e-5621-f828-be545e6ca3b1@iogearbox.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 3TMTSlgDM9aNXxUXH_Ks5Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 23:06:13 +0100, Daniel Borkmann wrote:
> Any objections if I take this to bpf-next as otherwise this will create a=
n ugly
> merge conflict between bpf and bpf-next given selftests have been heavily=
 reworked
> in there.

Should I resend against bpf-next?

 Jiri

