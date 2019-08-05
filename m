Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD481F86
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfHEOwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:52:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38375 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbfHEOwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:52:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so60326424qkk.5
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 07:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=rff+yVhXxGwa08eMX8TEGpfmgYlGV/LZ/QSpZEqGz9U=;
        b=L+btvgkOwomTVF0CGuYAo8E5Lkvgt9gMiZCwdjsUsT6QnbZWd5pnvhbESjFOPn2HU3
         V0wmSsH9vZJgK3+5Qf6GEF2EJqdd4QQK7CoaSHaH8dXLwxd0mbBdMiUM75yPCuEM+6li
         Frd06DWrluH5udhwQZz5/ZfH1O3+9KwwF7Ywt3b0JoM8TayyIbejVpXp5fybh3td+zW+
         zBRMQUKSKKC1Oq9k53eQ1MiKqYCqThHDctMqqrlR5ge89AsnzViR2tS7Jfyrs+vljkOP
         CM874qVIWHyC2+JAKWljXtlB2URtNhmT7GNDC96/G3AdZtrQ1XzuxNc9wltkyLkk5okS
         4DQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rff+yVhXxGwa08eMX8TEGpfmgYlGV/LZ/QSpZEqGz9U=;
        b=cfhk5DxWayHOR5RRRvWukw1Nc+ojLURz4pVLiARrLKEsdZjkCQQkKkEZMoNar06F1q
         TLNtRY50Mm6M9J8u65socF6BxkaaZPutcqkOqzHFgMrUlH5h8oL18D/Wt/k8Qo4q+O1a
         EpnLDvWNa4oRBacqiwNSb3iePwuJmLIb2uOQLDY6gwtWMuJCQA/4FkERpHo17SKeb6tm
         uLE+vA5tD4O4k80pEqD/CK6FLJQvjyIY6xia4oNNjbBTzVdjepeRhtsGnayTfO9W2VA3
         ngd/9BPp9Ty/AIKDARQBuEPLmtGFppU5mbgnMitJFF5W8GLxAWf6SLlhBiS2eSbjdA/F
         fUkA==
X-Gm-Message-State: APjAAAXgglgomeYW+5DXegr2oNcNm/PG8NC5Cr9hWwm/0O/I91LROHmk
        TfNksdKZUk+JoXcf3pGYLoQ=
X-Google-Smtp-Source: APXvYqxRb9F8jmnAMUqLwhcbnLGdfUtOzSHK1iAPRqZUGTu7Uhjbn5cdzodYwccClCyY3vnNOaiR/Q==
X-Received: by 2002:a37:66c2:: with SMTP id a185mr104681133qkc.38.1565016738537;
        Mon, 05 Aug 2019 07:52:18 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j6sm20704814qtl.85.2019.08.05.07.52.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 07:52:17 -0700 (PDT)
Date:   Mon, 5 Aug 2019 10:52:16 -0400
Message-ID: <20190805105216.GB31482@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, linville@redhat.com, cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
In-Reply-To: <20190805080448.GA31971@unicorn.suse.cz>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
 <20190805080448.GA31971@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal!

On Mon, 5 Aug 2019 10:04:48 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
> > Usually kernel drivers set the regs->len value to the same length as
> > info->regdump_len, which was used for the allocation. In case where
> > regs->len is smaller than the allocated info->regdump_len length,
> > we may assume that the dump contains a nested set of registers.
> > 
> > This becomes handy for kernel drivers to expose registers of an
> > underlying network conduit unfortunately not exposed to userspace,
> > as found in network switching equipment for example.
> > 
> > This patch adds support for recursing into the dump operation if there
> > is enough room for a nested ethtool_drvinfo structure containing a
> > valid driver name, followed by a ethtool_regs structure like this:
> > 
> >     0      regs->len                        info->regdump_len
> >     v              v                                        v
> >     +--------------+-----------------+--------------+-- - --+
> >     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
> >     +--------------+-----------------+--------------+-- - --+
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > ---
> 
> I'm not sure about this approach. If these additional objects with their
> own registers are represented by a network device, we can query their
> registers directly. If they are not (which, IIUC, is the case in your
> use case), we should use an appropriate interface. AFAIK the CPU ports
> are already represented in devlink, shouldn't devlink be also used to
> query their registers?

Yet another interface wasn't that much appropriate for DSA, making the stack
unnecessarily complex. In fact we are already glueing the statistics of the CPU
port into the master's ethtool ops (both physical ports are wired together).
Adding support for nested registers dump in ethtool makes it simple to
(pretty) dump CPU port's registers without too much userspace addition.

> 
> >  ethtool.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/ethtool.c b/ethtool.c
> > index 05fe05a08..c0e2903c5 100644
> > --- a/ethtool.c
> > +++ b/ethtool.c
> > @@ -1245,7 +1245,7 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
> >  
> >  	if (gregs_dump_raw) {
> >  		fwrite(regs->data, regs->len, 1, stdout);
> > -		return 0;
> > +		goto nested;
> >  	}

You're right regarding your comment about raw output. I can keep the return
0 here.

> >  
> >  	if (!gregs_dump_hex)
> > @@ -1253,7 +1253,7 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
> >  			if (!strncmp(driver_list[i].name, info->driver,
> >  				     ETHTOOL_BUSINFO_LEN)) {
> >  				if (driver_list[i].func(info, regs) == 0)
> > -					return 0;
> > +					goto nested;
> >  				/* This version (or some other
> >  				 * variation in the dump format) is
> >  				 * not handled; fall back to hex
> > @@ -1263,6 +1263,15 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
> >  
> >  	dump_hex(stdout, regs->data, regs->len, 0);
> >  
> > +nested:
> > +	/* Recurse dump if some drvinfo and regs structures are nested */
> > +	if (info->regdump_len > regs->len + sizeof(*info) + sizeof(*regs)) {
> > +		info = (struct ethtool_drvinfo *)(&regs->data[0] + regs->len);
> > +		regs = (struct ethtool_regs *)(&regs->data[0] + regs->len + sizeof(*info));
> > +
> > +		return dump_regs(gregs_dump_raw, gregs_dump_hex, info, regs);
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> 
> For raw and hex dumps, this will dump only the payloads without any
> metadata allowing to identify what are the additional blocks for the
> other related objects, i.e. where they start, how long they are and what
> they belong to. That doesn't seem very useful.


Thanks,

	Vivien
