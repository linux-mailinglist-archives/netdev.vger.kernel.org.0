Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5643B573E3D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiGMUx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbiGMUx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:53:26 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF43192C;
        Wed, 13 Jul 2022 13:53:20 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 63EB2C021; Wed, 13 Jul 2022 22:53:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657745599; bh=K0t2nQU6Z9i8Kte1FwmB5MsugxFnhvvJtm4r22yivn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ROBZZwNhKOqYRshQ0V66ALhf70JVq/mHM4pLKjyu7mtkyMFl50hYnNoyVCGBD70LV
         1oPmF7WBajykABw9oAWi0XGMlfqT+mQAJPMC2GiUrvfIgnl18LM0Eeph284cNeICy0
         dcx3UlHeO3Q++ZFQ4BhDvc+Bhp3f9MK0xQnglTATZIPc7Ly35QQatY34DxjYYjCsIX
         MLDTxeDwGXA6N+zfztQSzG1/fTIpHuUH4sH/5UuGtsYXwFqStxFjzlcr8AcjvPKVdk
         wpLAvClMb8NmiEj9Rs6QOtCt4ybtLugdV5W27c+eTPiqxrOak2iZyPBF/U2lkKPWn4
         lSgXlw0++x2NA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id AC857C009;
        Wed, 13 Jul 2022 22:53:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657745597; bh=K0t2nQU6Z9i8Kte1FwmB5MsugxFnhvvJtm4r22yivn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWx3aUgz3RJn6I3fyGo4g4XkNVwPxTIXuTAVAkJGkM9QQOQPPuS+EDvLQSCWnkwxj
         crBN0yPH3L+K0eTnZzJFCPsqQcV49PnDQ05LV86byDP6iqCKCBNW9bc+HjcctdADjO
         pp1IpjMN/fZTS/2tSv4s0GxljsnH44yxMfZLwUx/NaRykfHQjfhJUR8vZAMGg0VuWa
         AhTsoF1yTzQf6g4+WzWf+1gC9ubdalHdlMjehppENHaN2cuXqzjzg7lasvSGxTOu8r
         0SGhLW0KGWc6LKd14Q1D8APRj5gWN4ga79FWr9kegDpFrYaldrM4DqOW90UIVP5ad2
         j6NvqBgyTtK5g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 9a196f67;
        Wed, 13 Jul 2022 20:53:11 +0000 (UTC)
Date:   Thu, 14 Jul 2022 05:52:56 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 10/11] net/9p: add p9_msg_buf_size()
Message-ID: <Ys8wqPbA5eogtvmG@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <2ade510b2e67a30c1064bcd7a8b6c73e6777b9ed.1657636554.git.linux_oss@crudebyte.com>
 <Ys6ei46QxeqvqOSe@codewreck.org>
 <5564296.oo812IJUPE@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5564296.oo812IJUPE@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, Jul 13, 2022 at 03:06:01PM +0200:
> > > +	case P9_TWALK:
> > > +		BUG_ON(strcmp("ddT", fmt));
> > > +		va_arg(ap, int32_t);
> > > +		va_arg(ap, int32_t);
> > > +		{
> > > +			uint i, nwname = max(va_arg(ap, int), 0);
> > 
> > I was about to say that the max is useless as for loop would be cut
> > short, but these are unsigned... So the code in protocol.c p9pdu_vwritef
> > 'T' has a bug (int cast directly to uint16): do you want to fix it or
> > shall I go ahead?
> 
> I'd either send a separate patch today for fixing 'T', or if you want
> to handle it by yourself, then just go ahead.

I'd appreciate if you have time, doesn't make much difference though

> > > +	case P9_TCREATE:
> > > +		BUG_ON(strcmp("dsdb?s", fmt));
> > > +		va_arg(ap, int32_t);
> > > +		{
> > > +			const char *name = va_arg(ap, const char *);
> > > +			if ((c->proto_version != p9_proto_2000u) &&
> > > +			    (c->proto_version != p9_proto_2000L))
> > 
> > (I don't think 9p2000.L can call TCREATE, but it doesn't really hurt
> > either)
> 
> Yes, Tcreate is only 9p2000 and 9p2000.u. Semantically this particular
> check here means "if proto == 9p.2000". I can't remember anymore why I
> came up with this inverted form here. I'll change it to "if
> (c->proto_version == p9_proto_legacy)".

Sounds good.

> > > +	case P9_TRENAMEAT:
> > if we have trenameat we probably want trename, tunlinkat as well?
> > What's your criteria for counting individually vs slapping 8k at it?
> > 
> > In this particular case, oldname/newname are single component names
> > within a directory so this is capped at 2*(4+256), that could easily fit
> > in 4k without bothering.
> 
> I have not taken the Linux kernel's current filename limit NAME_MAX
> (255) as basis, in that case you would be right. Instead I looked up
> what the maximum filename length among file systems in general was,
> and saw that ReiserFS supports up to slightly below 4k? So I took 4k
> as basis for the calculation used here, and the intention was to make
> this code more future proof. Because revisiting this code later on
> always takes quite some time and always has this certain potential to
> miss out details.

hmm, that's pretty deeply engrained into the VFS but I guess it might
change eventually, yes.

I don't mind as long as we're consistent (cf. unlink/mkdir below), in
practice measuring doesn't cost much.

> Independent of the decision; additionally it might make sense to add
> something like:
> 
> #if NAME_MAX > 255
> # error p9_msg_buf_size() needs adjustments
> #endif

That's probably an understatement but I don't mind either way, it
doesn't hurt.


> > > +		BUG_ON(strcmp("dsds", fmt));
> > > +		va_arg(ap, int32_t);
> > > +		{
> > > +			const char *oldname = va_arg(ap, const char *);
> > > +			va_arg(ap, int32_t);
> > > +			{
> > > +				const char *newname = va_arg(ap, const char *);
> > 
> > (style nitpick) I don't see the point of nesting another level of
> > indentation here, it feels cleaner to declare oldname/newname at the
> > start of the block and be done with it.
> 
> Because  va_arg(ap, int32_t);  must remain between those two
> declarations, and I think either the compiler or style check script
> was barking at me. But I will recheck, if possible I will remove the
> additional block scope here.

Yes, I think it'd need to look like this:

	case foo:
		BUG_ON(...)
		va_arg(ap, int32_t);
		{
			const char *oldname = va_arg(ap, const char *);
			const char *newname;
			va_arg(ap, int32_t);
			newname = va_arg(ap, const_char *);
			...
		}
or
		{
			const char *oldname, *newname;
			oldname = va_arg(ap, const char *);
			va_arg(ap, int32_t)
			newname = va_arg(ap, const char *);
			...
		}
		
I guess the later is slightly easier on the eyes


> > > +	/* small message types */
> > 
> > ditto: what's your criteria for 4k vs 8k?
> 
> As above, 4k being the basis for directory entry names, plus PATH_MAX
> (4k) as basis for maximum path length.
> 
> However looking at it again, if NAME_MAX == 4k was assumed exactly,
> then Tsymlink would have the potential to exceed 8k, as it has name[s]
> and symtgt[s] plus the other fields.

yes.


> > > +	case P9_TSTAT:
> > this is just fid[4], so 4k is more than enough
> 
> I guess that was a typo and should have been Twstat instead?

Ah, had missed this because 9p2000.L's version of stat[n] is fixed size.
Sounds good.

> > > +	case P9_RSTAT:
> > also fixed size 4+4+8+8+8+8+8+8+4 -- fits in 4k.
> 
> Rstat contains stat[n] which in turn contains variable-length string
> fields (filename, owner name, group name)

Right, same mistake.

> 
> > > +	case P9_TSYMLINK:
> > that one has symlink target which can be arbitrarily long (filesystem
> > specific, 4k is the usual limit for linux but some filesystem I don't
> > know might handle more -- it might be worth going through the trouble of
> > going through it.
> 
> Like mentioned above, if exactly NAME_MAX == 4k was assumed, then
> Tsymlink may even be >8k.

And all the other remarks are 'yes if we assume bigger NAME_MAX' -- I'm
happy either way.


> > rest all looks ok to me.
> 
> Thanks for the review! I know, that's really a dry patch to look
> at. :)

Thanks for writing it in the first place ;)

--
Dominique
