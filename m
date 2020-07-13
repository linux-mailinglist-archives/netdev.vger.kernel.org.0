Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1531721D3A9
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgGMKSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729492AbgGMKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:18:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFF1C061755;
        Mon, 13 Jul 2020 03:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0o9oacOGT+yOP9IRqdUPc2s8dF57vl7CrgaxsIQm6kY=; b=WuQ0kxda7+r8HBqZI0FTm2qhm+
        5A9vgpkAf8rH1wmYr9cGGMxCB9LiUQKW0DN9hpk5Oh4UK/n9SNW5Wulb0Pt0qfbYfyeBv7Za3kMMm
        hPYnPgMcWIVNDuCYT443bmjIgq8Ca3Rgo55/ecfAP9NTnGSoG/65q+OjIfCA4bvkRurASiiBCjs4F
        Z1aw3KpdXkUMypAla0yUfu60Y20JM4i36X5ivA4NLys3HN2y/+F18dk31OdpI1A2fSJet0cEQ4XXS
        TUenmlDt7ff0mPmWSDxtFbrzMxjay79EfqNOcFxVm4NO3MI+hKwsLn2HoaeqnCKgudpp1fV/A1BAk
        UjLSA/Bw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1juvXg-0000B0-6d; Mon, 13 Jul 2020 10:18:36 +0000
Date:   Mon, 13 Jul 2020 11:18:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     syzbot <syzbot+4c50ac32e5b10e4133e1@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: WARNING in submit_bio_checks
Message-ID: <20200713101836.GA536@infradead.org>
References: <00000000000029663005aa23cff4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000029663005aa23cff4@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 10:34:19PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:

This is not a crash, but a WARN_ONCE.  A pre-existing one that just
slightly changed the printed message recently.
