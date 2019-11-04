Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6D6EE8DB
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfKDThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:37:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbfKDThf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:37:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 978E1151D725F;
        Mon,  4 Nov 2019 11:37:34 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:37:34 -0800 (PST)
Message-Id: <20191104.113734.338752879045096867.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        ast@kernel.org
Subject: Re: [PATCH net-next] bpf: re-fix skip write only files in debugfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104082721.2c4304e8@cakuba.netronome.com>
References: <94ba2eebd8d6c48ca6da8626c9fa37f186d15f92.1572876157.git.daniel@iogearbox.net>
        <20191104082721.2c4304e8@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:37:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 4 Nov 2019 08:27:21 -0800

> On Mon,  4 Nov 2019 15:27:02 +0100, Daniel Borkmann wrote:
>> Commit 5bc60de50dfe ("selftests: bpf: Don't try to read files without
>> read permission") got reverted as the fix was not working as expected
>> and real fix came in via 8101e069418d ("selftests: bpf: Skip write
>> only files in debugfs"). When bpf-next got merged into net-next, the
>> test_offload.py had a small conflict. Fix the resolution in ae8a76fb8b5d
>> iby not reintroducing 5bc60de50dfe again.
>> 
>> Fixes: ae8a76fb8b5d ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next")
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Cc: Alexei Starovoitov <ast@kernel.org>
> 
> Ayayay :(
> 
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
