Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB901485DD
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfFQOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:43:37 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44611 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfFQOng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:43:36 -0400
Received: by mail-qk1-f194.google.com with SMTP id p144so6275882qke.11;
        Mon, 17 Jun 2019 07:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tM4hoxeAgaP+/Vpct6XZW9tfikLT2DbVn921Xun18eY=;
        b=edDnf1zaHfpFOXrOPGVhqVe/oTUWzIpiJ3aDd/odd1yU9H6hDy1E7LQqs5znG9Bnhf
         rGlbyBnzC+pLOSHPXkUToRoL62nINSOjKmJhyHYqGr5IIlJX0OH4AQJ0UJbb+/bmvKam
         SNu7Jnt0SEL2a6U0h4oePiv5yoRwVCcEHS6Lt41Z38F5xm0GxsizToeap8p0hUIhdqHC
         b22iPrlDPUyAPPoB7pn2wnwxkFDsjQRDb6PqR/qJ6KuL/8jaIr5b6aCeLHQIcXJcrwG5
         VWNk00hg7D98dsr2HHfoy3I5KhFjL8l9aNJMnf+5r3McvY545Tso0hbTQccwbyMf7D4O
         Yq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tM4hoxeAgaP+/Vpct6XZW9tfikLT2DbVn921Xun18eY=;
        b=b/uYeveWqpzh7aNnbv9Hx77Wh8rDyuqY6dYEoaceqYNMoMNkXhHMU1z63lhOF8peU8
         EV9e8SPBALxmDuMoAHFOftYa3VEGnGDhjGJn6arEIOfcUy3YEdO5HmwlFcCN0Fk3IgmB
         3nztf9WI4SMghxaOu+E4ZlY0BCJsm05LP6+uI79xrnQMrq3OgNNt5NlJfl9ZWUpvXx4U
         +Y02VNBIeW7IlqjLgcbxVwuxCsIUKd360dWIi+gkGrYzl3WdglLBWzU4AmiQODCMVxXf
         zNVD6zBFbPfP6uFhGcHZyK424J6CEgJ+Nblt50U3WQZH+E3xODPN2GbTRhBEHt+5tZhk
         NfSA==
X-Gm-Message-State: APjAAAVyG/lHypQCimKLNz0SSOFIHoBLhm9bLH0czGMhZ4a79uxzye/A
        /FIgemA3p6bOmKpysRrtwjQ=
X-Google-Smtp-Source: APXvYqyaPXsO66e1Ln+iRy56I/iqNuPfEpXABoQu52+wf2UaSaBrFOrritp8w7dHTuCgikaoBrxqqQ==
X-Received: by 2002:a37:7786:: with SMTP id s128mr3297499qkc.345.1560782614987;
        Mon, 17 Jun 2019 07:43:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:ed8b:101b:c686:4add:18ab])
        by smtp.gmail.com with ESMTPSA id g5sm8298955qta.77.2019.06.17.07.43.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 07:43:34 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E0D95C1BD6; Mon, 17 Jun 2019 11:43:31 -0300 (-03)
Date:   Mon, 17 Jun 2019 11:43:31 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-ID: <20190617144331.GE3500@localhost.localdomain>
References: <20190616153804.3604-1-hdanton@sina.com>
 <20190617134913.GL3436@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617134913.GL3436@localhost.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 10:49:13AM -0300, Marcelo Ricardo Leitner wrote:
> Hi,
> 
> On Sun, Jun 16, 2019 at 11:38:03PM +0800, Hillf Danton wrote:
> > 
> > Hello Syzbot
> > 
> > On Sat, 15 Jun 2019 16:36:06 -0700 (PDT) syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following crash on:
> > > 
> ...
> > Check prio_head and bail out if it is not valid.
> > 
> > Thanks
> > Hillf
> > ----->8---
> > ---
> > net/sctp/stream_sched_prio.c | 2 ++
> > 1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> > index 2245083..db25a43 100644
> > --- a/net/sctp/stream_sched_prio.c
> > +++ b/net/sctp/stream_sched_prio.c
> > @@ -135,6 +135,8 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
> > 	struct sctp_stream_priorities *prio, *prio_head;
> > 
> > 	prio_head = soute->prio_head;
> > +	if (!prio_head)
> > +		return;
> > 
> > 	/* Nothing to do if already scheduled */
> > 	if (!list_empty(&soute->prio_list))
> > --
> 
> Thanks but this is not a good fix for this. It will cause the stream
> to never be scheduled.
> 
> The problem happens because of the fault injection that happened a bit
> before the crash, in here:
> 
> int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
> {
>         struct sctp_stream_out_ext *soute;
> 
>         soute = kzalloc(sizeof(*soute), GFP_KERNEL);
>         if (!soute)
>                 return -ENOMEM;
>         SCTP_SO(stream, sid)->ext = soute;  <---- [A]
> 
>         return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
>                       ^^^^^^^^^^^^---- [B] failed
> }
> 
> This causes the 1st sendmsg to bail out with the error. When the 2nd
> one gets in, it will:
> 
> sctp_sendmsg_to_asoc()
> {
> ...
>         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
>                                                                  ^^^^^--- [C]
>                 err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
>                 if (err)
>                         goto err;
>         }
> 
> [A] leaves ext initialized, despite the failed in [B]. Then in [C], it
> will not try to initialize again.
> 
> We need to either uninitialize ->ext as error handling for [B], or
> improve the check on [C].

The former one, please. This should be enough (untested):

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 93ed07877337..25946604af85 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -153,13 +153,20 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
 {
 	struct sctp_stream_out_ext *soute;
+	int ret;
 
 	soute = kzalloc(sizeof(*soute), GFP_KERNEL);
 	if (!soute)
 		return -ENOMEM;
 	SCTP_SO(stream, sid)->ext = soute;
 
-	return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
+	ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
+	if (ret) {
+		kfree(SCTP_SO(stream, sid)->ext);
+		SCTP_SO(stream, sid)->ext = NULL;
+	}
+
+	return ret;
 }
 
 void sctp_stream_free(struct sctp_stream *stream)

