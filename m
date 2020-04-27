Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A54F1B9828
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgD0HPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgD0HPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 03:15:17 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A0DC061A0F;
        Mon, 27 Apr 2020 00:15:17 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSxyu-00CcTO-MI; Mon, 27 Apr 2020 07:15:08 +0000
Date:   Mon, 27 Apr 2020 08:15:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pass kernel pointers to the sysctl ->proc_handler method v3
Message-ID: <20200427071508.GV23230@ZenIV.linux.org.uk>
References: <20200424064338.538313-1-hch@lst.de>
 <20200426155958.GS23230@ZenIV.linux.org.uk>
 <20200427053616.GC15905@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427053616.GC15905@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 07:36:16AM +0200, Christoph Hellwig wrote:
> On Sun, Apr 26, 2020 at 04:59:58PM +0100, Al Viro wrote:
> > OK, I can live with that; further work can live on top of that, anyway.
> > How are we going to handle that?  I can put it into never-rebased branch
> > in vfs.git (#work.sysctl), so that people could pull that.
> > 
> > FWIW, I'm putting together more uaccess stuff (will probably hit -next
> > tonight or tomorrow); this would fit well there...
> 
> Sounds good to me.  The first patch isn't really needed for the series
> and could go in through the bpf tree.

OK, ##2--5 are in #work.sysctl, based at 5.7-rc1
