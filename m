Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FBCEA3D6
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfJ3TJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:09:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfJ3TJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:09:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C4AF149D9F8E;
        Wed, 30 Oct 2019 12:09:26 -0700 (PDT)
Date:   Wed, 30 Oct 2019 12:09:25 -0700 (PDT)
Message-Id: <20191030.120925.1888086426485143779.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     borkmann@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, eric@sage.org, andrii.nakryiko@gmail.com,
        acme@redhat.com, bjorn.topel@intel.com, jolsa@redhat.com,
        toke@redhat.com, ivan.khoronzhuk@linaro.org,
        ilias.apalodimas@linaro.org
Subject: Re: Compile build issues with samples/bpf/ again
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030114313.75b3a886@carbon>
References: <20191030114313.75b3a886@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 12:09:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 30 Oct 2019 11:43:13 +0100

> Also I discovered, the command to build have also recently changed:
> - Before : make samples/bpf/   or  simply make in subdir samples/bpf/
> - new cmd: make M=samples/bpf  and in subdir is broken

Those build system changes were extremely annoying and have severely
hampered my workflow to no end.

Not only have subdir builds been broken off and on by this, but when
they do work they take forever so my usual shortcut of justing building
a specific object file to build test something now doesn't save me
much time at all.
