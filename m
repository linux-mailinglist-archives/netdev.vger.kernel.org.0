Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B43DECE2
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfJUM4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:56:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:58040 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbfJUM4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 08:56:00 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iMXE5-0006DL-W5; Mon, 21 Oct 2019 14:55:58 +0200
Date:   Mon, 21 Oct 2019 14:55:57 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/7] Auto-guess program type on bpf_object__open
Message-ID: <20191021125557.GM26267@pc-63.home>
References: <20191021033902.3856966-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021033902.3856966-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25609/Mon Oct 21 10:57:36 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 08:38:55PM -0700, Andrii Nakryiko wrote:
> This patch set's main goal is to teach bpf_object__open() (and its variants)
> to automatically derive BPF program type/expected attach type from section
> names, similarly to how bpf_prog_load() was doing it. This significantly
> improves user experience by eliminating yet another
> obvious-only-in-the-hindsight surprise, when using libbpf APIs.
> 
> There are a bunch of auxiliary clean-ups and improvements. E.g.,
> bpf_program__get_type() and bpf_program__get_expected_attach_type() are added
> for completeness and symmetry with corresponding setter APIs. Some clean up
> and fixes in selftests/bpf are done as well.
> 
> Andrii Nakryiko (7):
>   tools: sync if_link.h
>   libbpf: add bpf_program__get_{type, expected_attach_type) APIs
>   libbpf: add uprobe/uretprobe and tp/raw_tp section suffixes
>   libbpf: teach bpf_object__open to guess program types
>   selftests/bpf: make a copy of subtest name
>   selftests/bpf: make reference_tracking test use subtests
>   selftest/bpf: get rid of a bunch of explicit BPF program type setting

Looks good, applied, thanks!
