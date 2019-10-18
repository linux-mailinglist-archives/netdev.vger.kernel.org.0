Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D477BDD177
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfJRWBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:01:18 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42625 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfJRWBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 18:01:17 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so2171147plj.9;
        Fri, 18 Oct 2019 15:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XK7KVcDbCTN0IO4XQWLIT2UP5RymllsGZ2OhbI8nqu8=;
        b=C6eIufveBw6ZYR5miBZviDUn5832235US0qTa09STlzDINydw9xMw96zWK6+vkuniU
         d+3CQylADjMRIgqe/dTa/9xiNzAgQnIV64Dnq5X9Xix5T1Q3MeTOU7t5dBsPMsmUwKOk
         BBoE3myVkFUqFhRK4v5b3vDaeRebSlqnr7PzLSfsq5/PbsWIwqVKfWIhysQ85VmBnHV9
         k6fEYVZWe//7b2EQC2RGQsNWZSDzkF6Sswiqd3uJJmllGGoDwnV7ub2r94nY+h3kUG8c
         bT2c2d24kmiShHmxf0DT23YcC+/lbkOkZq2ZPv22P1fQIpAnMfsIKEFfI+v9S6Kg1mwa
         /Q1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XK7KVcDbCTN0IO4XQWLIT2UP5RymllsGZ2OhbI8nqu8=;
        b=ixw+Sp5zAPZS/xspMDg4etmrN+3SKoTsgEVn7nfHR9c/TwJbDR0V9bpl3IzBYBK5da
         Iz2deF8FkEy3Q6sA0/R0eWbE8UENH90ad5vt16IIJuHPNAPqZdUSyqWK18pYXIiO7/K4
         c2LP16RORvbBauuq5thAvQG8m6P1WBvZK7Rsv7ifx8ZvGKTOHIYEoZjR9arjByNfNuJT
         mcAgNd2U6FheWUhj8P1LyZiXlcU/oKuoCaneorL1WCV7QdrGi2ljn3FWRD4QMWWhsZJY
         fKnLTCmSQK+ByWEx04S33ZS5x4JkJY+4qYJl3liVja96SbfmGU7Nmkg5kKtpYJ+IPxZ6
         zRsA==
X-Gm-Message-State: APjAAAXGuc02Jh1i1EOgFVxNswUZy/yCfiF+lWuszski6LbaYuZwN6Xz
        fhNyYvb5K1jAH2YTdu4oQg0=
X-Google-Smtp-Source: APXvYqyjy6vKUg95VkLGXpdWDrpPIMOi9nx+W01MtJUn4j424Fckwwy1aeVPmA4sOh5sfxNeE9e8Rw==
X-Received: by 2002:a17:902:aa86:: with SMTP id d6mr12507953plr.268.1571436076354;
        Fri, 18 Oct 2019 15:01:16 -0700 (PDT)
Received: from localhost ([131.252.137.171])
        by smtp.gmail.com with ESMTPSA id z13sm8622815pfq.121.2019.10.18.15.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 15:01:15 -0700 (PDT)
Date:   Fri, 18 Oct 2019 15:01:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     andriin@fb.com, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5daa362b4c9b6_68182abd481885b455@john-XPS-13-9370.notmuch>
In-Reply-To: <20191018194425.GI26267@pc-63.home>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <20191018194425.GI26267@pc-63.home>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On Fri, Oct 18, 2019 at 07:54:26AM -0700, John Fastabend wrote:
> > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > kprobes programs on older kernels.
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.c |   81 +++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 73 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index fcea6988f962..12b3105d112c 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5005,20 +5005,89 @@ static int determine_uprobe_retprobe_bit(void)
> >  	return parse_uint_from_file(file, "config:%d\n");
> >  }
> >  
> > +static int use_kprobe_debugfs(const char *name,
> > +			      uint64_t offset, int pid, bool retprobe)
> 
> offset & pid unused?

Well pid should be dropped and I'll add support for offset. I've not
being using offset so missed it here.

> 
> > +{
> > +	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> > +	int fd = open(file, O_WRONLY | O_APPEND, 0);
> > +	char buf[PATH_MAX];
> > +	int err;
> > +
> > +	if (fd < 0) {
> > +		pr_warning("failed open kprobe_events: %s\n",
> > +			   strerror(errno));
> > +		return -errno;
> > +	}
> > +
> > +	snprintf(buf, sizeof(buf), "%c:kprobes/%s %s",
> > +		 retprobe ? 'r' : 'p', name, name);
> > +
> > +	err = write(fd, buf, strlen(buf));
> > +	close(fd);
> > +	if (err < 0)
> > +		return -errno;
> > +	return 0;
> > +}
> > +
> >  static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> >  				 uint64_t offset, int pid)
> >  {
> >  	struct perf_event_attr attr = {};
> >  	char errmsg[STRERR_BUFSIZE];
> > +	uint64_t config1 = 0;
> >  	int type, pfd, err;
> >  
> >  	type = uprobe ? determine_uprobe_perf_type()
> >  		      : determine_kprobe_perf_type();
> >  	if (type < 0) {
> > -		pr_warning("failed to determine %s perf type: %s\n",
> > -			   uprobe ? "uprobe" : "kprobe",
> > -			   libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > -		return type;
> > +		if (uprobe) {
> > +			pr_warning("failed to determine uprobe perf type %s: %s\n",
> > +				   name,
> > +				   libbpf_strerror_r(type,
> > +						     errmsg, sizeof(errmsg)));
> > +		} else {
> > +			/* If we do not have an event_source/../kprobes then we
> > +			 * can try to use kprobe-base event tracing, for details
> > +			 * see ./Documentation/trace/kprobetrace.rst
> > +			 */
> > +			const char *file = "/sys/kernel/debug/tracing/events/kprobes/";
> > +			char c[PATH_MAX];
> > +			int fd, n;
> > +
> > +			snprintf(c, sizeof(c), "%s/%s/id", file, name);
> > +
> > +			err = use_kprobe_debugfs(name, offset, pid, retprobe);
> > +			if (err)
> > +				return err;
> 
> Should we throw a pr_warning() here as well when bailing out?

Sure makes sense.

> 
> > +			type = PERF_TYPE_TRACEPOINT;
> > +			fd = open(c, O_RDONLY, 0);
> > +			if (fd < 0) {
> > +				pr_warning("failed to open tracepoint %s: %s\n",
> > +					   c, strerror(errno));
> > +				return -errno;
> > +			}
> > +			n = read(fd, c, sizeof(c));
> > +			close(fd);
> > +			if (n < 0) {
> > +				pr_warning("failed to read %s: %s\n",
> > +					   c, strerror(errno));
> > +				return -errno;
> > +			}
> > +			c[n] = '\0';
> > +			config1 = strtol(c, NULL, 0);
> > +			attr.size = sizeof(attr);
> > +			attr.type = type;
> > +			attr.config = config1;
> > +			attr.sample_period = 1;
> > +			attr.wakeup_events = 1;
> 
> Is there a reason you set latter two whereas below they are not set,
> does it not default to these?

We can drop this.

> 
> > +		}
> > +	} else {
> > +		config1 = ptr_to_u64(name);
> > +		attr.size = sizeof(attr);
> > +		attr.type = type;
> > +		attr.config1 = config1; /* kprobe_func or uprobe_path */
> > +		attr.config2 = offset;  /* kprobe_addr or probe_offset */
> >  	}
> >  	if (retprobe) {
> >  		int bit = uprobe ? determine_uprobe_retprobe_bit()
> > @@ -5033,10 +5102,6 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> >  		}
> >  		attr.config |= 1 << bit;
> >  	}
> 
> What happens in case of retprobe, don't you (unwantedly) bail out here
> again (even through you've set up the retprobe earlier)?

Will fix as well. Looking to see how it passed on my box here but either
way its cryptic so will clean up.

> 
> > -	attr.size = sizeof(attr);
> > -	attr.type = type;
> > -	attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
> > -	attr.config2 = offset;		 /* kprobe_addr or probe_offset */
> >  
> >  	/* pid filter is meaningful only for uprobes */
> >  	pfd = syscall(__NR_perf_event_open, &attr,
> > 


