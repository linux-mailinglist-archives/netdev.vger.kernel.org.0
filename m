Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0226E202
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 09:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfGSHyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 03:54:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfGSHyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 03:54:16 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 90EED317917B;
        Fri, 19 Jul 2019 07:54:16 +0000 (UTC)
Received: from localhost (unknown [10.40.205.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6493A610A3;
        Fri, 19 Jul 2019 07:54:14 +0000 (UTC)
Date:   Fri, 19 Jul 2019 09:54:12 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, yhs@fb.com, daniel@iogearbox.net,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH AUTOSEL 5.2 226/249] selftests: bpf: fix inlines in
 test_lwt_seg6local
Message-ID: <20190719095412.1b4fe444@redhat.com>
In-Reply-To: <20190718.115534.1778444973119064345.davem@davemloft.net>
References: <20190717114334.5556a14e@redhat.com>
        <20190717234757.GD3079@sasha-vm>
        <20190718093654.0a3426f5@redhat.com>
        <20190718.115534.1778444973119064345.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 19 Jul 2019 07:54:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 11:55:34 -0700 (PDT), David Miller wrote:
> It has a significant impact on automated testing which lots of
> individuals and entities perform, therefore I think it very much is
> -stable material.

Okay.

Thanks,

 Jiri
