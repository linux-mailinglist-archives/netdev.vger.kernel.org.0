Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644E3262B73
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgIIJMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgIIJMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:12:37 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286B2C061573;
        Wed,  9 Sep 2020 02:12:37 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4BmbrX3BnlzvjcZ; Wed,  9 Sep 2020 11:12:28 +0200 (CEST)
Date:   Wed, 9 Sep 2020 11:12:28 +0200
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, acme@kernel.org, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] perf: stop using deprecated bpf_program__title()
Message-ID: <20200909091227.3hujrwl5ol7de2b2@distanz.ch>
References: <20200908180127.1249-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908180127.1249-1-andriin@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-08 at 20:01:27 +0200, Andrii Nakryiko <andriin@fb.com> wrote:
> Switch from deprecated bpf_program__title() API to
> bpf_program__section_name(). Also drop unnecessary error checks because
> neither bpf_program__title() nor bpf_program__section_name() can fail or
> return NULL.
> 
> Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

Thanks
