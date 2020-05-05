Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21ADD1C4DF4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 07:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgEEF5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 01:57:07 -0400
Received: from verein.lst.de ([213.95.11.211]:33401 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgEEF5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 01:57:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 430EE68BEB; Tue,  5 May 2020 07:57:04 +0200 (CEST)
Date:   Tue, 5 May 2020 07:57:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christoph Hellwig <hch@lst.de>, Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200505055704.GA3552@lst.de>
References: <20200424064338.538313-1-hch@lst.de> <20200424064338.538313-6-hch@lst.de> <202005041154.CC19F03@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005041154.CC19F03@keescook>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 12:01:11PM -0700, Kees Cook wrote:
> >  	if (error)
> > -		goto out;
> > +		goto out_free_buf;
> >  
> >  	/* careful: calling conventions are nasty here */
> 
> Is this comment still valid after doing these cleanups?

The comment is pretty old so I decided to keep it.  That being said
I'm not sure it really is very helpful.
