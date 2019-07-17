Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3086B975
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfGQJnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 05:43:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfGQJnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 05:43:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDAAD8666A;
        Wed, 17 Jul 2019 09:43:38 +0000 (UTC)
Received: from localhost (unknown [10.40.205.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABBDC60BE2;
        Wed, 17 Jul 2019 09:43:36 +0000 (UTC)
Date:   Wed, 17 Jul 2019 11:43:34 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH AUTOSEL 5.2 226/249] selftests: bpf: fix inlines in
 test_lwt_seg6local
Message-ID: <20190717114334.5556a14e@redhat.com>
In-Reply-To: <20190715134655.4076-226-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
        <20190715134655.4076-226-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 17 Jul 2019 09:43:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 09:46:31 -0400, Sasha Levin wrote:
> From: Jiri Benc <jbenc@redhat.com>
> 
> [ Upstream commit 11aca65ec4db09527d3e9b6b41a0615b7da4386b ]
> 
> Selftests are reporting this failure in test_lwt_seg6local.sh:

I don't think this is critical in any way and I don't think this is a
stable material. How was this selected?

 Jiri
