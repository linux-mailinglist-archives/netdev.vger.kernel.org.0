Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3607A4A2D9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfFRNyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:54:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37520 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfFRNyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:54:16 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so8586358qkl.4;
        Tue, 18 Jun 2019 06:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vc9mCvqhg14Hd656oz7rVCLsRuNfaZG35kttzdMn7no=;
        b=FMG6b0lf8NdW8PUorkYAyDG33FYO/6FcDb5i2g2Fw2gRsdwdtrneTlUjc2Ja6JeTDK
         U/JLSbnfxE8/viejJ4HvzcrcQAk++CvrTNT8pj8NpmBn0CCg1nTLoaVjQnWUeqJaxTff
         v5GtS1WbawrJwbGfOJLwZW5dRGFSjMIXlMQLSBEhbifPeUkZfNtRgQByQasHaFlaiIbR
         wczeOOc14xE598lG3TInG3k+4fh8Uj/zLZjZ8n57RiDyNhyE37ba35y6zYvWaC5PXCFr
         jgPr8/geDKoLDZGWtyI+g1lHlMdqimd9aSOzjmyzpFaIWRhk6fsfHDwxY3dadNbTjFI6
         alCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vc9mCvqhg14Hd656oz7rVCLsRuNfaZG35kttzdMn7no=;
        b=YSqPr3tOV1HDumP6TkqzJfBLeYgYOSiCyunU1reJ2Dw+E29SooVBowLdtnthaW9vLe
         XlADlUpK/QZqNvPRldD2vtVbjF//8kBQYQyKQho20ey2kXo5IEFYdd41OkGv1vRg0Sd6
         1EzZsBLzE6q8F6NWxosipGabNhbaXyzjiTZQz2GBHItPBup6H9909Zm1wcmgeFNfYzNE
         r0TZPoBuqqaympOrkYAQ+nr8fYSqq1GY7vNbCam3CjAfuNf58heQn6J9vBLNqQicFWtF
         EEjcE5pXNEUzjKkQZ4DUUXhsXCrQYBTdEWJh8Pz6/ttL0N/aOtZweWnQaJPRFY+ULLTP
         0Tbw==
X-Gm-Message-State: APjAAAUq1cYvlaP7sNsHsdx6G0ByP5Fdmc8A+OjiXG1maeP7C/QPdLo+
        zPjPgi3muQrTkLaoxiOgrk4=
X-Google-Smtp-Source: APXvYqzUBjmfRuwTztl7oolOy8wRUCcpioC1pJW4wKOT6tgEnM7jpWavhL2sUmau6pqLADSYoB6qvQ==
X-Received: by 2002:a37:ef03:: with SMTP id j3mr54208784qkk.233.1560866055076;
        Tue, 18 Jun 2019 06:54:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:ed8b:101b:c686:4add:18ab])
        by smtp.gmail.com with ESMTPSA id r39sm10985399qtc.87.2019.06.18.06.54.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:54:14 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DCCF0C0FFC; Tue, 18 Jun 2019 10:54:11 -0300 (-03)
Date:   Tue, 18 Jun 2019 10:54:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "vyasevich@gmail.com" <vyasevich@gmail.com>
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-ID: <20190618135411.GN3436@localhost.localdomain>
References: <20190618080401.11768-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618080401.11768-1-hdanton@sina.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 18, 2019 at 04:04:01PM +0800, Hillf Danton wrote:
> 
> Hello Marcelo
> 
> On Mon, 17 Jun 2019 22:43:38 +0800 Marcelo Ricardo Leitner wrote:
> > On Mon, Jun 17, 2019 at 10:49:13AM -0300, Marcelo Ricardo Leitner wrote:
> > > Hi,
> > >
> > > On Sun, Jun 16, 2019 at 11:38:03PM +0800, Hillf Danton wrote:
> > > >
> > > > Hello Syzbot
> > > >
> > > > On Sat, 15 Jun 2019 16:36:06 -0700 (PDT) syzbot wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following crash on:
> > > > >
> > > ...
> > > > Check prio_head and bail out if it is not valid.
> > > >
> > > > Thanks
> > > > Hillf
> > > > ----->8---
> > > > ---
> > > > net/sctp/stream_sched_prio.c | 2 ++
> > > > 1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> > > > index 2245083..db25a43 100644
> > > > --- a/net/sctp/stream_sched_prio.c
> > > > +++ b/net/sctp/stream_sched_prio.c
> > > > @@ -135,6 +135,8 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
> > > > 	struct sctp_stream_priorities *prio, *prio_head;
> > > >
> > > > 	prio_head = soute->prio_head;
> > > > +	if (!prio_head)
> > > > +		return;
> > > >
> > > > 	/* Nothing to do if already scheduled */
> > > > 	if (!list_empty(&soute->prio_list))
> > > > --
> > >
> > > Thanks but this is not a good fix for this. It will cause the stream
> > > to never be scheduled.
> > >
> Thanks very much for the light you are casting.
> 
> > > The problem happens because of the fault injection that happened a bit
> > > before the crash, in here:
> > >
> > > int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
> > > {
> > >         struct sctp_stream_out_ext *soute;
> > >
> > >         soute = kzalloc(sizeof(*soute), GFP_KERNEL);
> > >         if (!soute)
> > >                 return -ENOMEM;
> > >         SCTP_SO(stream, sid)->ext = soute;  <---- [A]
> > >
> > >         return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> > >                       ^^^^^^^^^^^^---- [B] failed
> > > }
> > >
> Eagle eye.
> 
> > > This causes the 1st sendmsg to bail out with the error. When the 2nd
> > > one gets in, it will:
> > >
> > > sctp_sendmsg_to_asoc()
> > > {
> > > ...
> > >         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
> > >                                                                  ^^^^^--- [C]
> > >                 err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
> > >                 if (err)
> > >                         goto err;
> > >         }
> > >
> > > [A] leaves ext initialized, despite the failed in [B]. Then in [C], it
> > > will not try to initialize again.
> > >
> Fairly concise.
> 
> > > We need to either uninitialize ->ext as error handling for [B], or
> > > improve the check on [C].
> > 
> > The former one, please. This should be enough (untested):
> > 
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index 93ed07877337..25946604af85 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -153,13 +153,20 @@ int sctp_stream_init(struct sctp_stream *stream, __u1=
> > 6 outcnt, __u16 incnt,
> >  int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
> >  {
> >  	struct sctp_stream_out_ext *soute;
> > +	int ret;
> > 
> >  	soute = kzalloc(sizeof(*soute), GFP_KERNEL);
> >  	if (!soute)
> >  		return -ENOMEM;
> >  	SCTP_SO(stream, sid)->ext = soute;
> > 
> > -	return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> > +	ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> > +	if (ret) {
> > +		kfree(SCTP_SO(stream, sid)->ext);
> > +		SCTP_SO(stream, sid)->ext = NULL;

[D]

> > +	}
> > +
> > +	return ret;
> >  }
> > 
> Definitely nice.
> 
> >  void sctp_stream_free(struct sctp_stream *stream)
> > 
> Hmmm, ->ext will be valid, provided it is loaded with a valid slab in
> sctp_stream_init_ext() regardless of whether sid is successfully
> initialised, until it is released, for instance, in sctp_stream_free(),
> and based on that assumption, it looks hardly likely that ->ext has a
> chance to create a gfp in sctp_sched_prio_sched().

I'm not sure I follow you. Anyway, with the patch above, after calling
sctp_stream_init_ext() ->ext will be either completely valid, or it
will not be present at all as it is seting ->ext to NULL if sid
initialization ended up failing.

  Marcelo
