Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4B4E8119
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 14:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiCZNhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 09:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiCZNhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 09:37:18 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B08288ABA;
        Sat, 26 Mar 2022 06:35:40 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 75891C01F; Sat, 26 Mar 2022 14:35:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648301736; bh=caxiXjBYa3uItnmO98ZarywbPNZq6fbyhtrusK+UKag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TsOpIa+idW73rTSBcViqBJ2wFFxhwbHtcv95nfEKD6Cg9dan7uGXohF5Ee0HpvIM+
         reazWyC+GPXZvTJQIL6TmJu7JDjJje/DKUz8JSRuFzCH7/smiFyT1BNsbTJg8RLwcU
         2QhFxEN+ZtDLlCoZCsMEPHlYJcBbAORl/c/x0+JXTZ3qqE2e8CaCc+fbZbQQW/f27M
         ZR2xcO5NC9WUtpmDhai20AzREC/AntaWU3n9zAwYElOBQyTpLp0xP4ZFOkIkpIoQb1
         P4nKsj+2IrRPbBCcSu9s+JbHDYmBlSaC4ZqLvAnzerhqWSg9CaXW6TbnXX0Y8QwXrb
         kxmdU/sO0Zs9g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id A3557C009;
        Sat, 26 Mar 2022 14:35:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648301735; bh=caxiXjBYa3uItnmO98ZarywbPNZq6fbyhtrusK+UKag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZUd05sIczudj0TkfECNQJQgSgITQtJDaiyXu62kBTdBMmASCPjErzlTlMdo3EK5mu
         UvYmPBhx6gBAn9GMWE+OGZFdEsH6CHQ4lrNIsmgXCj2RPljEYaVjnBiGt0j8uRqdSQ
         EIHyE8ZLzMur20q7NULrkm/MeaXpAWUM11Nn6jU8Ma1nJeow5dBwiVEfLM1FpmH4Ut
         x9dwPGHqgJzyfrwGJWCv9X9TwIqWxH7zzdt9OJprtjJmFWFH64//TFdTJbo6fuhPBZ
         JlvGD8gLB9gpyTQmW45P8detTSSMa2vyCBZjfM/B/oKFghztPB+ySwZhpRXPfFja4x
         5lRBQXtqX2CIg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id d9f9648a;
        Sat, 26 Mar 2022 13:35:29 +0000 (UTC)
Date:   Sat, 26 Mar 2022 22:35:14 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>
Subject: Re: 9p fscache Duplicate cookie detected (Was: [syzbot] WARNING in
 p9_client_destroy)
Message-ID: <Yj8WkjT+MsdFIfwr@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3597833.OkAhqpS0b6@silver>
 <Yj8F6sQzx6Bvy+aZ@codewreck.org>
 <2582025.XdajAv7fHn@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2582025.XdajAv7fHn@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(+David Howells in Cc as he's knows how that works better than me;
 -syzbot lists as it doesn't really concern this bug)

Christian Schoenebeck wrote on Sat, Mar 26, 2022 at 01:36:31PM +0100:
> BTW, another issue that I am seeing for a long time affects the fs-cache: When
> I use cache=mmap then things seem to be harmless, I periodically see messages
> like these, but that's about it:
> 
> [90763.435562] FS-Cache: Duplicate cookie detected
> [90763.436514] FS-Cache: O-cookie c=00dcb42f [p=00000003 fl=216 nc=0 na=0]
> [90763.437795] FS-Cache: O-cookie d=0000000000000000{?} n=0000000000000000
> [90763.440096] FS-Cache: O-key=[8] 'a7ab2c0000000000'
> [90763.441656] FS-Cache: N-cookie c=00dcb4a7 [p=00000003 fl=2 nc=0 na=1]
> [90763.446753] FS-Cache: N-cookie d=000000005b583d5a{9p.inode} n=00000000212184fb
> [90763.448196] FS-Cache: N-key=[8] 'a7ab2c0000000000'

hm, fscache code shouldn't be used for cache=mmap, I'm surprised you can
hit this...

> The real trouble starts when I use cache=loose though, in this case I get all
> sorts of misbehaviours from time to time, especially complaining about invalid
> file descriptors.

... but I did encouter these on cache=loose/fscache, although I hadn't
noticed any bad behaviour such as invalid file descriptors.

> Any clues?

Since I hadn't noticed real harm I didn't look too hard into it, I have
a couple of ideas:
- the cookie is just a truncated part of the inode number, it's possible
we get real collisions because there are no guarantees there won't be
identical inodes there.
In particular, it's trivial to reproduce by exporting submounts:

## on host in export directory
# mount -t tmpfs tmpfs m1
# mount -t tmpfs tmpfs m2
# echo foo > m1/a
# echo bar > m2/a
# ls -li m1 m2
m1:
total 4
2 -rw-r--r-- 1 asmadeus users 4 Mar 26 22:23 a

m2:
total 4
2 -rw-r--r-- 1 asmadeus users 4 Mar 26 22:23 a

## on client
# /mnt/t/m*/a
foo
bar
FS-Cache: Duplicate cookie detected
FS-Cache: O-cookie c=0000099a [fl=4000 na=0 nA=0 s=-]
FS-Cache: O-cookie V=00000006 [9p,tmp,]
FS-Cache: O-key=[8] '0200000000000000'
FS-Cache: N-cookie c=0000099b [fl=0 na=0 nA=0 s=-]
FS-Cache: N-cookie V=00000006 [9p,tmp,]
FS-Cache: N-key=[8] '0200000000000000'


But as you can see despite the warning the content is properly
different, and writing also works, so this probably isn't it... Although
the fscache code we're using is totally different -- your dmesg output
is from the "pre-netfs" code, so that might have gotten fixed as a side
effect?


- lifecycle différence between inode and fscache entry.
David pushed a patch a few years back to address this but it looks like
it never got merged:
https://lore.kernel.org/lkml/155231584487.2992.17466330160329385162.stgit@warthog.procyon.org.uk/

the rationale is that we could evict the inode then reallocate it, and
it'd generate a new fscache entry with the same key before the previous
fscache entry had been freed.
I'm not sure if that got fixed otherwise and it might not be possible
anymore, I didn't follow that, but given 


 - some other bug...

If you have some kind of reproducer of invalid filedescriptor or similar
errors I'd be happy to dig a bit more, I don't particularly like all
aspect of our cache model but it's not good if it corrupts things.

-- 
Dominique
