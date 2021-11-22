Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF9458F63
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhKVNcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:32:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229984AbhKVNcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 08:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637587780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzKaeQ3x/E+JRitbqysGctyZRY4eXpFnnFZOkrrbUGI=;
        b=iGbaqTRTnhSNBMUGzPJKyBbH/jsjpA2F2VMYWV/eIy8kPTHMqPq/SY/5QkL1VYe+FGjom7
        maDWspRQb92huY+oYbtqTPkkVBkGLtpDPwwsK1sqHXYY/e5WM005kslnQhG1jhQw4kVD8I
        pYQ1t4AMo7pOjMhBBleqcBiIc79zO5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-Mt5XMedyNJuV4Fplapg8mA-1; Mon, 22 Nov 2021 08:29:38 -0500
X-MC-Unique: Mt5XMedyNJuV4Fplapg8mA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37D968735C1;
        Mon, 22 Nov 2021 13:29:37 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 988A960C9F;
        Mon, 22 Nov 2021 13:29:36 +0000 (UTC)
Date:   Mon, 22 Nov 2021 14:29:33 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Cc:     Florian Westphal <fw@strlen.de>, Netdev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel@openvz.org
Subject: Re: "AVX2-based lookup implementation" has broken ebtables
 --among-src
Message-ID: <20211122142933.15e6bffc@elisabeth>
In-Reply-To: <6d484385-5bf6-5cc5-4d26-fd90c367a2dc@virtuozzo.com>
References: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
        <20211116173352.1a5ff66a@elisabeth>
        <20211117120609.GI6326@breakpoint.cc>
        <6d484385-5bf6-5cc5-4d26-fd90c367a2dc@virtuozzo.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 15:08:54 +0300
Nikita Yushchenko <nikita.yushchenko@virtuozzo.com> wrote:

> >>> Looks like the AVX2-based lookup does not process this correctly.
> >>
> >> Thanks for bisecting and reporting this! I'm looking into it now, I
> >> might be a bit slow as I'm currently traveling.  
> > 
> > Might be a bug in ebtables....  
> 
> Exactly same ebtables binary (and exactly same rule) works with
> kernel 4.18 and all kernels up to the mentioned patch applied.

Sorry for the delay, I've been offline the past days, I'll restart
looking into this now.

-- 
Stefano

