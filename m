Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569A6CDF7C
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfJGKkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:40:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727252AbfJGKkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:40:41 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A1C918C8906;
        Mon,  7 Oct 2019 10:40:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74CA75C1D4;
        Mon,  7 Oct 2019 10:40:40 +0000 (UTC)
Message-ID: <2525e069e337d617fd826eb7677a94131fb5643b.camel@redhat.com>
Subject: Re: [PATCH] ss: allow dumping kTLS info
From:   Davide Caratti <dcaratti@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org
In-Reply-To: <2531403b243c1c60afc175c164a02096ffcf89a5.1570442363.git.dcaratti@redhat.com>
References: <2531403b243c1c60afc175c164a02096ffcf89a5.1570442363.git.dcaratti@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 07 Oct 2019 12:40:39 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Mon, 07 Oct 2019 10:40:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-07 at 12:16 +0200, Davide Caratti wrote:
> now that INET_DIAG_INFO requests can dump TCP ULP information, extend 'ss'
> to allow diagnosing kTLS when it is attached to a TCP socket. While at it,
> import kTLS uAPI definitions from the latest net-next tree.
> 
> CC: Andrea Claudi <aclaudi@redhat.com>
> Co-developed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/uapi/linux/tls.h | 127 +++++++++++++++++++++++++++++++++++++++
>  misc/ss.c                |  89 +++++++++++++++++++++++++++
>  2 files changed, 216 insertions(+)
>  create mode 100644 include/uapi/linux/tls.h
> 
> diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
> new file mode 100644
> index 000000000000..bcd2869ed472

hello David,

I forgot to set the subject-prefix correctly: it was meant to be "PATCH
iproute2-next".

Sorry for the noise (ant thanks to Andrea for noticing :) )

regards,
-- 
davide

