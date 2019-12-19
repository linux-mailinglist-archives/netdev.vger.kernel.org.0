Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B130C126658
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfLSQCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:02:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:53164 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfLSQCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:02:08 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihyFa-0001bO-HL; Thu, 19 Dec 2019 17:02:06 +0100
Date:   Thu, 19 Dec 2019 17:02:06 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: fix another __u64 printf warning
Message-ID: <20191219160206.GC8564@linux-9.fritz.box>
References: <20191219052103.3515-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219052103.3515-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 09:21:03PM -0800, Andrii Nakryiko wrote:
> Fix yet another printf warning for %llu specifier on ppc64le. This time size_t
> casting won't work, so cast to verbose `unsigned long long`.
> 
> Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
