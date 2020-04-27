Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C761B9690
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgD0Fev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:34:51 -0400
Received: from verein.lst.de ([213.95.11.211]:45434 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgD0Feu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 01:34:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 20B2C68CEE; Mon, 27 Apr 2020 07:34:47 +0200 (CEST)
Date:   Mon, 27 Apr 2020 07:34:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200427053446.GA15905@lst.de>
References: <20200424064338.538313-1-hch@lst.de> <20200424064338.538313-6-hch@lst.de> <20200424190650.GA72647@rdna-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424190650.GA72647@rdna-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:06:50PM -0700, Andrey Ignatov wrote:
> > -
> > -#ifdef CONFIG_UCLAMP_TASK
> 
> Decided to skim through the patch one last time to double-check the fix
> from previous iteration and found that this ifdef got lost below.
> 
> > -extern int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
> > -				       void __user *buffer, size_t *lenp,
> > -				       loff_t *ppos);
> > -#endif

There is no need for ifdefs around prototypes that aren't used.
