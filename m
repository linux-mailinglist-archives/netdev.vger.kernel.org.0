Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F646C3A3
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 01:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbfGQXr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 19:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbfGQXr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 19:47:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CBF21783;
        Wed, 17 Jul 2019 23:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563407278;
        bh=Siv/KnNF60mlRWThubfKazGtO8AyOQXZRuU8aJ8ckCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BdnE4x7o3SNxyTDnkAjpMTth0y175vo1fyPd0ZZBFXmT+uF0mWagMJL+SuCoc5hCV
         tLQ72DTZJbhXyWJITTTQjrh1ViQh3ucgZWXaRiQXxX0DzcB7kcIgtGr4WKpJH4oPQe
         FJfBxhSADkt9Zqa9qIiiudtrzLYT46cin7mUCZn8=
Date:   Wed, 17 Jul 2019 19:47:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jiri Benc <jbenc@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH AUTOSEL 5.2 226/249] selftests: bpf: fix inlines in
 test_lwt_seg6local
Message-ID: <20190717234757.GD3079@sasha-vm>
References: <20190715134655.4076-1-sashal@kernel.org>
 <20190715134655.4076-226-sashal@kernel.org>
 <20190717114334.5556a14e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190717114334.5556a14e@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 11:43:34AM +0200, Jiri Benc wrote:
>On Mon, 15 Jul 2019 09:46:31 -0400, Sasha Levin wrote:
>> From: Jiri Benc <jbenc@redhat.com>
>>
>> [ Upstream commit 11aca65ec4db09527d3e9b6b41a0615b7da4386b ]
>>
>> Selftests are reporting this failure in test_lwt_seg6local.sh:
>
>I don't think this is critical in any way and I don't think this is a
>stable material. How was this selected?

It fixes a bug, right?

--
Thanks,
Sasha
