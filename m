Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E3C226F63
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgGTT6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 15:58:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgGTT6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 15:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595275126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=riRyOF5JX7Ab1X0Yq7qQOguVpy6RN/d461f2fKfzeq8=;
        b=ft1batyUe+HXRM5VM4Wzif5pi7T7W+P8Bu6l4LZ0YmLzFHZHNMAXjcSYtZpKt/IDPVfA1m
        krlaYUGUW2ssxAKOQ/vNdiTTZUDS3Pdg8LZav8WYu1De0o77GQx0X3L4T/C4XgmwYuWduv
        Gn+dcHXOSRq+Ar4H53VaBOdJdSkfWis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-HtXHyZW8NBmXWxj5ivHjzQ-1; Mon, 20 Jul 2020 15:58:44 -0400
X-MC-Unique: HtXHyZW8NBmXWxj5ivHjzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C4C0100AA21;
        Mon, 20 Jul 2020 19:58:43 +0000 (UTC)
Received: from krava (unknown [10.40.194.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id 758CC60F96;
        Mon, 20 Jul 2020 19:58:41 +0000 (UTC)
Date:   Mon, 20 Jul 2020 21:58:40 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 3/5] bpf: add BTF_ID_LIST_GLOBAL in btf_ids.h
Message-ID: <20200720195840.GO760733@krava>
References: <20200720163358.1392964-1-yhs@fb.com>
 <20200720163401.1393159-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720163401.1393159-1-yhs@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:34:01AM -0700, Yonghong Song wrote:
> Existing BTF_ID_LIST used a local static variable
> to store btf_ids. This patch provided a new macro
> BTF_ID_LIST_GLOBAL to store btf_ids in a global
> variable which can be shared among multiple files.
> 
> The existing BTF_ID_LIST is still retained.
> Two reasons. First, BTF_ID_LIST is also used to build
> btf_ids for helper arguments which typically
> is an array of 5. Since typically different
> helpers have different signature, it makes
> little sense to share them. Second, some
> current computed btf_ids are indeed local.
> If later those btf_ids are shared between
> different files, they can use BTF_ID_LIST_GLOBAL then.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

