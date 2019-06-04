Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17EC334609
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 13:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfFDL7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 07:59:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfFDL7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 07:59:19 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 961DA3001834;
        Tue,  4 Jun 2019 11:59:10 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33EA42B6FE;
        Tue,  4 Jun 2019 11:58:58 +0000 (UTC)
Date:   Tue, 4 Jun 2019 13:58:57 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH][next][V2] bpf: remove redundant assignment to err
Message-ID: <20190604135857.3f0e6cdc@carbon>
In-Reply-To: <20190604082146.2049-1-colin.king@canonical.com>
References: <20190604082146.2049-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 04 Jun 2019 11:59:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jun 2019 09:21:46 +0100
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is assigned with the value -EINVAL that is never
> read and it is re-assigned a new value later on.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> ---
> 
> V2: reorder variables as recommended by Jakub Kicinski to keep in
>     the networking code style.

Thank you for following the networking coding style.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
