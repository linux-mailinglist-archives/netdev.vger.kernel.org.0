Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6FB11AC95
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfLKN5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:57:06 -0500
Received: from www62.your-server.de ([213.133.104.62]:38694 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKN5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:57:06 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1if2UB-0007t5-SH; Wed, 11 Dec 2019 14:57:03 +0100
Date:   Wed, 11 Dec 2019 14:57:03 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf] libbpf: Bump libpf current version to v0.0.7
Message-ID: <20191211135703.GB25011@linux.fritz.box>
References: <20191209224022.3544519-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224022.3544519-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25660/Wed Dec 11 10:47:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:40:22PM -0800, Andrii Nakryiko wrote:
> New development cycles starts, bump to v0.0.7 proactively.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Subject says 'bpf', but I applied this to bpf-next, thanks!
