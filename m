Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FEBD02D2
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfJHV1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:27:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:48034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbfJHV1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:27:35 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iHx12-0001hd-Qo; Tue, 08 Oct 2019 23:27:32 +0200
Date:   Tue, 8 Oct 2019 23:27:32 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 0/7] Move bpf_helpers and add BPF_CORE_READ
 macros
Message-ID: <20191008212732.GF27307@pc-66.home>
References: <20191008175942.1769476-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008175942.1769476-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25596/Tue Oct  8 10:33:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:59:35AM -0700, Andrii Nakryiko wrote:
> This patch set makes bpf_helpers.h and bpf_endian.h a part of libbpf itself
> for consumption by user BPF programs, not just selftests. It also splits off
> tracing helpers into bpf_tracing.h, which also becomes part of libbpf. Some of
> the legacy stuff (BPF_ANNOTATE_KV_PAIR, load_{byte,half,word}, bpf_map_def
> with unsupported fields, etc, is extracted into selftests-only bpf_legacy.h.
> All the selftests and samples are switched to use libbpf's headers and
> selftests' ones are removed.
[...]

Applied, thanks!
