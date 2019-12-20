Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779E5128057
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLTQGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:06:04 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36113 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTQGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:06:04 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so5162507pgc.3;
        Fri, 20 Dec 2019 08:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LGfw/ABfWG44S99dqNjFh7GtGRP7EqyTNmaTlSCAxUg=;
        b=rons7KyIPEHNTL/N4SxJ2hN2OFbBMQtGxo8h2FuwtbZvEsEL0kBtgIGmZshLGSiWDg
         mbvPeYAQ/fg77L2oA3SiVkFm5F4ucmmyl2G+l4dtRx10A0gikel1DdfPuvYqD9kLrZVj
         Vat6/k1CjBcVz8y4xBlasZjwDQUhhi/jQcfqD5vhEI1Qnts8Li7frbrgdzJFVfkaDA3R
         mPFUvTHkwWJELM/JPBbRuHmDQNSuKxDaDlmr9A+Zd3U2vXpvCI14rg46HQS/Py6C0LDr
         CXdfyuDqjn93GfqKdlERIADxH3XiCw1hjmFS4uTANHYkWAGbkfYMDqH/Cryo7hh7sPs4
         QBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LGfw/ABfWG44S99dqNjFh7GtGRP7EqyTNmaTlSCAxUg=;
        b=gdsoQyoPtz/U3NjrThgJX/dkMYiFiKiy46TvGKn0IgI21CmxgqSr8gkCR2Oon8Gtsc
         vxefdFaKW7OlWCorvNL9k3EZ1DuzWOZgNv9KXECxKvPZGCJZGftXrE8VqJpoCBSxRfN6
         JM/skg8U8Acy8yGod9hFZgwDVdL9RBRu3pjvdq8PHjeuEtXDI5q3GEvwNAxyvFY+7+XV
         TqTh/y2Z3Zn0dWUb99MGFqNkUDEtQE8Hefq7B0ETKU2QXrXjJV0zPuQcIBSy6NWh8uyR
         wg9u2QaXGq/qPDJhAE9jGwo/jsO2owp96Vuw5WoKggErOHdX02D/K3Odc5xJXo6vg9h3
         ptgA==
X-Gm-Message-State: APjAAAXoyPvbX/2H2lDFKvML2QD/7nGm7g5FLdnpdm4dAx5beQRtvGZj
        QNEdz7iwtu6cyEhuvv8pe7Y=
X-Google-Smtp-Source: APXvYqzlixHZOELXQc/0KmNzXrImB3d8Haci6RRW4JwMnGEVrlK0cx6fXDzpc1YV0xrS+z2zYs7/sw==
X-Received: by 2002:a65:518b:: with SMTP id h11mr15462937pgq.133.1576857963178;
        Fri, 20 Dec 2019 08:06:03 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:b9c8:9c5e:a64b:e068:9fbd])
        by smtp.gmail.com with ESMTPSA id s22sm13054365pfe.90.2019.12.20.08.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 08:06:02 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6E97FC161F; Fri, 20 Dec 2019 13:05:59 -0300 (-03)
Date:   Fri, 20 Dec 2019 13:05:59 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: general protection fault in sctp_stream_free (2)
Message-ID: <20191220160559.GD5058@localhost.localdomain>
References: <0000000000001b6443059a1a815d@google.com>
 <20191220152810.GI4444@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220152810.GI4444@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 12:28:10PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Dec 19, 2019 at 07:45:09PM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    6fa9a115 Merge branch 'stmmac-fixes'
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10c4fe99e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=216dca5e1758db87
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9a1bc632e78a1a98488b
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178ada71e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f23a6e00000
> > 
> > The bug was bisected to:
> > 
> > commit 951c6db954a1adefab492f6da805decacabbd1a7
> > Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Date:   Tue Dec 17 01:01:16 2019 +0000
> > 
> >     sctp: fix memleak on err handling of stream initialization
> 
> Ouch... this wasn't a good fix.
> When called from sctp_stream_init(), it is doing the right thing.
> But when called from sctp_send_add_streams(), it can't free the
> genradix. Ditto from sctp_process_strreset_addstrm_in().

Tentative fix. I'll post after additional tests.

--8<--

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6a30392068a0..c1a100d2fed3 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,10 +84,8 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret) {
-		genradix_free(&stream->out);
+	if (ret)
 		return ret;
-	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -102,10 +100,8 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret) {
-		genradix_free(&stream->in);
+	if (ret)
 		return ret;
-	}
 
 	stream->incnt = incnt;
 	return 0;
@@ -123,7 +119,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 	 * a new one with new outcnt to save memory if needed.
 	 */
 	if (outcnt == stream->outcnt)
-		goto in;
+		goto handle_in;
 
 	/* Filter out chunks queued on streams that won't exist anymore */
 	sched->unsched_all(stream);
@@ -132,24 +128,28 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out;
+		goto out_err;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
-in:
+handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
 		goto out;
 
 	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret) {
-		sched->free(stream);
-		genradix_free(&stream->out);
-		stream->outcnt = 0;
-		goto out;
-	}
+	if (ret)
+		goto in_err;
+
+	goto out;
 
+in_err:
+	sched->free(stream);
+	genradix_free(&stream->in);
+out_err:
+	genradix_free(&stream->out);
+	stream->outcnt = 0;
 out:
 	return ret;
 }
