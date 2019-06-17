Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D433248476
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfFQNtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:49:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42781 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfFQNtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:49:17 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so10700450qtk.9;
        Mon, 17 Jun 2019 06:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=94sn0DTHUZTVcQOD/9DaY0xY644jfzyvVVrkXSXjOxk=;
        b=MjjNrEfDFf4lIFoODjvXa5xbnWk2UgWK2Ao5REw+whWMiAVMsMKdA0+Woeg9SBXpBR
         BWQmHDr5qRwPGv3i7hJnBjtxa4gUIFiH90xFdK4xazv4lBQxrTWkJNuHgzhyhwyAHViT
         WzkBzi8fUxcFjZ+apRhJ9BQ0Xn7PL8NLcmuLVfJ4gQDfZIIUHOv0yPteedblTKPo4OI1
         DTqWdfSKGFTTFBCPzjYz4MHerwbTSTJq4APqK5bmtnPPJ8hH+Xe0m0gHHk1LtaRyslnB
         KsnlGkCeAIyQwZsbu1j5n3Z1pvpJH3QoOtD9s3p+pJivoKcI0qbKn2ruAB0d2ByGFm3y
         2pjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=94sn0DTHUZTVcQOD/9DaY0xY644jfzyvVVrkXSXjOxk=;
        b=IIWL46ryAhbO6jm5PELZeFt1XnIY+9kymB68jU27W8Q1MBwzNc/irE33Udjah81r4j
         qJtjVETXOme9i/x71eGDU6CLOzPFyBuKfNxeK+8fOoQ5mZkfNZGU5wYwHPJ5tJt/y5iG
         DXhWvzesQ9qsKuGH299zhEech8elAATxQGvA49+FkklTJ/3a5gYj1AaV4dgjmtJuz5Fz
         Y8PLnm9boMXtq55gsdK9glzzHsfCJgOthbwtGVlL/LSAYS78G0FKtuuUjI2JDZ6sqzU4
         n1KcYmXigr9gC6KzCWz1fqsv92ehA5jQZtw4aOHyMeCtBLEYDo+YlWwpUkIJD2MAINDf
         VSgQ==
X-Gm-Message-State: APjAAAVmcRTFwBmBVXc+khGVei04Xgw3ctJJ1h8QQ11bsNZRe3Kpyjnj
        asPcjhG+HT1m/bjaWo6uzMo=
X-Google-Smtp-Source: APXvYqzPLiSQF/+cyc2b0FL9ZuPmrVzLSE2WQMFWXzuhbk9aHBcmgjD139D+KpiigPqbWbCeyZ/laQ==
X-Received: by 2002:ac8:30a7:: with SMTP id v36mr72266752qta.119.1560779356433;
        Mon, 17 Jun 2019 06:49:16 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:ed8b:101b:c686:4add:18ab])
        by smtp.gmail.com with ESMTPSA id o71sm6216275qke.18.2019.06.17.06.49.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 06:49:15 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2E009C1BD6; Mon, 17 Jun 2019 10:49:13 -0300 (-03)
Date:   Mon, 17 Jun 2019 10:49:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-ID: <20190617134913.GL3436@localhost.localdomain>
References: <20190616153804.3604-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616153804.3604-1-hdanton@sina.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Jun 16, 2019 at 11:38:03PM +0800, Hillf Danton wrote:
> 
> Hello Syzbot
> 
> On Sat, 15 Jun 2019 16:36:06 -0700 (PDT) syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
...
> Check prio_head and bail out if it is not valid.
> 
> Thanks
> Hillf
> ----->8---
> ---
> net/sctp/stream_sched_prio.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> index 2245083..db25a43 100644
> --- a/net/sctp/stream_sched_prio.c
> +++ b/net/sctp/stream_sched_prio.c
> @@ -135,6 +135,8 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
> 	struct sctp_stream_priorities *prio, *prio_head;
> 
> 	prio_head = soute->prio_head;
> +	if (!prio_head)
> +		return;
> 
> 	/* Nothing to do if already scheduled */
> 	if (!list_empty(&soute->prio_list))
> --

Thanks but this is not a good fix for this. It will cause the stream
to never be scheduled.

The problem happens because of the fault injection that happened a bit
before the crash, in here:

int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
{
        struct sctp_stream_out_ext *soute;

        soute = kzalloc(sizeof(*soute), GFP_KERNEL);
        if (!soute)
                return -ENOMEM;
        SCTP_SO(stream, sid)->ext = soute;  <---- [A]

        return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
                      ^^^^^^^^^^^^---- [B] failed
}

This causes the 1st sendmsg to bail out with the error. When the 2nd
one gets in, it will:

sctp_sendmsg_to_asoc()
{
...
        if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
                                                                 ^^^^^--- [C]
                err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
                if (err)
                        goto err;
        }

[A] leaves ext initialized, despite the failed in [B]. Then in [C], it
will not try to initialize again.

We need to either uninitialize ->ext as error handling for [B], or
improve the check on [C].

syzbot++ once again.

  Marcelo
