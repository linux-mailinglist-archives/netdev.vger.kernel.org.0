Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3000211AC19
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfLKNdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:33:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:33956 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfLKNdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:33:05 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1if26w-0005zf-Te; Wed, 11 Dec 2019 14:33:02 +0100
Date:   Wed, 11 Dec 2019 14:33:02 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Message-ID: <20191211133302.GD23383@linux.fritz.box>
References: <20191210181412.151226-1-toke@redhat.com>
 <20191210125457.13f7821a@cakuba.netronome.com>
 <87eexbhopo.fsf@toke.dk>
 <20191211130857.GB23383@linux.fritz.box>
 <87zhfzf184.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zhfzf184.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25660/Wed Dec 11 10:47:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 02:20:11PM +0100, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> > On Tue, Dec 10, 2019 at 10:09:55PM +0100, Toke Høiland-Jørgensen wrote:
> > [...]
> >> Anyhow, I don't suppose it'll hurt to have the Fixes: tag(s) in there;
> >> does Patchwork pick these up (or can you guys do that when you apply
> >> this?), or should I resend?
> >
> > Fixes tags should /always/ be present if possible, since they help to provide
> > more context even if the buggy commit was in bpf-next, for example.
> 
> ACK, will do. Thank you for picking them up for this patch (did you do
> that manually, or is this part of your scripts?)

Manually right now, but if you have some cycles, happy to pick up a patch [0]. :)

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/pw.git/
