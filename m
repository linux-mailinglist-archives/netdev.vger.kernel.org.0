Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99128EA023
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfJ3Pxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:53:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:42368 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbfJ3Px2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:53:28 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iPqHe-000671-MG; Wed, 30 Oct 2019 16:53:18 +0100
Date:   Wed, 30 Oct 2019 16:53:18 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Enforce 'return 0' in BTF-enabled raw_tp
 programs
Message-ID: <20191030155318.GB2675@pc-63.home>
References: <20191029032426.1206762-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029032426.1206762-1-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:24:26PM -0700, Alexei Starovoitov wrote:
> The return value of raw_tp programs is ignored by __bpf_trace_run()
> that calls them. The verifier also allows any value to be returned.
> For BTF-enabled raw_tp lets enforce 'return 0', so that return value
> can be used for something in the future.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
