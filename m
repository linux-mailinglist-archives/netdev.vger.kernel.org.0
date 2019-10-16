Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5CD90F6
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393070AbfJPMbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:31:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:39466 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387743AbfJPMbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:31:40 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKiSo-0007Aw-CU; Wed, 16 Oct 2019 14:31:39 +0200
Date:   Wed, 16 Oct 2019 14:31:38 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next] scripts/bpf: Emit an #error directive known
 types list needs updating
Message-ID: <20191016123138.GD21367@pc-63.home>
References: <20191016085811.11700-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016085811.11700-1-jakub@cloudflare.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25604/Wed Oct 16 10:53:05 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 10:58:11AM +0200, Jakub Sitnicki wrote:
> Make the compiler report a clear error when bpf_helpers_doc.py needs
> updating rather than rely on the fact that Clang fails to compile
> English:
> 
> ../../../lib/bpf/bpf_helper_defs.h:2707:1: error: unknown type name 'Unrecognized'
> Unrecognized type 'struct bpf_inet_lookup', please add it to known types!
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied, thanks!
