Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52107BE63F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393073AbfIYUUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:20:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:60428 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfIYUUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:20:02 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDDlX-0001YE-IB; Wed, 25 Sep 2019 22:19:59 +0200
Date:   Wed, 25 Sep 2019 22:19:59 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        syzkaller-bugs@googlegroups.com,
        syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com
Subject: Re: [PATCH net] bpf/xskmap: Return ERR_PTR for failure case instead
 of NULL.
Message-ID: <20190925201959.GB9500@pc-63.home>
References: <20190924162521.1630419-1-jonathan.lemon@gmail.com>
 <5f85df65-0f2e-3533-9734-147b0734e254@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f85df65-0f2e-3533-9734-147b0734e254@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25583/Wed Sep 25 10:27:51 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 09:30:44PM +0200, Björn Töpel wrote:
> On 2019-09-24 18:25, Jonathan Lemon wrote:
> > When kzalloc() failed, NULL was returned to the caller, which
> > tested the pointer with IS_ERR(), which didn't match, so the
> > pointer was used later, resulting in a NULL dereference.
> > 
> > Return ERR_PTR(-ENOMEM) instead of NULL.
> > 
> > Reported-by: syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com
> > Fixes: 0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is released")
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> Thanks Jonathan! You beat me to it! :-P
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>

Applied, thanks!
